% Plot of neighbour 

function [neighbourPlot,tags,pairs,table_select,table_exclude] = plot_neighbours(table,d_max,d_min,plot_size,mask)

    % copy for final selection
    table2 = table;
    
    % for neighbour plot
    neighbourPlot = zeros(plot_size,plot_size,plot_size);
    
    % cell array of pixel values
    ptlist = cell((plot_size^3),1);
    ptlistmask = ptlist;
    
    % mask indices
    maski = find(mask(:));
    
    % empty lists for selected tags and pairs
    tags = []; 
    pairs = [];
    
    % apply shifts and zero
    table(:,24) = table(:,4) + table(:,24);    
    table(:,25) = table(:,5) + table(:,25);
    table(:,26) = table(:,6) + table(:,26);
    table(:,4:6) = 0;
    
    for i = 1:size(table,1)
        
        % particle and shifts
        p = table(i,:);
        
        % find all distances and select those between thresholds
        d = sqrt(((table(:,24)-p(24)).^2)+((table(:,25)-p(25)).^2)+((table(:,26)-p(26)).^2));
        td = table((d<d_max)&(d>d_min),:);
        
        for j = 1:size(td,1)
            
            % find translation
            x = td(j,24) - p(24);
            y = td(j,25) - p(25);
            z = td(j,26) - p(26);
            
            % rotate vector
            rot = dynamo_euler2matrix(p(7:9));
            rotr = round(rot*[x;y;z]);
            rotr = rotr + ((plot_size/2) + 1);
            if rotr(1)>0 && rotr(2)>0 && rotr(3)>0;
            neighbourPlot(rotr(1),rotr(2),rotr(3)) =  neighbourPlot(rotr(1),rotr(2),rotr(3)) + 1;

            ind = sub2ind(repmat(plot_size,[1,3]),rotr(1),rotr(2),rotr(3));
            
            % mask by matching linear indices
            if ismember(ind,maski)
                ptlistmask{ind} = [ptlistmask{ind},p(1)];
                tags = cat(1,tags,p(1),td(j,1));
                pairs = [pairs;p(1),td(j,1)];
            end
            
            % store tag in linear indices of pixels
            ptlist{ind} = [ptlist{ind},p(1)];
            
        end
        end
    end
    tags = unique(tags);
    table_select = table2(ismember(table(:,1),tags),:);
    table_exclude = table2(~ismember(table(:,1),tags),:);
