function ct = matRad_calcWaterEqD(ct, pln)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad function to calculate the equivalent densities from a 
% dicom ct that originally uses intensity values
%
% call
%   ct = matRad_calcWaterEqD(ct)
%
% input
%   ct: unprocessed dicom ct data which are stored as intensity values (IV)
%
%                      HU = IV * slope + intercept
%
% output
%   ct:                 ct struct with cube with relative _electron_ densities 
%
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% conversion from IV to HU
% ct = double(ct.cube{1}) * double(ct.dicomInfo.RescaleSlope) + double(ct.dicomInfo.RescaleIntercept);

% save original iV cube
ct.cubeIV{1} = ct.cube{1};

%% conversion from HU to water equivalent density

% load hlut
hlut = matRad_loadHLUT(ct, pln);

% Manual adjustments if ct data is corrupt. If some values are out of range
% of the LUT, then these values are adjusted.
if max(ct.cubeHU{1}(:)) > max(hlut(:,1))
    warning('projecting out of range HU values');
    ct.cubeHU{1}(ct.cubeHU{1} > max(hlut(:,1))) = max(hlut(:,1));
end
if min(ct.cubeHU{1}(:)) < min(hlut(:,1))
    warning('projecting out of range HU values');
    ct.cubeHU{1}(ct.cubeHU{1} < min(hlut(:,1))) = min(hlut(:,1));
end

% interpolate HU to relative electron density based on lookup table
ct.cube{1} = interp1(hlut(:,1),hlut(:,2),double(ct.cubeHU{1}));

% save hlut
ct.hlut = hlut;

end
