%USER INPUT SECTION

%Run this script in the directory containing all the initial_align_TS_X_object_X directories. This directory should also include the cc_threshold.csv file

table = readmatrix('cc_threshold.csv'); %Enter the name of the .csv file containing: TS number, object number, threshold for this object; with each individual object confined to a new line, e.g. 100,1,0.6 as a whole line for tomogram 100, object 1 having a desired CC threshold of 0.6.

iteration_no=1; %If you ran Dynamo alignment for more than 1 iteration, enter the number of iterations you ran here, otherwise leave as 1

%%% END OF USER INPUT SECTION

for i = 1:size(table,1)  
    
    	tomon = table(i,1);
    	tuben = table(i,2);
        cutoff = table(i,3); %cc-threshold number
	
        % Read CC weighted Dynamo table
        t = dread(['initial_align_TS_' num2str(tomon) '_object_' num2str(tuben) '/results/ite_000' num2str(iteration_no) '/averages/cc_weighted.tbl']);
        
        tsel = t((t(:,10)>=cutoff),:); % select particles higher than the threshold cut-off only
        dwrite(tsel,['initial_align_TS_' num2str(tomon) '_object_' num2str(tuben) '/results/ite_000' num2str(iteration_no) '/averages/cc_cleaned.tbl']); %Cleaned table of particles
	
        disp(['tomo ' num2str(tomon) ' object ' num2str(tuben) ' cleaned with a cut off value of ' num2str(cutoff)]);
        
        % write motl 
        tselm = dynamo__table2motl(tsel);
        dwrite(tselm,['initial_align_TS_' num2str(tomon) '_object_' num2str(tuben) '/results/ite_000' num2str(iteration_no) '/averages/cc_cleaned.em']);
end

disp('Written out new CC-cleaned table in intitial_align_TS_X_object_X/results/ite_000X/averages/cc_cleaned.tbl, you can visualise this in PlaceObject with cc_cleaned.em if you want to check the cleaning was successful')
