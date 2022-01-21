function create_gridpoint_and_normals(surface_filename,thr); %surface_filename should be a string containing the file name of the saved object density (without the extenstion i.e. .mrc or .em), and thr should be a number containing the threshold. Start with 1 and adjust if the subtomogram coordinates do not superimpose well with the membrane

% USER INPUT SECTION

addpath(genpath('./tomo_functions')); %Provide the path to the tomo_functions folder 

grid_sampling=4; %Number of pixels between the extraction of each subtomogram. This should be LESS than the known distance between two particles as we want to oversample the membrane. This should be in BINNED particles, i.e. the distance 

file_extension_name='.mrc'; % Enter the file name extension, e.g. .mrc (include the .)

%%% END OF USER INPUT SECTION

vol=dread([surface_filename file_extension_name]);

[mean, mx, mn, std, var] = tom_dev(vol);
cont=mean+std*thr;

[xx,yy,zz]= meshgrid(1:size(vol,2), 1:size(vol,1), 1:size(vol,3));
weightedxx=xx.*vol;
weightedyy=yy.*vol;
weightedzz=zz.*vol;

cent=[sum(weightedyy(:))./sum(vol(:)), sum(weightedxx(:))./sum(vol(:)), sum(weightedzz(:))./sum(vol(:))];       
        
%generate surface
surf=isosurface(vol,cont); %determines vertices coordinates for all pixels on surface

% The following lines are to select vertices at sampling distance
if size(surf.vertices)>[0,0]		
	orig=[round(surf.vertices(1,1)),round(surf.vertices(1,2)),round(surf.vertices(1,3))];
        coos_keep=orig;
        for i=1:size(surf.vertices,1)
            flag=1;
            for j=1:size(coos_keep)      			     dist=sqrt((surf.vertices(i,1)-coos_keep(j,1)).^2+(surf.vertices(i,2)-coos_keep(j,2)).^2+(surf.vertices(i,3)-coos_keep(j,3)).^2); 
                if dist < grid_sampling
                    flag=0;
                end
            end
            if flag==1 
            coos_keep=cat(1,coos_keep,[round(surf.vertices(i,1)),round(surf.vertices(i,2)),round(surf.vertices(i,3))]);
            end
        end

%for each sampled coordinate calculate twin point on a normal line
n=isonormals(vol,coos_keep);

%flip hand: x and y are flipped by the isosurface command for some annoying reason
surf_vertices_temp=coos_keep(:,2);
coos_keep(:,2)=coos_keep(:,1);
coos_keep(:,1)=surf_vertices_temp;

surf_vertices_temp=n(:,2);
n(:,2)=n(:,1);
n(:,1)=surf_vertices_temp;

%write motivelist with coordinates and run normalvec. motl will need to be modified to include tomogram number particle numbers etc.
motl=zeros(20,size(coos_keep,1));
motl(8:10,:)=transpose(coos_keep);
motl_n=[];

for i=1:size(motl,2)
	motl_i=normalvec(motl(:,i),[coos_keep(i,1)-round(500*n(i,1)),coos_keep(i,2)-round(500*n(i,2)),coos_keep(i,3)-round(500*n(i,3))]);
        dist_p_to_cent=(motl(8,i)-cent(1)).^2+(motl(9,i)-cent(2)).^2+(motl(10,i)-cent(3)).^2;
                   dist_ison_to_cent=((coos_keep(i,1)-round(500*n(i,1)))-cent(1)).^2+((coos_keep(i,2)-round(500*n(i,2)))-cent(2)).^2+((coos_keep(i,3)-round(500*n(i,3)))-cent(3)).^2;
	if dist_p_to_cent>dist_ison_to_cent
                motl_i(20,1)=1;
        	end
        if dist_p_to_cent<dist_ison_to_cent
                motl_i(20,1)=2;
                end
        
        motl_n=cat(2,motl_n,motl_i);
end
motl_n(8:10,:)=transpose([coos_keep(:,1)-round(500*n(:,1)),coos_keep(:,2)-round(500*n(:,2)),coos_keep(:,3)-round(500*n(:,3))]);     

%write out your motivelist
motlname=[surface_filename '.em'];
tom_emwrite_mod(motlname,motl_n);
end

if size(surf.vertices)==[0,0]
motl_n=[];
motlname=[surface_filename '.em'];
tom_emwrite(motlname,motl_n);
end

