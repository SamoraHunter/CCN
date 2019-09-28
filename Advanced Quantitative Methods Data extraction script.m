%% Advanced quantitative methods
% Data extraction script
%AQMv10

clc;
clear all;

%Initialize output matrix
SupraMatrix = [];

%% Load each dat file in order
for j = 1:40
    
    filestring = 'S.DAT'; filename = insertAfter(filestring,1,num2str(j));  %Create filenames by inserting j into filestring

%call importfile function to extract raw data from .DAT (current file)
data = importfile(filename);   

%% Extract subject number
    subnum1 = string(table2array(data(1,1))); sumnum = repmat(subnum1,70,1); %Read raw data, create a column vector for subject number read
    
%% Read counter balance condition
%Create sub matrix of FnoA data depending on data position recorded in file
if string(table2array(data(5,1))) == "AnoF"
    
    output = data(77:end,:); output1 = output(1:56,1:8); output2 = output(58:end,1:8); output3 = [output1; output2]; 
    FnoAorder = repmat(2,70,1);
end
if string(table2array(data(5,1))) == "FnoA"
    output = data(7:77,:); output1 = output(1:56,1:8); output2 = output(58:end,1:8); output3 = [output1; output2]; 
end

%Get CB condition from raw file data
cbcond = cell2mat(table2array(data(2,1)));
cbcond = repmat(cbcond,70,1);

%% Headings defined for final table output
Headers = ["subno" "FnoAorder" "FnoAformat" "cbcond" "trialnum" "phase" "include" "cue1" "cue2" "cue3" "cue4" "outcome" "response" "prob_out1" "resp_rew" "resp_corr" "RT" "FnoAcorr" "Nitems_FnoA"];

%% FnoA type Disease or weather extraction
 fnoatype1 = string(table2array(data(74,1)));
 
 if fnoatype1 == "disease"  %Read Disease or Weather condition from raw file data
         fnoaformat = repmat("Fbk=D",70,1); %Create vector of fnoa type
     else 
         fnoaformat = repmat("Fbk=W",70,1);
 end
 
Formatvector (j,1) = fnoaformat(1,1);
for i = 1:40
    if Formatvector(j,1) == "Fbk=D"
        Formatvector(j,1) = 1;
    end
   
    if Formatvector(j,1) == "Fbk=W" 
        Formatvector(j,1) = 2;
    end
end

 
%% Trial number extraction
trialnum = table2array(output3(:,1)); Trialnumber = 1:1:(size(trialnum,1)); Trialnumber = Trialnumber'; %Get raw trialnum data; Get size of trialnum data; generate vector of size of trialnum; transpose.

%% Software bug fix
%if FnoA condition second in .Dat (Therefore AnoF first), set include to 0. 
includevector = ones(70,1);
if string(table2array(data(75,1))) == 'FnoA'
    includevector(53:56,1) = 0;
end

%% Phase 
for i = 1:70 
    if i<57                         %For the first 57 assign "train"
    phasevector(i,1) = "train";     %Generate phase vectors
    else
    phasevector(i,1) = "test";      %Assign "test" for the remaining. 
    end
end

%% Cue values
Cuematrix = output3(:,2:5); %Extract cue values from raw data>output3 matrix

%% Outcome 
%Extract raw outcome data
outcomevec = cell2mat(table2array(output3(1:70,6)));
identityvec =  zeros(70,1); 
for i = 1:56 %Generate identity vector for "train" trials
    identityvec(i,1) = 1;
end
%Apply identity vector to raw outcome data
Outcomevector = zeros(70,1); Outcomevector = str2num(outcomevec) + identityvec ; Outcomevector = Outcomevector .* identityvec;

for i = 1:56 
    if Outcomevector(i,1) == 1
        Outcomevector(i,1) = 2; %Bit flip outcome vector values to match sample 
    else
        Outcomevector(i,1) = 1;
    end
end

%% Response_reward

responserewardvec1 = str2num(cell2mat(table2array(output3(1:56,7)))); identityvec2 = zeros(70,1); %Extract raw responsereward data
responserewardvec1(numel(identityvec2)) = 0;
% for i = 1:size(responserewardvec1,1)
%     responserewardvec1(i) = (responserewardvec1(i)) + 0;
% end
responsevec2 = cell2mat(table2array(output3(57:end,6)));
for i = 1:size(responserewardvec1,1)
    if responserewardvec1(i,1) == 1
            responserewardvec1(i,1) = 0;
    if responserewardvec1(i,1) == 0
            responserewardvec1(i,1) = 1;
    end
    end
    
end


%% Response time
rt1a = (table2array(output3(1:56,8)));
 for i = 1:size(rt1a,1)
    rt1a(i,1) =  regexprep((rt1a(i,1)),'%',''); %Remove nuisance character"%" from raw data
 end
%Extract response time from raw data>output3
rt1 = str2num(char(string(cellfun(@str2num,rt1a)))); rt2 = str2num(char(string(cellfun(@str2num,(table2array(output3(57:70,7)))))));
rt = [rt1; rt2];

%% Probability outcome one

prob =(str2double(table2array(output3(:,2:5)))); probtally = 0; %Extract cue matrix
for i = 1:size(prob,1) %Calculate probability of outcome one
    probtally = 0.5; %Initial probability value
    
    if prob(i,1) == 1
    probtally = probtally + 0.25; %If first or second cue is one, increase probability
    end
    if prob(i,2) == 1
    probtally = probtally + 0.25; 
    end
    if prob(i,3) == 1
    probtally = probtally - 0.25; %If third or fourth cue is one, decrease probability
    end
    if prob(i,4) == 1
    probtally = probtally - 0.25;
    end
    
    probtallymatrix(i,1) = probtally; %Store tally in vector for output
    
    probtally = 0; %reset tally for next subject
    
    
end
            
%% Response

responsevector1 =  zeros(56,1); 
for i = 1:56
 if responserewardvec1(i,1) == 1 %Logical calculus; If response was rewarded then outcome must equal the response. 
     responsevector1(i,1) = Outcomevector(i,1);
 else
     if Outcomevector(i,1) == 1 %If not, then must equal the contrary
         responsevector1(i,1) = 2;
     end
         if Outcomevector(i,1) == 2
             responsevector1(i,1) = 1;
         end             
 end
 responsevector2 = str2num(cell2mat(table2array(output3(57:end, 6)))); %Extract raw response data from test phase
 responsevector = [responsevector1; responsevector2];
end

%Apply bugfix to response reward
responserewardvec1 = responserewardvec1 .* includevector; %If bug on trial record response reward as 0

%% Response correct
responsecorrect = zeros(70,1); %Initialize for speed and 0 values for incorrect responses. 
for i = 1:70
if responsevector(i,1) == 1   
    if prob(i,1) + prob(i,2) > prob(i,3) + prob(i,4); %If response is one and the cues are greater for the first two trials, response is correct. 
    responsecorrect(i,1) = 1;
    end 
end
if responsevector(i,1) == 2 
    if prob(i,1) + prob(i,2) < prob(i,3) + prob(i,4); %If response is two and the cues are lesser for the first two trials, response is correct. 
    responsecorrect(i,1) = 1;
    end 
    
end
end

%% Nitems_FnoA
 nitemsvector = zeros(70,1); count = 0;     %Count number of trials to be included:   
for i = 1:size(rt(57:end),1)             %Count trials.  
    if probtallymatrix(56+i,1) ~= 0.5    %Don't count trials where probability is = 0.5. 
        if (rt(56+i,1)) > 0.2            %Only count trials where rt was not erroneously low.  200ms is threshold for inclusion. 
            count = count +1;
        end
    end
end
nitems = count; nitemsvector(1,1) = nitems;

%% Proportion of normative
%Number of responses correct in test phase divided by the number of items included. 
FnoAcorrvector = zeros(70,1); FnoAcorr = (sum(responsecorrect(57:end,1)))/nitems; FnoAcorrvector(1,1) = FnoAcorr;

%% Final output matrix
%Headers = ["subno" "FnoAorder" "FnoAformat" "cbcond" "trialnum" "phase" "include" "cue1" "cue2" "cue3" "cue4" "outcome" "response" "prob_out1" "resp_rew" "resp_corr" "RT" "FnoAcorr" "Nitems_FnoA"];
%Append individual column vectors to final matrix for output
FOM = [sumnum FnoAorder fnoaformat cbcond  Trialnumber phasevector includevector prob Outcomevector responsevector probtallymatrix responserewardvec1 responsecorrect rt FnoAcorrvector nitemsvector];

%% Construct supra matrix
%Append each additional output matrix to a supra matrix to store all subjects data
SupraMatrix = [SupraMatrix; FOM];



end

%% Write output matrix to file

T = array2table(string(SupraMatrix)); %Convert to table

T.Properties.VariableNames = Headers; %Attach headers    

%Write table to excel file
writetable(T,'myData.csv','Delimiter',',','QuoteStrings',true);


