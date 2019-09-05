addpath /Volumes/data/data4/LHAN/TEST_PARCELLATION/public/Surface_parcellation_distribute/cifti-matlab-master

load('/Users/mxc108120/Desktop/fj1.mat');
cii=ft_read_cifti_mod('/Users/mxc108120/Desktop/sub-MSC01_parcels.dtseries.nii'); % doesn't work in Matlab 2019a


parcel_info = dlmread('~/gitlocal/restinginpca/data/parcel_community/sub-MSC01_node_parcel_comm.txt');

bignet = [1,2,3,5,6,9,10,11,12,13,15];

bignetwork=true;
% Big network
if(bignetwork)
  parcel_info = parcel_info(ismember(parcel_info(:,3), bignet),:);
end

cii_fj1 = cii;
cii_fj1.data(~ismember(cii.data, parcel_info(:,2))) = 0; % set non bignet parcel to 0 

for i = 1:size(parcel_info,1)
   
    parcel_i = parcel_info(i,2);
    cii_fj1.data(cii.data==parcel_i) = sub01(i);
    
end

ft_write_cifti_mod('/Users/mxc108120/Desktop/fj1_sub01.dtseries.nii', cii_fj1)

