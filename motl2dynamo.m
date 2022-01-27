% This script will go through all Motive Lists, under the naming convention TS_[tomogram_number]_object_[Object_number].em, and convert them to Dynamo tables. Move this script into the same directory where all the Motive List files are. 

%USER INPUT SECTION

pick_particle='y'; %Did you use the Chimera Pick Particle plug in to generate coordinates? If so, enter 'y' here. If not (i.e. you used the irregular membrane picking protocol), enter 'n'. However, if the pixel size of the tomogram you used to pick particles is 1 (check by typing: header [tomogram_name]), you should enter 'y'. 

pixel_size=10.632; %Enter the pixel size of the tomograms you used to pick particles

%Check the line below will correctly read all the .em files in this directory. Run this in initial_alignments directory. 

list=dir('TS_*_object_*.em'); % This line tells MatLab to look inside all files with this naming convention

%%%END OF USER INPUT SECTION

list_names={list.name}; % This extracts the file names

for i = 1:length(list_names) % This loops through all the files

    tomon=list_names{1,i};
    tomon=char(extractBetween(tomon,'TS_','_object')); % THis extracts the tomogram number
    tuben=list_names{1,i}; 
    tuben=char(extractBetween(tuben,'_object_','.em')); % THis extracts the object number
    
    motl=dread(list_names{1,i}); % Reading motl file
    table=dynamo__motl2table(motl); % Converting to table
    table(:,20)=str2num(tomon); %Entering tomogram number into table
    table(:,21)=str2num(tuben); %Entering object number into table
    if pick_particle=='y'
    table(:,24:26)=(table(:,24:26)./pixel_size);
    end
    dwrite(table,['TS_' tomon '_object_' tuben '.tbl']); %Saving as .tbl
end

disp('Check the Dynamo table coordinates (columns 24 to 26 in XYZ) match the positions of particles you selected in the tomograms.')

