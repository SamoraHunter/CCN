function [output, blocks_mat, trialnum, blocknum] = blocksetup(blocknum,trialnum)
%[output blocks_mat  trialnum, blocknum] = blocksetup(1,10)


%% STIMULUS MATRIX
% 1 coded for even, 2 coded for odd
stim_mat=          [0 1;
                    1 2;
                    2 1;
                    3 2;
                    4 1;
                    5 2;
                    6 1;
                    7 2;
                    8 1;
                    9 2];
 % repeat matrix based on number of trials per block
stim_mat=repmat(stim_mat,trialnum/size(stim_mat,1),1);

%% PERMUTATION OF MATRIX & SETTING UP BLOCKS
for bn=1:blocknum
    blocks_mat((trialnum*bn-(trialnum-1)):trialnum*bn,:)=stim_mat(randperm(size(stim_mat,1)),:);
end

%% PREPARE OUTPUT
output = zeros(size(blocks_mat,1),4);
end

