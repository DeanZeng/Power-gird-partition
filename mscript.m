mpc=wzlsx;
Vth=200;
[m,h]=newmanGirvanPartion(mpc,10,Vth);
busRegion=zeros(size(mpc.bus,1),2);
busRegion(:,1)=1:size(busRegion,1);
for i=1:length(m)
    busRegion(m{i},2)=i;
end
