% This script will go through all the alignment projects from Dynamo for each tomogram and object and generate from the output table a Motive List (.em) file called refined_motl_ref_001_ite_0001.em. It uses the dynamo__table2motl() function to do this.

list=dir('initial_align_TS_*_object_*'); % This line tells MatLab to look inside all directories with this naming convention
list=list([list(:).isdir]);
list_names={list.name};

for i = 1:length(list_names)

    tomon=list_names{1,i};
    tomon=char(extractBetween(tomon,'TS_','_object'));
    tuben=list_names{1,i}; % Here, MatLab is extracting the tomogram number from the directory name
    tuben=char(extractAfter(tuben,'object_')); % Here, MatLab is extracting the object number from the directory name
    
    table=dread(['initial_align_TS_' tomon '_object_' tuben '/results/ite_0001/averages/refined_table_ref_001_ite_0001.tbl']); % This tells MatLab where the Dynamo table to convert is.
    table=dynamo__table2motl(table); % Here is the table to Motive List (motl) function
    dwrite(table,['initial_align_TS_' tomon '_object_' tuben '/results/ite_0001/averages/refined_motl_ref_001_ite_0001.em']); % This tells MatLab where to write the table.
    
end

