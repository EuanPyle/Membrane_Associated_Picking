% Function to weight cross-correlation according to relationship with theta(tilt) angle
% i.e. re-weighting to correct for the lower cc score given to particles on top of the membrane due to missing wedge removing membrane

% This script doesnt need editing

function [CCC, P1, P2, P3] = cc_weighting(t)

if size(t,1) < 3
    
    disp('need three or more points!');
    CCC = []; P1 = []; P2 = []; P3 = [];
    
else

fitobj=fit(abs(t(:,8)-90),t(:,10),'poly2');

t(:,10)=t(:,10)./((abs(t(:,8)-90).^2).*fitobj.p1+abs(t(:,8)-90).*fitobj.p2+fitobj.p3);
t(:,10)=t(:,10)./max(t(:,10));
CCC = t;
P1 = fitobj.p1;
P2 = fitobj.p2;
P3 =  fitobj.p3;
end
end 

 
