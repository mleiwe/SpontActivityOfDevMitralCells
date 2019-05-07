function [ROIs]=mnl_ManualSelectGlomeruli2(Data,Scale,name)
%
% function to manually trace around ROIs
% Inputs
% Data - the image (in x*y*t)
% Scale - the scale in um per pixel (assumes x and y are the same)
% name - the base file name you want to use
%
% Outputs
% ROIs - structred matrix contained the key information required
%
% Created by Marcus Leiwe, Kyushu University,2019
%% Create average image...
sz=size(Data);
for i=1:sz(1)
    for j=1:sz(2)
        mip(i,j)=max(Data(i,j,:)); 
        meanIP(i,j)=mean(Data(i,j,:));
    end
end
%% Display Image
nGlom=1;
figure,
subplot(1,2,1)
colormap(gray);
imagesc(meanIP);
subplot(1,2,2)
colormap(gray);
imagesc(mip);
%% Select ROIs/Glomeruli
prompt='Select Glomeruli/ROIs....press any key to start, when finished/to exit press e';
result=input(prompt,'s');
while 1
    display('Enter Glomerulus...Double click once to seal off polygon, and a second time to confirm location')
    [x, y, BW, xi, yi]=roipoly; %returns the XData and YData in x and y, the mask image in BW, and the polygon coordinates in xi and yi.
    ROIs(nGlom).x=x;
    ROIs(nGlom).y=y;
    ROIs(nGlom).BW=BW;
    ROIs(nGlom).xi=xi;
    ROIs(nGlom).yi=yi;
    hold on
    plot(xi,yi,'-y','LineWidth',1)
    tempXY(:,:)=[ROIs(nGlom).xi ROIs(nGlom).yi];
    [geom,~,~]=polygeom(tempXY(:,1),tempXY(:,2)); %Extract centroid position
    ROIx=round(geom(:,2));
    ROIy=round(geom(:,3));
    str=num2str(nGlom);
    text(ROIx,ROIy,str,'Color','y','BackgroundColor',[0.5 0.5 0.5])
    nGlom=nGlom+1;
    tempXY=[];
    prompt='press "e" if finished, or "Return" to draw another glomerulus...';
    result=input(prompt,'s');
    if result=='e'
        break
    end
end
%% Create Figures
figure,
title('ROI Selections');
subplot(1,2,1)
colormap(gray)
imagesc(mip)
hold on
mnl_PlotScale(Data,Scale,100,'w','um','h')
axis off
subplot(1,2,2)
for i=1:(nGlom-1)
    tempXY=[];
    plot(ROIs(i).xi,ROIs(i).yi,'-k','LineWidth',1)
    hold on
    tempXY(:,:)=[ROIs(i).xi ROIs(i).yi];
    [geom,~,~]=polygeom(tempXY(:,1),tempXY(:,2)); %Extract centroid position
    ROIx=round(geom(:,2));
    ROIy=round(geom(:,3));
    str=num2str(i);
    text(ROIx,ROIy,str,'Color','k')
end
set(gca,'YDir','reverse');
xlim([0 sz(2)])
ylim([0 sz(1)])
axis off
hold off
%% Save Workspace and Figures
save('ROIs')
figname=sprintf('%s_ROIlocations',name);
savefig(figname)
h=gcf;
print(h,'-depsc',figname)
hold off