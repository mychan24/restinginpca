
addpath('/data/data4/LHAN/TEST_MSC/public/community/sysseg')
addpath('/data/data1/tools/general_analysis/cifti-matlab-master_mod')
addpath('/data/data1/tools/general_analysis/system_matrix_tools/matlab_scripts')


% define paths
path_data = '/data/datax/data3/MSC/derivatives/surface_pipeline';
path_parc = '/data/data4/LHAN/gordon_parcels';

output_dir = '/data/datax/data3/MSC/RSFC_matrix';

for i = 1:10
    
    sub = sprintf('%02d', i);
    
    sprintf('sub-MSC%02d',i)
    
    cube_z = zeros(333,333,10);
    cube_r = zeros(333,333,10);
    
    outfile = [output_dir sprintf('/sub-MSC%02d_sess1_10_r_z_cubes.mat',i)];
    
    for j = 1:10
        
        sess = sprintf('%02d', j);

        tp = msc_import_data_gordon16(sub, sess);
        
        r = corrcoef(tp'); % Correlation matrix
        z = 0.5 * log((1+r)./(1-r)); % Fisher-z transform

        cube_r(:,:,j) = r;
        cube_z(:,:,j) = z;
    end
    
    save(outfile,'cube_z', 'cube_r')
end