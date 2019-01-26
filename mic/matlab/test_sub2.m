

datadir='~/gitlocal/restinginpca/data/';


sub2 = load([datadir 'zmat/matlab/sub-MSC02_zcube_rcube.mat']);
comm2 = load([datadir 'parcel_community/sub-MSC02_node_parcel_comm.txt']);

m2=mean(sub2.zcube,3);
imagesc(sub2.zcube(:,:,1))
figure;imagesc(m2(comm2(:,3)+1,comm2(:,3)+1))


sub1 = load([datadir 'zmat/matlab/sub-MSC01_zcube_rcube.mat']);
comm1 = load([datadir 'parcel_community/sub-MSC01_node_parcel_comm.txt']);

m1=mean(sub1.zcube,3);
imagesc(sub1.zcube(:,:,1))
imagesc(m1(comm1(:,3)+1,comm1(:,3)+1))

