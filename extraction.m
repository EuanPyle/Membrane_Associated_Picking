% USER INPUT SECTION

%This script will use the Dynamo tables generated by motl2dynamo to extract particles. Move this script into the same directory that all the TS_X_object_X.tbl files are.

%Enter the requested information in the input area

tomo_x=720; %Enter your tomogram dimensions in the X dimension
tomo_y=512; %Enter your tomogram dimensions in the Y dimension
tomo_z=375; %Enter your tomogram dimensions in the Z dimension

box_size=32; %Enter the desired box size of your subtomograms (for the the tomogram you are extracting particles from)

path_to_tomograms='../tomograms/'; %Provide the path to the directories in which all the tomograms you wish to extract from are kept (must all be in one directory). IMPORTANT: Your tomograms must be named TS_[tomogram_number].mrc, e.g. TS_100.mrc. Manually rename them or use sed to give the correct naming convention. Or, alter the dtcrop line so Matlab can read the names of your tomograms.

min_tilt=-60; %The minimum tilt angle of your tilt series
max_tilt=60; %The maximum tilt angle of your tilt series

%%%%%%%%%%% END OF USER INPUT AREA

crop_pixel=round(box_size./2); %Will remove subtomograms that are too close to the tomogram edge (less than half the box size)

path_to_initial_particles='./'; %Will extract particles in this directory

list=dir('./TS_*_object_*.tbl'); 
list_names={list.name}; % This extracts the file names of the tables in list

for i = 1:length(list_names) % This loops through all the files

tomon=list_names{1,i};
tomon=char(extractBetween(tomon,'TS_','_object')); % THis extracts the tomogram number
tuben=list_names{1,i}; 
tuben=char(extractBetween(tuben,'_object_','.tbl')); % THis extracts the object number

initial_table=dread(list_names{1,i}); %Reads the table

initial_table(:,14) = min_tilt; %Tells Dynamo the tilt angles
initial_table(:,15) = max_tilt; 
initial_table(:,13) = 1; % ftype
	
% Following lines Get rid overflowing particles that cause dtcrop to be out of bounds
initial_table(initial_table(:,24) < crop_pixel,:) = []; initial_table(initial_table(:,25) < crop_pixel,:) = []; initial_table(initial_table(:,26) < crop_pixel,:) = [];
initial_table(initial_table(:,24) > (tomo_x-crop_pixel),:) = []; initial_table(initial_table(:,25) > (tomo_y-crop_pixel),:) = []; initial_table(initial_table(:,26) > (tomo_z-crop_pixel),:) = [];

%Extracts particles in table	
dynamo_table_crop([path_to_tomograms '/TS_' tomon '.mrc'],initial_table,[path_to_initial_particles '/TS_' tomon '_object_' tuben],box_size,'maxMb',1500,'allow_padding',true,'inmemory',true) %If you are not using the requested tomogram naming convention, rename the first argument in this function.
	
end
