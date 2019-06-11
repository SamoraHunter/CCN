clc
clear all

%Place script file ps71089a_ap.m in the same directory as your repro_d... .mat files. 

files = dir('repro*.mat');



% 1 =  male 0 = female
% 1 =  drug 0 = placebo
%    1        2    3    4   5   6   7   8    9    10     11 
%Condition Gender Age Beta 400 600 800 1000 1200 1400  Mean_across

%intervals: 400, 600, 800, 1000, 1200, 1400

%Set up output
output = zeros(600, 11);

%Iterate over data files and fill matrix
for i = 1:length(files)
    
    temp = load(files(i).name);
    %% %Run a within-participant regression analyses in each condition,
        %DV: RTs for each trial within a single participant;
        %IV: stimulus intervals for each trial
        
    beta = regress((temp.data.reproduction(:,2)),(temp.data.reproduction(:,1)));
    %Get participants gender (output column 2)
    if temp.data.gender(1) == 'm'
        output(i, 2) = 1;
    end
    %Get participant Beta for initial regression, output column 4
        output (i, 4) = beta; 
    %Get participant condition, output column 1
    if temp.data.condition(1:7) == 'placebo'
        output (i, 1) = 0;
    else 
        output (i, 1) = 1;
    end
    %Get participant age, output column 3
        output(i,3) = str2num(string(temp.data.age));
    %Get participant mean RT for each condition and collapsed mean, output
    %column 5:10
        a1    = (temp.data.reproduction(:, 2));
        i400  = (temp.data.reproduction(:,1)== 400);
        i600  = (temp.data.reproduction(:,1)== 600);
        i800  = (temp.data.reproduction(:,1)== 800);
        i1000 = (temp.data.reproduction(:,1)== 1000);
        i1200 = (temp.data.reproduction(:,1)== 1200);
        i1400 = (temp.data.reproduction(:,1)== 1400);
        
        output(i, 5) =  mean(a1(i400));
        output(i, 6) =  mean(a1(i600));
        output(i, 7) =  mean(a1(i800));
        output(i, 8) =  mean(a1(i1000));
        output(i, 9) =  mean(a1(i1200));
        output(i, 10) =  mean(a1(i1400));
        output(i, 11) = ((output(i, 5) + output(i, 6) + output(i, 7)+ output(i, 8) + output (i,9) + output(i,10)))/6;
end
        %% Test 1
        
       %runs a t-test to determine whether mean RTs in the
       %placebo condition differ (collapsed across intervals) between genders
       
       iplacebomale   = (output(:,1) == 0) & (output(:,2) == 1);
       iplacebofemale = (output(:,1) == 0) & (output(:,2) == 0);
       PCMa = (output(:,11)); 
       PCMmale = PCMa(iplacebomale);
       PCMfemale = PCMa(iplacebofemale);
       [h1, p1, ci1, stats1] = ttest2(PCMfemale,PCMmale);
       %% Test 2
       
       %runs a Pearson correlational analysis to determine whether mean RTs in the placebo condition
       %(collapsed across intervals) correlate with age
       
       age = output(:,3);
       agev = output(:,3);
       age_placebo = agev(output(:,1) == 0);
       MRTPC = PCMa(output(:,1) == 0);
       
       [rho,pval] = corr(MRTPC,age_placebo);
       
       %% Test 3
       
       %runs a t-test to determine whether mean RTs (collapsed across intervals) differ across conditions
       
       Cond1RTi = output(:,1) == 1;
       Cond2RTi = output(:,1) == 0;
       Cond1M   = (output(: , 11));
       Cond2M   = (output(: , 11));
       RTCond1 = (Cond1M(Cond1RTi));
       RTCond2 = (Cond2M(Cond2RTi));
       
       [h2, p2, ci2, stats2]= ttest(RTCond1 , RTCond2);
       
       %% Test 4
       
       %runs a t-test to determine whether beta coefficients (see above) differ across conditions
       Cond1BCi = output(:,1) == 0;
       Cond2BCi = output(:,1) == 1;
       BC       = output(:,4);
       Cond1BC  = BC(Cond1BCi);
       Cond2BC  = BC(Cond2BCi);
       
       [h3, p3, ci3, stats3] = ttest(Cond1BC , Cond2BC);     
        

%Demographic information:
            Age = output(:, 3);
            %Condition one:
            Age1i = output(:,1) == 0;
            Age1v = Age(Age1i);
            Mean_age1  = mean(Age1v);
            std(Age1v);
            
            %Condition two:
            Age2i = output(:,1) == 1;
            Age2v = Age(Age2i);
            Mean_Age2  = mean(Age2v);
            std(Age2v);

%Participants count in condition group:
tabulate(output(:,1)==1);

%Gender frequency:
tabulate(output(:,2)==1);

%% ttest 1 descriptive statistics:

    %ttest1: mean RTs in the placebo condition differ (collapsed across intervals) between genders
       %Mean/STD male placebo RT:
        MMPRT = mean(PCMmale);
        STD_M_PRT = std(PCMmale);
        STDE_M_PRT = std( PCMmale ) / sqrt( length( PCMmale )); 
       
       %Mean/STD female placebo RT:
        MFPRT = mean(PCMfemale);
        STD_F_PRT = std(PCMfemale);
        STDE_F_PRT = std( PCMfemale ) / sqrt( length( PCMfemale )); 
        
        %Standard error calculations:
        M_RT_PC = PCMa(output(:,1) == 0);
        STDE_M_T_PRT = std( M_RT_PC ) / sqrt( length( M_RT_PC ));
        STDE_F_T_PRT = std( M_RT_PC ) / sqrt( length( M_RT_PC ));
 %% Test 2 Correlation descriptive statistics:
 %Pearson correlational analysis, mean RTs placebo condition, correlate with age      
       %Mean/STD placebo RT:
        M_P_RT   = mean(RTCond1);
        STD_P_RT = std(RTCond1);
       
       %Mean/STD placebo Age: 
        M_AGE_C1   = mean(Age1v);
        STD_AGE_C1 = std(Age1v);
   
        n_corr = (sum(length(Age1v),1) + length(RTCond1)) - 2;
        
        
%%  Test 3 ttest 2 descriptive statistics:
       
       %t-test to determine whether mean RTs (collapsed across intervals) differ across conditions
           %Mean/STD RT Condition 1:
           M_RT_C1   = mean(RTCond1);
           STD_RT_C1 = std(RTCond1);

           %Mean/STD RT Condition 2:
           M_RT_C2   = mean(RTCond2);
           STD_RT_C2 = std(RTCond2);
        
       %Standard error calculations:
        M_RT_PC = PCMa(output(:,1) == 0);
        STDE_C1_RT = std( RTCond1 ) / sqrt( length( RTCond1 ));
        STDE_C2_RT = std( RTCond2 ) / sqrt( length( RTCond2 ));    
            
       
 %% Test 4 ttest 3 descriptive statistics   
    %t-test to determine whether beta coefficients differ across conditions
        %Mean/STD RT Condition 1:
        M_B_C1 = mean(Cond1BC);
        STD_B_C1 = std(Cond1BC);
        
        %Mean/STD RT Condition 2:
        M_B_C2 = mean(Cond2BC);
        STD_B_C2 = std(Cond2BC);
        
        STDE_C1_BC = std( Cond1BC ) / sqrt( length( Cond1BC ));
        STDE_C2_BC = std( Cond2BC ) / sqrt( length( Cond2BC ));   
        
        
 %% Interval descriptives
 %Condition index: 
 %Cond1index = output(:,1) == 0
 %Cond2index = output(:,1) == 1
 
 %Intervals:
 i400m  = (output(:, 5));
 i600m  = (output(:, 6));
 i800m  = (output(:, 7));
 i1000m = (output(:, 8));
 i1200m = (output(:, 9));
 i1400m = (output(:,10));
 
 %Values for interval mean:
 
    %Condition one:
 c1i400m  = i400m(output(:,1)==0);
 c1i600m  = i600m(output(:,1)==0);
 c1i800m  = i800m(output(:,1)==0);
 c1i1000m = i1000m(output(:,1)==0);
 c1i1200m = i1200m(output(:,1)==0);
 c1i1400m = i1400m(output(:,1)==0);
 
    %Condition two:
 c2i400m  = i400m(output(:,1)==1);
 c2i600m  = i600m(output(:,1)==1);
 c2i800m  = i800m(output(:,1)==1);
 c2i1000m = i1000m(output(:,1)==1);
 c2i1200m = i1200m(output(:,1)==1);
 c2i1400m = i1400m(output(:,1)==1);
 
 %Standard errors:
    %Condition one:
 C1STDE_400  = std( c1i400m  ) / sqrt( length( c1i400m ));  
 C1STDE_600  = std( c1i600m  ) / sqrt( length( c1i600m ));  
 C1STDE_800  = std( c1i800m  ) / sqrt( length( c1i800m ));  
 C1STDE_1000 = std( c1i1000m ) / sqrt( length( c1i1000m));  
 C1STDE_1200 = std( c1i1200m ) / sqrt( length( c1i1200m));  
 C1STDE_1400 = std( c1i1400m ) / sqrt( length( c1i1400m));  
    %Condition two:
 C2STDE_400  = std( c2i400m  ) / sqrt( length( c2i400m ));  
 C2STDE_600  = std( c2i600m  ) / sqrt( length( c2i600m ));  
 C2STDE_800  = std( c2i800m  ) / sqrt( length( c2i800m ));  
 C2STDE_1000 = std( c2i1000m ) / sqrt( length( c2i1000m));  
 C2STDE_1200 = std( c2i1200m ) / sqrt( length( c2i1200m));  
 C2STDE_1400 = std( c2i1400m ) / sqrt( length( c2i1400m));  
        

        %% Plots
        
    
    %figure; errorbar(M_RT_PC, STDE_T_PRT) 
   
    %First plot
    
    %errorbar(PCMmale,PCMfemale,M_RT_PC)
        subplot(1,5,1)
        title('T-test one');
        hold on
        bar([MMPRT MFPRT])
        errorbar(1, MMPRT, STDE_M_T_PRT, '.')
        errorbar(2, MFPRT, STDE_F_T_PRT, '.')
        xlabel('Gender (Male = 1, Female = 2)')
        ylabel('Mean placebo RT')
        hold off
        
    %Second plot    
        subplot(1,5,2)
        
        %PCMa,age correlation
         scatter(age, PCMa)
         title('Age placebo mean RT correlation');
         xlabel('Placebo condition age')
         ylabel('Placebo condition mean RT')
    %Third plot : t-test to determine whether mean RTs (collapsed across intervals) differ across conditions    
        subplot(1,5,3)
        title('T-test two');
        hold on
        bar([M_RT_C1 M_RT_C2])
              
        %errorbar(1, MMPRT, STDE_C1_RT, 'marker', '.')
        errorbar(1, M_RT_C1, STDE_C1_RT, 'marker', '.')
        errorbar(2, M_RT_C2, STDE_C2_RT, 'marker', '.')
        xlabel('Condition (Placebo = 1, Panortaxin = 2)')
        ylabel('Mean RT collapsed over intervals')
       
        hold off
            
    %Fourth plot: an error bar plot with means and standard errors for each stimulus interval in each condition, 
        subplot(1,5,4)
        title('Mean interval RT by condition');
        hold on
        
        
        
        br = bar([mean(c1i400m) mean(c1i600m) mean(c1i800m) mean(c1i1000m) mean(c1i1200m) mean(c1i1400m) mean(c2i400m) mean(c2i600m) mean(c2i800m) mean(c2i1000m) mean(c2i1200m) mean(c2i1400m)]);
        
        xlabel('Intervals(1:5 placebo, 6:10 Panortaxin) ')
        ylabel('Mean RT')   
        
       
        %Condition one intervals error bars
        errorbar(1, mean(c1i400m),  C1STDE_400,  '.')
        errorbar(2, mean(c1i600m),  C1STDE_600,  '.')
        errorbar(3, mean(c1i800m),  C1STDE_800,  '.')
        errorbar(4, mean(c1i1000m), C1STDE_1000, '.')
        errorbar(5, mean(c1i1200m), C1STDE_1200, '.')
        errorbar(6, mean(c1i1400m), C1STDE_1400, '.')
        
        %Condition two intervals error bars
        errorbar(7,  mean(c2i400m),  C2STDE_400,  '.')
        errorbar(8,  mean(c2i600m),  C2STDE_600,  '.')
        errorbar(9,  mean(c2i800m),  C2STDE_800,  '.')
        errorbar(10, mean(c2i1000m), C2STDE_1000, '.')
        errorbar(11, mean(c2i1200m), C2STDE_1200, '.')
        errorbar(12, mean(c2i1400m), C2STDE_1400, '.')
        
        hold off
        
    %Fifth plot: t-test results to determine whether beta coefficients differ across conditions
         subplot(1,5,5)
         hold on
         title('T-test three');
         bar([M_RT_C1 M_RT_C2])
             
         errorbar(1, M_RT_C1, STDE_C1_BC,'.')
         errorbar(2, M_RT_C2, STDE_C2_BC,'.')
          xlabel('Condition (Placebo = 1, Panortaxin = 2)')
          ylabel('Beta coefficients')   
        hold off

 
data.description =( ['Test one:' newline 'The mean of the placebo group male reproduction times is ', num2str(MMPRT) newline 'The standard deviation of the placebo group male reproduction times is ',num2str(STD_M_PRT) newline 'The mean of the placebo group female reproduction times is ',num2str(MFPRT) newline 'The standard deviation of the placebo group female reproduction times is ',num2str(STD_F_PRT) newline newline 'Independent samples T test: t(', num2str(stats1.df) ') =' , num2str(stats1.tstat),', p=' num2str(p1) newline newline 'Test two:' newline 'The mean of the placebo group reproduction times is ',num2str(M_P_RT) newline 'The standard deviation of the placebo group reproduction times is ', num2str(STD_P_RT) newline 'The mean of the placebo group age is ', num2str(M_AGE_C1) newline 'The standard deviation of the placebo group age is ', num2str(STD_AGE_C1) newline newline 'Pearsons correlation, mean RT placebo condition and age, r =' num2str(rho)  ' , n =' num2str(n_corr) ', p =' num2str(pval)  newline newline 'Test three:' newline 'The mean of the mean collapsed across intervals placebo reproduction time is ', num2str(M_RT_C1) newline 'The mean of the standard deviation of the collapsed across intervals placebo reproduction time is ', num2str(STD_RT_C1) newline 'The mean of the mean collapsed across intervals drug condition reproduction time is ', num2str(M_RT_C2) newline 'The mean of the standard deviation of the collapsed across intervals drug condition reproduction time is ', num2str(STD_RT_C2) newline newline 'Paired samples T test, mean RT (collapsed over intervals) and condition: t(', num2str(stats2.df) ') =' , num2str(stats2.tstat),', p=' num2str(p2) newline newline 'Test four:' newline 'The mean of the beta coefficients from the placebo condition is ', num2str(M_B_C1) newline 'The standard deviation of the beta coefficients from the placebo condition is ', num2str(STD_B_C1) newline 'The mean of the beta coefficients from the drug condition is ', num2str(M_B_C2) newline 'The standard deviation of the beta coefficients from the drug condition is' , num2str(STD_B_C2) newline newline 'Paired samples T test, beta coefficients and condition: t(', num2str(stats3.df) ') =' , num2str(stats3.tstat),', p=' num2str(p3) newline ]);
       
h = data.description

     
 
%uncomment to view output matrix
%output