function [ColBursts,ColBinBursts,Spikes,BurstBin]=mnl_BurstingAnalysis4(ROI_Spikes,T,spf,Tend,bin,workspace)
%Function to work out the size of the bursts, their frequency, and the
%interburst interval. Also produces two figures one 'raw' data looking a
%bursting activity and the other over the specified bin time. Finally it
%looks at creating H and E event thresholds
%
% Inputs
% ROI_Spikes - Structured matrix containing spike info
% T - Matrix of all the time points in units of time
% spf - FrameRate in seconds per frame
% Tend - Final Timepoint
% bin - time to bin over (seconds)
% burThresh - Threshold what what you would define as a burst of activity
% workspace - desired filename prefix

% Outputs
% ColBursts - Structured array containing information regarding the size,
% frequency, and interburst interval
% ColBinBursts - as above but for the binned data
% Spikes - binary plot of all ROIs with filter
% fSpikes - filtered to remove silent glomeruli
%
%Created by Marcus Leiwe at CDB RIKEN June 2014
BurstBin=bin;
%% Non-normalised Data
%   Step 1 - Raster Plot
sz=size(ROI_Spikes);
nGlom=sz(2);
sz2=size(T);
Spikes=zeros(sz(2),sz2(2));
for i=1:sz(2)
    for j=1:sz2(2)
        sz3=size(ROI_Spikes(i).PeakLoc);
        for k=1:sz3(2)
            if ROI_Spikes(i).PeakLoc(k)==j
                Spikes(i,j)=1;
            end
        end
    end
end
sz4=size(Spikes);
n=1;
for i=1:sz4(1)
    for j=1:sz4(2)
        if Spikes(i,j)==1
            x(n)=j*spf;
            y(n)=i;
            n=n+1;
        end
    end
end
%Make Raster Plot
figure
subplot(3,1,1)
scatter(x,y,100,'.k')
xlabel('Time(s)')
ylabel('ROI Number')
ylim([0 sz(2)])
xlim([0 Tend])
title('Raster Plot')
% Step2 -  Merge the data over all ROIs
SumSpikes=zeros(1,sz2(2));
for j=1:sz2(2)
    n=0;
    for i=1:sz(2)
        if Spikes(i,j)==1
            n=n+1;
        end
    end
    SumSpikes(1,j)=n;
end
%Make Sum Spikes
subplot(3,1,2)
bar(T,SumSpikes);
xlim([0 Tend])
ylabel('Number of Spikes')
xlabel('Time(s)')
title('SumSpikes')
ColBursts.SumSpikes=SumSpikes;
% Step 3 - Bin Data over 'bin' seconds - with an added 0.5sec smoothing
[BinSumSpikes]=mnl_timebin(Tend,bin,SumSpikes,spf);
ColBinBursts.SumSpikes=BinSumSpikes; 
%Plot Bin Sum Spikes
subplot(3,1,3)
bar(BinSumSpikes.x,BinSumSpikes.y)
xlim([0 Tend])
ylabel('Number of Spikes (NB Binned)')
xlabel('Time (s)')
str_title=sprintf('%s%d%s','Cumulative Spikes Binned by ',bin,' seconds');
title(str_title)
xlim([0 Tend])
fn=sprintf('%s%s',workspace,'_SumSpikes');
maximize
h=gcf;
savefig(fn)
%print(h,'dill',fn)
% Step 4 - Do it over 30 and 5 seconds
[tempBinSumSpikes]=mnl_timebin(Tend,1,SumSpikes,spf);
[temp2BinSumSpikes]=mnl_timebin(Tend,5,SumSpikes,spf);
% Initial Measurements
% Events per frame(y) to fraction of active cells
figure('Name','Cumulative Plots for Active Glomeruli')
subplot(2,2,1)
mnl_CumulativePlot3(ColBursts.SumSpikes')
xlabel('Active Glomeruli')
title('Cumulative Plot of Bursts')
hold on
subplot(2,2,2)
mnl_CumulativePlot3(BinSumSpikes.y')
xlabel('Active Glomeruli')
title('Cumulative Plot of BinBursts')
subplot(2,2,3)
mnl_CumulativePlot3(tempBinSumSpikes.y')
xlabel('Active Glomeruli')
title('Cumulative Plot of a 30 second bin')
subplot(2,2,4)
mnl_CumulativePlot3(temp2BinSumSpikes.y')
xlabel('Active Glomeruli')
title('Cumulative Plot of a 5 second bin')
fn=sprintf('%s%s',workspace,'_CumPlotHandLevents');
savefig(fn)
figure
mnl_CumulativePlot3(BinSumSpikes.y')
xlabel('%age of Active Glomeruli')
title('Cumulative Plot of BinBursts')

%% Now Do it all again for the normalised data
%  Step 1 - Normalised Data
[NormSumSpikes,NormBinSumSpikes]=mnl_normalise(nGlom,SumSpikes,BinSumSpikes,T,Tend,bin);
ColBursts.NormSumSpikes=NormSumSpikes;
ColBinBursts.NormBinSumSpikes=NormBinSumSpikes;

%  Step 3 - Visualise the cumulative plots
figure('Name','Normalised Cumulative Plots of Active Events')
subplot(2,2,1)
mnl_CumulativePlot3(ColBursts.SumSpikes')
xlabel('%age of Active Glomeruli')
title('Cumulative Plot of Bursts')
hold on
subplot(2,2,2)
mnl_CumulativePlot3(NormBinSumSpikes.y')
xlabel('%age of Active Glomeruli')
title('Cumulative Plot of BinBursts')
subplot(2,2,3)
mnl_CumulativePlot3(tempBinSumSpikes.y')
xlabel('%age of Active Glomeruli')
title('Cumulative Plot of a 30 second bin')
subplot(2,2,4)
mnl_CumulativePlot3(temp2BinSumSpikes.y')
xlabel('%age of Active Glomeruli')
title('Cumulative Plot of a 5 second bin')
fn=sprintf('%s%s',workspace,'_NormalisedCumPlotHandLevents');
%savefig(fn)

%% Remove Silent Timepoints
sz=size(ColBursts.NormSumSpikes);
n=1;
for i=1:sz(2)
    if ColBursts.NormSumSpikes(i)~=0
        ActiveSumSpikes(n)=ColBursts.SumSpikes(i);
        ActiveNormSumSpikes(n)=ColBursts.NormSumSpikes(i);
        n=n+1;
    end
end
ColBursts.FreqActiveSumSpikes=(size(ActiveSumSpikes,2)/Tend)*60; % expressed per minute
ColBursts.FreqActiveNormSumSpikes=(size(ActiveNormSumSpikes,2)/Tend)*60; % expressed per minute

sz1=size(ColBinBursts.NormBinSumSpikes.y);
m=1;
for i=1:sz1(2)
    if ColBinBursts.NormBinSumSpikes.y(i)~=0
        ActiveBinSumSpikes(m)=ColBinBursts.SumSpikes.y(i);
        ActiveBinNormSumSpikes(m)=ColBinBursts.NormBinSumSpikes.y(i);
        m=m+1;
    end
end
ColBinBursts.FreqActiveBinSumSpikes=(size(ActiveSumSpikes,2)/Tend)*60;
ColBinBursts.FreqActiveBinNormSumSpikes=(size(ActiveNormSumSpikes,2)/Tend)*60;

figure('name','Active Spikes');
subplot(2,2,1)
title('ActiveSumSpikes')
mnl_CumulativePlot3(ActiveSumSpikes')

subplot(2,2,3)
title('ActiveSumSpikes - Hist')
[~,bins,~]=asl_opt_bin_size(ActiveSumSpikes,m-1);
hist(ActiveSumSpikes',bins)
xlabel('%age of Active Glomeruli')

subplot(2,2,2)
title('ActiveNormSumSpikes')
mnl_CumulativePlot3(ActiveNormSumSpikes')

subplot(2,2,4)
title('ActiveNormSumSpikes - Hist')
[~,bins,~]=asl_opt_bin_size(ActiveNormSumSpikes,m-1);
hist(ActiveNormSumSpikes',bins)
xlabel('%age of Active Glomeruli')

fn=sprintf('%s%s',workspace,'_ActiveSpikes');
savefig(fn)

figure('name','Active Binned Spikes');
subplot(2,2,1)
title('ActiveBinSumSpikes')
mnl_CumulativePlot3(ActiveBinSumSpikes')

subplot(2,2,3)
title('ActiveBinSumSpikes - Hist')
[~,bins,~]=asl_opt_bin_size(ActiveBinSumSpikes,m-1);
hist(ActiveBinSumSpikes',bins)
xlabel('%age of Active Glomeruli')

subplot(2,2,2)
title('ActiveBinNormSumSpikes')
mnl_CumulativePlot3(ActiveBinNormSumSpikes')

subplot(2,2,4)
title('ActiveBinNormSumSpikes - Hist')
[~,bins,~]=asl_opt_bin_size(ActiveBinNormSumSpikes,m-1);
hist(ActiveNormSumSpikes',bins)
xlabel('%age of Active Glomeruli') 
fn=sprintf('%s%s',workspace,'_ActiveBinnedSpikes');
savefig(fn)

%% Write to Excell Table
%BurstingData=table(GlomNum,Frequency,MeanAmplitude,Duration);
%writetable(BurstingData,filename,'Sheet','Summarised Spike Data');
end
function [BinSumSpikes]=mnl_timebin(Tend,bin,SumSpikes,spf)
sz=size(SumSpikes);
bin_matrix=linspace(0,Tend,Tend/bin);
extra=0.5;%smoothing by the number of seconds
sz1=size(bin_matrix);
for i=1:sz1(2)-1 %for each binned timepoint
    t0=bin_matrix(i)-extra;
    t1=bin_matrix(i+1)+extra;
    tf0=round(t0/spf);
    if tf0<=1
        tf0=1;
    end
    tf1=round(t1/spf);
    if tf1>sz(2)
        tf1=sz(2);
    end
    BinSumSpikes.y(i)=sum(SumSpikes(tf0:tf1));
    BinSumSpikes.x(i)=bin_matrix(i+1);
end
end
function [NormSumSpikes,NormBinSumSpikes]=mnl_normalise(nGlom,SumSpikes,BinSumSpikes,T,Tend,bin)
% Express as a Percentage of Glomeruli firing
figure
subplot(2,1,1)
sz=size(SumSpikes);
NormSumSpikes=(SumSpikes/nGlom)*100;
bar(T,NormSumSpikes)
xlim([0 Tend])
ylim([0 100])
ylabel('%age of Glomeruli Active')
xlabel('Time(s)')
title('NormSumSpikes')
subplot(2,1,2)
NormBinSumSpikes.x=BinSumSpikes.x;
NormBinSumSpikes.y=(BinSumSpikes.y/nGlom)*100;
bar(NormBinSumSpikes.x,NormBinSumSpikes.y)
xlim([0 Tend])
ylim([0 100])
ylabel('%age of Glomeruli Active')
xlabel('Time (s)')
str_title=sprintf('%s%d%s','%age of Glomeruli Active Binned by ',bin,' seconds');
title(str_title)
xlim([0 Tend])
ColBursts.NormSumSpikes=NormSumSpikes;
ColBinBursts.NormSumSpikes=NormBinSumSpikes;
%savefig('NormSumSpikes')
end
