function [Vall_bin,Vall_sem_bin,Vall_std_bin] = mnl_BinInputs(Xinputs,Yinputs,r)
% mnl_BinInputs 
% Inputs
% Xinputs - Inputs for X axis (column 1 the one you want to sort and bin
% Yinputs - Inputs for Y axis (the thing you are measuring)
% r - size of bin


%% Step 1 - sort the data
Vall=[Xinputs Yinputs];
[Y,I]=sort(Vall(:,1),1);
sVall=Vall(I,:);

%% Step 2 - Do the binning
sz=size(sVall);
numbins=sz(1)/r;
intervals=round(linspace(0,sz(1),numbins+1));
sz1=size(intervals);

%Pre-allocate stuff
Vbin_X=zeros(sz1(2)-1,1);
Vstd_X=zeros(sz1(2)-1,1);
Vsem_X=zeros(sz1(2)-1,1);
Vbin_Y=zeros(sz1(2)-1,1);
Vstd_Y=zeros(sz1(2)-1,1);
Vsem_Y=zeros(sz1(2)-1,1);

for i=1:(sz1(2)-1)
    if intervals(i)==0
        Vbin_X(i)=mean(sVall(1:intervals(i+1),1));
        Vstd_X(i)=std(sVall(1:intervals(i+1),1));
        num=intervals(i+1)-intervals(i);
        Vsem_X(i)=Vstd_X(i)/(num^0.5);
        
        Vbin_Y(i)=mean(sVall(1:intervals(i+1),2));
        Vstd_Y(i)=std(sVall(1:intervals(i+1),2));
        Vsem_Y(i)=Vstd_Y(i)/(num^0.5);
    else
        Vbin_X(i)=mean(sVall(intervals(i):intervals(i+1),1));
        Vstd_X(i)=std(sVall(intervals(i):intervals(i+1),1));
        num=intervals(i+1)-intervals(i);
        Vsem_X(i)=Vstd_X(i)/(num^0.5);
        
        Vbin_Y(i)=mean(sVall(intervals(i):intervals(i+1),2));
        Vstd_Y(i)=std(sVall(intervals(i):intervals(i+1),2));
        Vsem_Y(i)=Vstd_Y(i)/(num^0.5);
    end
end

Vall_bin=[Vbin_X Vbin_Y];
Vall_std_bin=[Vstd_X Vstd_Y];
Vall_sem_bin=[Vsem_X Vsem_Y];