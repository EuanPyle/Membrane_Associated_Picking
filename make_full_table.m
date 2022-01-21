% USER INPUT SECTION
%This script will make a single Dynamo table of your particles by concatenating all of the tables for each object together

%Move this script into directory the initial_align_TS_* directories

table_name='neighbour_cleaned.tbl'; %Enter the name of the final table produced by particle cleaning. Look inside initial_align_TS_X_object_X/results/ite_0001/averages/ for the output table of your final particle cleaning process. Simply enter the file name. If you want to make a full table without particle cleaning, the dynamo table should be called something like: refined_table_ref_001_ite_0001.tbl

iteration_no=1; %If you ran Dynamo alignment for more than 1 iteration, enter the number of iterations you ran here, otherwise leave as 1

%%%% END OF USER INPUT SECTION

objects=dir('initial_align_TS_*'); %Reads the initial_align_TS_* directories
list=objects([objects(:).isdir]);
directories={list.name};

% total table
t_all = [];

for i = 1:length(directories)

tomon=directories{1,i};
tomon=char(extractBetween(tomon,'TS_','_object'));
tuben=directories{1,i};
tuben=char(extractAfter(tuben,'object_')); % Here, MatLab is extracting the object number from the directory name

look=['initial_align_TS_' tomon '_object_' tuben '/results/ite_000' num2str(iteration_no) '/averages/' table_name];
if isfile(look)
t = dread(look);
if t == 0
continue
end
t(:,20) = str2num(tomon); %Assigns tomogram number to table
t(:,21) = str2num(tuben); %Assigns object number to table
t_all = cat(1,t_all,t);
else
continue        
        
end
end

% make real, not complex
t_all = real(t_all);

t_all(:,1)=[1:size(t_all,1)];

% write newly cleaned table
dwrite(t_all,'total_particles.tbl');

disp('Full table written as total_particles.tbl');
