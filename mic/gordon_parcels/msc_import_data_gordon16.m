function DTs = msc_import_data_gordon16(sub, sess)

% input:
%   sub:    subid (a string, such as '01', '05', '10')
%   sess:   session id (a string, such as '01', '02', '10')
%
% output:
%   DTs:    parcel-wise time series

% define paths
path_data = '/data/datax/data3/MSC/derivatives/surface_pipeline';
path_parc = '/data/data4/LHAN/gordon_parcels';

%------------
% medial wall
medialw_L = '/data/data4/LHAN/TEST_PARCELLATION/public/Surface_parcellation_distribute/medial_wall.L.32k_fs_LR.func.gii';
medialw_L = gifti(medialw_L);
medialw_L = medialw_L.cdata;

medialw_R = '/data/data4/LHAN/TEST_PARCELLATION/public/Surface_parcellation_distribute/medial_wall.R.32k_fs_LR.func.gii';
medialw_R = gifti(medialw_R);
medialw_R = medialw_R.cdata;

mw = logical([medialw_L;medialw_R]);

%------------
% load parcels
parc_file = [path_parc '/Parcels_L.func.gii'];
parc_L = gifti(parc_file);
parc_L = parc_L.cdata;

parc_file = [path_parc '/Parcels_R.func.gii'];
parc_R = gifti(parc_file);
parc_R = parc_R.cdata;

parc = [parc_L; parc_R];
parc(mw) = []; % get rid of medial wall

parc_tb = unique(parc);
parc_tb(parc_tb==0) = [];

%------------
% load cifti time courses
tmsk_file = [path_data '/sub-MSC' sub '/processed_restingstate_timecourses/ses-func' sess '/cifti/sub-MSC' sub '_ses-func' sess '_task-rest_bold_32k_fsLR_tmask.txt'];
tmsk      = load(tmsk_file);
dts_file  = [path_data '/sub-MSC' sub '/processed_restingstate_timecourses/ses-func' sess '/cifti/sub-MSC' sub '_ses-func' sess '_task-rest_bold_32k_fsLR.dtseries.nii'];
cii_curr  = ft_read_cifti_mod(dts_file);
cii_curr  = cii_curr.data;
cii_tmsk  = cii_curr(:,logical(tmsk));
clear cii_curr tmsk_file tmsk

%==============
% get mean time series for each parcel
for parc_tbidx = 1:length(parc_tb)
    parc_curr = parc_tb(parc_tbidx);
    cii_tmp   = cii_tmsk(parc==parc_curr,:);
    cii_parc(parc_tbidx,:)  = mean(cii_tmp,1);
end
DTs = cii_parc;
clear cii_parc cii_tmp parc_curr
%==============

end