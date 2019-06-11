clear all 
close all 
clc

%% Generate architecture and normalise input vector

load sunspot.dat
%Get columns of sunspot data, years and numbers
year = sunspot(:,1); relNums = sunspot(:,2); %plot(year,relNums)
%Get mean of the numbers
ynrmv = mean(relNums(:));
%Get standard deviation of the numbers
sigy = std(relNums(:)); 

nrmY = relNums; %nrmY=(relNums(:)-ynrmv)./sigy;

%Get minimum and maximum of numbers
ymin = min(nrmY(:)); ymax = max(nrmY(:)); 

%Normalize between -1 and 1
relNums = 2.0*((nrmY-ymin)/(ymax-ymin)-0.5);
% create a vector of lagged values for a time series vector
Ss = relNums';
idim = 10; % input dimension
odim = length(Ss)-idim; % OUTPUTSUM dimension
for i= 1:odim
   y(i) = Ss(i+idim);
   for j = 1:idim
       x(i,j) = Ss(i-j+idim); 
   end
end
Patterns = x'; Desired = y'; NHIDDENS = 5; %prnout=Desired;
[NINPUTS,NPATS] = size(Patterns); [NOUTPUTS] = size(Desired,2);
%Initialize parameters
%LearnRate = 0.001; Momentum = 0; DerivIncr = 0; deltaW1 = 0; deltaW2 = 0;
LearnRate = 1.00;
NHIDDEN = 5;
NOUT = 1;
%INPUTS1= [Patterns;ones(1,NPATS)]; 
INPUTS1 = [ones(1,NPATS); Patterns]; 
INPUTS1 = INPUTS1';
%Generate weights from the size of the number of hiddens given and 1 more
%than the number of inputs. These weights are inputs to hidden. 
WEIGHTS1 =  0.5*(rand(NHIDDENS,1+NINPUTS)-0.5);
%generate weights from hidden to OUTPUTSUM, add extra as a bias
WEIGHTS2 =  0.5*(rand(1,1+NHIDDENS)-0.5);

%WEIGHTS2 = [0.4071   -0.6279   -0.4376   -0.2922   -0.5871    0.7900];

%WEIGHTS1 = [-0.3154   -1.2645   -0.1442    0.2966    0.4817    0.2376    0.1171   -0.0633   -0.3135   -0.3319   -0.2672
%    -0.3418   -0.6550   -0.2938   -0.0682   -0.0586   -0.0129    0.0760   -0.0376    0.1894   -0.1688   -0.2113
%    -0.0321   -1.0422   -0.0185    0.3837    0.2627    0.1564    0.2721    0.0315   -0.0407   -0.4247   -0.1873
%    -0.2317   -1.3389   -0.0465    0.1978    0.4580    0.3664   -0.0019    0.0989   -0.3160   -0.3232   -0.3117
%    -0.1435    0.4430    0.3395    0.1903    0.1890   -0.2317    0.1320   -0.0685    0.2339    0.0249    0.2617];

%Enter epoch loop
epochs = 200;

NINPUTS = 11;
%Initialize
HIDDENOUTa = zeros(1,5);

for epoch= 1:epochs
    
    for pat = 1: NPATS
    
%% Forward pass Input to hidden out (1)
%Inputs * first layer weights
         for j = 1:NHIDDENS  
             for i = 1:NINPUTS          
                INPUT2HIDDEN(j, i) = (INPUTS1(pat,i)) * (WEIGHTS1(j,i)) ;
             end
            %Pass input2hidden through sigmoid to squash
            HIDDENOUTa(j) = 1/(1 + exp(-(sum(INPUT2HIDDEN(j,:)))));
         end
            %add ones 
HIDDENOUT=[ones(1) HIDDENOUTa]; 

%% Forward pass hidden out to output (1)
%hidden outs * second layer weights
for j = 1:NOUTPUTS
    
    for i = 1:NHIDDENS + 1
        HIDDEN2OUT(j,i) = (HIDDENOUT(1, i)) * (WEIGHTS2(1,i));     
    end
    %Summation on output node
   OUTPUTSUM(pat,j)=sum([HIDDEN2OUT(j,:)]);
   
    prnout(pat) = OUTPUTSUM(pat,j);
    
end
%% Backward propagation (1)
%Compute error
Error = Desired(pat,:)-(OUTPUTSUM(pat,:)); 
BETAOUT(pat)= Error;
%Get hidden betas3
if epoch == 1
    BETAOUT(pat) = 1;
end


for i = 1:NHIDDENS +1
    HIDDENBETAS(i) = (1-HIDDENOUT(i).^2).*(WEIGHTS2(i)*1);
end

% End of inital pass

%% Get deltas for weights1 (1)
%Inputs * hidden betas
for j = 1:NINPUTS
    for i = 1:NHIDDENS
        DELTAWEIGHTS1(i,j) = HIDDENBETAS(i+1) * INPUTS1(pat,j);
    end
end
%% Get deltas for weights2 (1)
%Hidden out * 1
for i = 1:NHIDDENS + 1
    DELTAWEIGHTS2(i) = 1 * HIDDEN2OUT(1,i);
end

%% Compute Jacobian
%Merge deltas into Jacobian matrix of first order derivatives
JACOBIAN(pat,:) = [DELTAWEIGHTS2(1,:), DELTAWEIGHTS1(1,:) DELTAWEIGHTS1(2,:) DELTAWEIGHTS1(3,:) DELTAWEIGHTS1(4,:) DELTAWEIGHTS1(5,:)]; 

end    

%% Compute Hessian

HESSIAN=JACOBIAN'*JACOBIAN;

%Apply identity matrix to Hessian, invert Hessian matrix
INVHESSIAN = inv(HESSIAN +(0.001*eye(size(HESSIAN))))/(278*1000);

%% Implement Hessian learning rates
    %% Forward pass input to hidden (2)
for pat = 1 : NPATS 
         
  for j = 1:NHIDDEN
        for i = 1:NINPUTS
            HIDDEN(j,i) = (WEIGHTS1(j,i) * (INPUTS1(pat,i)));
        end
            HIDDENOUT(j) = 1/(1 + exp(-(sum(HIDDEN(j,:))))); %Apply sigmoid
    end
    
    HIDDEN_OUT = [ones(1) HIDDENOUT];
         
    %% Forward pass Hiddenout to output (2)
for j = 1:NOUT
    for i = 1:NHIDDEN + 1
        HIDDEN2OUT(j,i) = (WEIGHTS2(1,i))*(HIDDENOUT(1, i));
    end

%% Output (2)
OUTPUTSUM(pat,j)=sum(HIDDEN2OUT(j,:));
end

%% Backward propagation (2)

Error = Desired - OUTPUTSUM;
TSS = sum(sum(Error.^2));
BETAOUT = Error;

%Betas for weights2 hidden to out
for i = 1:NHIDDEN +1
    BETAHIDDEN(i) = (1-HIDDENOUT(i).^2) .*(WEIGHTS2(i)*BETAOUT(pat));
end
%Get deltas for weights1 inputs to hidden

for j = 1:NINPUTS
    for i = 1:NHIDDEN
        DELTAWEIGHTS1(i,j) = BETAHIDDEN(i+1) * INPUTS1(pat,j);
    end
end

%% Get deltas for weights2 hidden to output

for i = 1: NHIDDEN + 1
    DELTAWEIGHTS2(i) = BETAOUT(pat) * HIDDENOUT(1,i);
end

%% Hidden to ouput Weights2 updates

for j = 1: NHIDDEN +1
    
    WEIGHTS2(j) = INVHESSIAN(j,j) * DELTAWEIGHTS2(j) + WEIGHTS2(j);
end
%% Input --> Hidden 

tdiag = diag(INVHESSIAN); tdiag = tdiag(7:end,:);


hessiandiagonals = [tdiag(1:11,1)'; tdiag(12:22,1)'; tdiag(23:33,1)'; tdiag(34:44,1)'; tdiag(45:55,1)'];

for     i= 1: 5
    for     j= 1: NINPUTS    
        
        WEIGHTS1(i,j)= hessiandiagonals(i,j) * DELTAWEIGHTS1(i,j) + WEIGHTS1(i,j);
       
    end
end
end
%Generate TSS decrease rate vectors 
estore(epoch,1) = epoch;
TSSstore(epoch,1) = TSS;

fprintf('Epoch %3d:  Error = %f\n',epoch,TSS);
end
%% Figures

figure(1);
plot(estore, TSSstore,'-')
ylabel('Sum of errors squared') 
xlabel('Epochs') 
title('TSS rate of decrease 200 epochs (Approximate Hessian)')

% figure(2);
% plot(year(idim+1:278),Desired(idim+1:278),year(idim+1:278),prnout(idim+1:278))
% xlabel('Year')
% ylabel('Sunspots')
plot(year(11:288),Desired,year(11:288),prnout')
