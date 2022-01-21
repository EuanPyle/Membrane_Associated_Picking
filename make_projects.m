% Loop for creating initial alignment projects

% User input area
% Make sure the project you want to copy is called 'initial_align'

% Run this script in the directory with TS_*_object_*.tbl files i.e. where you ran extraction.m

list=dir('TS_*_object_*.tbl');

% End of user input area 
list={list.name}; % This extracts the file names of the tables in list

for i = 1:length(list)
    
    tomon=list{1,i};
    tomon=char(extractBetween(tomon,'TS_','_object')); % THis extracts the tomogram number
    tuben=list{1,i}; 
    tuben=char(extractBetween(tuben,'_object_','.tbl')); % THis extracts the object number
    
    % specify data
    data = ['TS_' tomon '_object_' tuben ];
    table = ['TS_' tomon '_object_' tuben '/crop.tbl'];
    new = ['initial_align_TS_' tomon '_object_' tuben ];
    
    % copy project 
    dvcopy('initial_align',new);
    dynamo_vpr_put(new,'data',data,'table',table);
    dvcheck(new);
    dvunfold(new);    
end
