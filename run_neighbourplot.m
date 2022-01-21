% Run Neighbour analysis

% USER INPUT SECTION

%Run this script in the directory containing all the initial_align_TS_X_object_X directories. 

addpath(genpath('../../tomo_functions')); %Provide the path to the tomo_functions folder

iteration_no=1; %If you ran Dynamo alignment for more than 1 iteration, enter the number of iterations you ran here, otherwise leave as 1

table_name='cc_cleaned.tbl'; %File name of the latest Dynamo table in initial_align_TS_X_object_X/results/ite_000X/averages/. If you have carried out CC cleaning this should be something like 'cc_cleaned.tbl', if you have not, should be something like 'refined_table_ref_001_ite_0001.tbl'

plot_size=100; %In pixels. Sets a box size around which the analysis will search each subtomogram for other subtomograms within this distance. 100 works well for our data.

min_distance = 4; %In pixels. Sets the minimum distance in which you would expect to find a neighbouring subtomogram. Any subtomogram closer than this distance is considered a duplicate subtomgram as opposed to a neighbouring one.

max_distance = 20; %In pixels. Sets the maximum distance in which you would expect to find a neighbouring subtomogram. Any subtomogram further than this distance is not considered to be a neighbouring one.

%%% END OF USER INPUT SECTION

neighb_all=zeros(plot_size,plot_size,plot_size);

list=dir('initial_align_TS_*_object_*');
list=list([list(:).isdir]);
list={list.name}; % This extracts the file names of the tables in list

for i = 1:length(list)
    
    tomon=list{1,i};
    tomon=char(extractBetween(tomon,'TS_','_object')); % This extracts the tomogram number
    tuben=list{1,i}; 
    tuben=char(extractAfter(tuben,'object_')); % Here, MatLab is extracting the object number from the directory name

    
    tb=dread(['initial_align_TS_' tomon '_object_' tuben '/results/ite_000' num2str(iteration_no) '/averages/' table_name]);
    
    [neighbourPlot,tags,pairs,table_select,table_exclude] = plot_neighbours(tb,max_distance,min_distance,plot_size,ones(plot_size,plot_size,plot_size));
    
    neighb_all=neighb_all+neighbourPlot;
end

dwrite(neighb_all,'all_neighbour.em');
