function [a,b,c,d,e]=tom_dev(A,suppress);
%TOM_DEV Calculates the mean, max, min, standard-deviation, variance
%   of an input image
%
% Example:
%           [mean, max, min, std, variance] = tom_dev(IN,flag)
%PARAMETERS
%   
%   IN      : input image
%   flag    : This is optional.
%               -'noinfo' Not display the information
%
%   mean    : Mean value
%   max     : maximum value
%   min     : minimum value
%   Std     : standard deviation
%   variance: Variance of image
%
% EXAMPLE
%   im = tom_emread('proteasome.em');
%   tom_dev(im.Value);
%
%    Copyright (c) 2004
%    TOM toolbox for Electron Tomography
%    Max-Planck-Institute for Biochemistry
%    Dept. Molecular Structural Biology
%    82152 Martinsried, Germany
%    http://www.biochem.mpg.de/tom 
% 
%
% 18/03/2002AF. Tested FF%   
% Modified: 11/07/03 WDN

error(nargchk(1,2,nargin))
[s1,s2,s3]=size(A);
a=sum(sum(sum(A)))/(s1*s2*s3);
b=max(max(max(A)));
c=min(min(min(A)));
d=std2(A);
e=d.^2;
if nargin <2
    f=sprintf('Mean= %g,  Max= %g,  Min= %g,  Std= %g,  Variance= %g', a,b,c,d,e);disp(f);
elseif nargin==2
    switch suppress
        case 'noinfo'
            %no action
        otherwise
            f=sprintf('Mean= %g,  Max= %g,  Min= %g,  Std= %g,  Variance= %g', a,b,c,d,e);disp(f);
    end
end
