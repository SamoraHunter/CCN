function [] = nback9(id)

%% Function runs an N back task
%%output saved to file [Stim obj_stim_dur key_pressed RT Corr/incor nback]


%% INPUTS
%id = id number (use two digits, eg '01')

ID = id;

%% SCREEN
Screen('Preference', 'SkipSyncTests', 1); 
screens=Screen('Screens');
screenNumber=max(screens);
gray=GrayIndex(screenNumber);
%[w, wRect]=Screen('OpenWindow',screenNumber, gray);
[w, wRect] = Screen('OpenWindow',screenNumber, gray,[0 0 640 480]);
[width, height]=Screen('WindowSize', w, []);
% Hide the mouse cursor:
HideCursor;

%% IFI
ifi=Screen('GetFlipInterval',w);
ificorr=.008;

%% MASK PARAMETERS 
mask_dur=2;
maskdim =  [0 0 640 480];
%% ISI PARAMETERS
isi_dur =.5;

%% RESPONSE OPTIONS
resp_options = 'Yes (1)      No (2)';

%% TIME & DATE STAMP (for output file)
timeday_stamp=datestr(clock);
time_stamp=str2num([timeday_stamp(end-7:end-6) timeday_stamp(end-4:end-3) timeday_stamp(end-1:end)]);
day_stamp=datenum(date);


%% Call block setup
%blocksetup(number of blocks, numbers of trials)
%has been tested with "1 block, 10 trials" settings. 
Number_of_blocks = 2;
Number_of_trials_per_block = 50;
Total_trials = Number_of_blocks * Number_of_trials_per_block;


[output blocks_mat trialnum blocknum] = blocksetup(1,Total_trials);

 
%% KEYBOARD CHECK & WINDOW PRIORITY
KbCheck;
WaitSecs(0.01);
Priority(MaxPriority(w));

%% TASK VERSIONS & INSTRUCTIONS
% main instructions
task_instructions='Report whether true or false for stimulus parity(even/odd) two back in the sequence of numbers\n\n The first two trials are dummy trials \n\n Press 1 for no, 2 for yes.\n \nPress any key to begin.';
% between-block instructions
bb_instructions='Please take a moment to relax.\n\n The first three trials are dummy trials\n\n Report whether true or false for stimulus parity(even/odd) three back in the sequence of numbers \n\n Press any key when you are ready to begin again.';


%% PRESENT INSTRUCTIONS
Screen('TextSize', w, 22);
Screen('TextFont', w, 'Arial');
DrawFormattedText(w, task_instructions,'center', 'center', WhiteIndex(w));       
% flip instructions screen
time2flip=0; resp.VBLTimestamp=Screen('Flip',w,time2flip);
% wait for response
t_ini = GetSecs();
while (GetSecs() - t_ini <100)
    keyIsDown = KbCheck; 
    %[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    if keyIsDown == 1
        break
    end
end
         
%% EXPERIMENTAL TRIALS
% specify starting points for blocks
blocktrialstarts=1:trialnum:size(blocks_mat,1);


    
   
    % for-loop for trials
    for trials = 1:trialnum
        
        
        %% STIMULUS
        stim =  num2str(blocks_mat(trials));
        
       
        % increase font size
        Screen('TextSize', w, 60);
                
        %% TRIAL START
        time2flip=0; trialstart.VBLTimestamp=Screen('Flip',w,time2flip);
        
       
        Screen('TextSize', w, 100);
        %% ISI (blank screen)
        DrawFormattedText(w, '+','center', 'center', [0 0 0]);
        time2flip=trialstart.VBLTimestamp+ificorr; isi.VBLTimestamp=Screen('Flip',w,time2flip);
        Screen('TextSize', w, 60);
        
        %% STIMULUS
        DrawFormattedText(w, stim,'center', 'center', [0 0 0]);
        time2flip=isi.VBLTimestamp+isi_dur-ificorr; stimulus.VBLTimestamp=Screen('Flip',w,time2flip);
        
        %% MASK
        Screen('FillRect', w, [211 211 211],maskdim)
        time2flip=stimulus.VBLTimestamp+ifi-ificorr; mask.VBLTimestamp=Screen('Flip',w,time2flip);
        
        %% ISI (blank screen)
        DrawFormattedText(w, '','center', 'center', WhiteIndex(w));
        time2flip=mask.VBLTimestamp+mask_dur-ificorr; isi.VBLTimestamp=Screen('Flip',w,time2flip);
        
        %% JUDGMENT SCREEN
        DrawFormattedText(w, resp_options,'center', 'center', [0 0 0]);
        time2flip=isi.VBLTimestamp+isi_dur-ificorr; judge.VBLTimestamp=Screen('Flip',w,time2flip);

        %% RESPONSE OUTPUT (resp = key & rt)
        t_ini = GetSecs();
        while (GetSecs() - t_ini <100)
            [keyIsDown, secs,keyCode, deltaSecs] = KbCheck; 
            if keyIsDown == 1
                kbNameResult = KbName(keyCode);
                resp = [str2num(kbNameResult(1)) secs-t_ini];
                break
            end
        end
    if trials == trialnum/2
    WaitSecs(5)
           %% PRESENT BETWEEN-BLOCK INSTRUCTIONS
    
    Screen('TextSize', w, 15);
    DrawFormattedText(w, bb_instructions,'center', 'center', [0 0 0]);       
    % flip instructions screen
    time2flip=GetSecs+.010; pre_instruct.VBLTimestamp=Screen('Flip',w,time2flip);
    
    % wait for response
    t_ini = GetSecs();
    while (GetSecs() - t_ini <100)
        keyIsDown = KbCheck; 
        if keyIsDown == 1
            break
        end
    end
       end
        
        
        output(blocktrialstarts+trials-1,:)=[2 isi_dur-ificorr resp];
    end



%% PRINT % OF STIMULI > 17MS
stimtime=[size(output(output(:,2)>.017,:),1)/size(output,1)];

%% %% Results calculations nback2
nback = 2;
	

	 for i = 1:size(blocks_mat,1)
     if i >(size(blocks_mat,1)/2)
         nback = 3
     end
     output(i,6) = nback
	 if i > nback
		if output(i,3) == 2 
			if blocks_mat(i,2) == blocks_mat((i-nback),2);
				output(i,5) = 1;
                
					end 
				end
			
		if output(i,3) == 1
			if blocks_mat(i,2) ~= blocks_mat((i-nback),2);
				output(i,5) = 1;
                
					end
				end
			else 
		
		output(i,5) = 1;
		
     end
     end


     
     %% %% SAVE OUTPUT AFTER EACH BLOCK
    save([num2str(ID) '_' num2str(time_stamp) '_' num2str(today)],'output','-ASCII');
     

%% END experiment
Screen('CloseAll');
clear Screen
ShowCursor;
fclose('all');
Priority(0);



end

