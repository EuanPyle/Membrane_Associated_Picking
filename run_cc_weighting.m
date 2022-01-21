% Apply CC weighting
% USER INPUT SECTION

%Run this script in the directory containing all the initial_align_TS_X_object_X directories. 

addpath(genpath('../../tomo_functions')); %Provide the path to the tomo_functions folder 

iteration_no=1; %If you ran Dynamo alignment for more than 1 iteration, enter the number of iterations you ran here, otherwise leave as 1

table_name='refined_table_ref_001_ite_0001.tbl'; %File name of the output of the Dynamo alignment in initial_align_TS_X_object_X/results/ite_000X/averages/, should be something like refined_table_ref_001_ite_0001.tbl

%%% END OF USER INPUT SECTION

list=dir('initial_align_TS_*_object_*');
list=list([list(:).isdir]);
list={list.name}; % This extracts the file names of the tables in list

for i = 1:length(list)
    
    tomon=list{1,i};
    tomon=char(extractBetween(tomon,'TS_','_object')); % THis extracts the tomogram number
    tuben=list{1,i}; 
    tuben=char(extractAfter(tuben,'object_')); % Here, MatLab is extracting the object number from the directory name

    table2check = ['initial_align_TS_' num2str(tomon) '_object_' num2str(tuben) '/results/ite_000' num2str(iteration_no) '/averages/' table_name];
    
    if isfile(table2check)
    
    disp(['Running CC weighting on tomo ' num2str(tomon) ' object ' num2str(tuben) ]);
    t = dread(['initial_align_TS_' num2str(tomon) '_object_' num2str(tuben) '/results/ite_000' num2str(iteration_no) '/averages/' table_name]);
    
    % ccc weighting for manual thresholding
    [CCC, P1, P2, P3] = cc_weighting(t);
    
    % write CC weighted files as cc_weighted.em/.tbl
    dwrite(CCC,['initial_align_TS_' num2str(tomon) '_object_' num2str(tuben) '/results/ite_000' num2str(iteration_no) '/averages/cc_weighted.tbl']);
    CCCm = dynamo__table2motl(CCC);
    dwrite(CCCm,['initial_align_TS_' num2str(tomon) '_object_' num2str(tuben) '/results/ite_000' num2str(iteration_no) '/averages/cc_weighted.em']);
   
    else
        disp(['Alignment not done yet for tomo ' num2str(tomon) ' object ' num2str(tuben) ' due to not being able to find table']);
        continue
    end
    
end
