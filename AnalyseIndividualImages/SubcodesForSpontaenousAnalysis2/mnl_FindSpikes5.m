function [ROI_Spikes]=mnl_FindSpikes5(dF,range,t,threshold,workspace)
% mnl_find spikes tries to locate peaks of activity from deltaF over F
% traces.
% Inputs
% dF - deltaF over F values (rows=number of ROIs, columns=timepoints)
% range - time span for averaging responses in seconds (tries to counter quenching over
% time
% t - frame rate in seconds per frame (spf)
% threshold - number of standard deviations above threshold
%
% Output
% ROI_Spikes is a structured array with the following components...
%   ROI_Spikes.Peaks - amplitude of peaks
%   ROI_Spikes.PeakLoc - location of the peaks in frames
%   ROI_Spikes.Onset - Onset of the Peaks
%   ROI_Spikes.Offset -  Offset of the Peaks
%   ROI_Spikes.Dur - Duration of the Peak
%
% Also produces the following graphs...
%   Figure 1 - Example Trace
%   Figure 2 - Plots for the frequency and amplitude of responses
%
% Created by Marcus Leiwe, Kyushu University, 2019

s=size(dF); %s(1) should be #ROIS, s(2) is #timepoints
FrameRange=(range/t);
% Filter out the top 20% of values - used for calculating the std deviation
dFsort=sort(dF(:,:),2);
dFfilt=dFsort(:,1:(s(2)*0.80));

for i=1:s(1) %For Each ROI
    sprintf('%s%d','Processing ROI number...',i)
    StdF=std(dFfilt(i,:));
    ThreshF=StdF*threshold;
    TimeSpikeCounter=1;
    % Clear old Data
    Peaks=[];
    PeakLoc=[];
    Onset=[];
    Offset=[];
    Duration=[];
    AdaptiveThresh=zeros(1,s(2));
    Baseline=zeros(1,s(2));
    n=1;
    for i2=1:s(2) % For Each Timepoint
        % Establish the time window for averages
        minT=i2-(FrameRange/2);
        maxT=i2+(FrameRange/2);
        if minT<1
            minT=1;
            maxT=FrameRange;
        end
        if maxT>=s(2)
            maxT=s(2);
            minT=s(2)-FrameRange;
        end
        t0=round(minT); % Beginning of Window
        t1=round(maxT); % End of Window
        
        % Find the new Threshold Value
        tempF=mean(dF(i,t0:t1));
        sT=size(tempF);
        sorttempF=sort(tempF);
        filttempF=sorttempF(1:round(sT*0.5));
        meanF=filttempF;
        NewThresh=meanF+ThreshF;
        AdaptiveThresh(i2)=NewThresh;
        Baseline(i2)=meanF;
        % Detect Spikes
        if dF(i,i2)>=NewThresh % If Peak is above the NewThreshold
            % Add in a break in order to prevent a long spike counting twice
            Tp=i2-1;
            Tn=i2+1;
            if Tp<=0
                Tp=1;
            end
            if Tn>s(2)
                Tn=s(2);
            end
            if dF(i,Tp)<=dF(i,i2) && dF(i,Tn)<dF(i,i2) %If Prev is bigger, if next is bigger
                Peaks(n)=dF(i,i2);
                PeakLoc(n)=i2;
                % Establish Onset
                for i3=1:i2 % For point 1 to the Spike/Peak Timepoint
                    if i2-i3==0
                        Onset(n)=1;
                        break
                    end
                    if dF(i,(i2-i3))<NewThresh
                        Onset(n)=i2-i3;
                        break
                    end
                end
                % Establish Offset
                for i3=i2+1:s(2)
                    if i3==s(2)
                        Offset(n)=s(2);
                    end
                    if dF(i,i3)<=NewThresh
                        Offset(n)=i3;
                        break
                    end
                end
                % Establish Duration
                Duration(n)=(Offset(n)-Onset(n))*t;
                
                n=n+1;
            end
        end
    end
    %Calculate Frequency
    NumSpikes=size(Peaks);
    NumSpikes=NumSpikes(2);
    Frequency=NumSpikes/s(2);
    % Store Data
    ROI_Spikes(i).Peaks=Peaks;
    ROI_Spikes(i).PeakLoc=PeakLoc;
    ROI_Spikes(i).Onset=Onset;
    ROI_Spikes(i).Offset=Offset;
    ROI_Spikes(i).Duration=Duration;
    ROI_Spikes(i).Frequency=Frequency;
    ROI_Spikes(i).AdaptiveThresh=AdaptiveThresh;
    ROI_Spikes(i).Baseline=Baseline;
end

%% Example Trace of Spike Detection - uses a random ROI
s1=size(dF);
randnum=round(s1(1)*(rand(1)));
if randnum==0
    randnum=1;
end
Trace=dF(randnum,:);
Thresh=ROI_Spikes(randnum).AdaptiveThresh;
Base=ROI_Spikes(randnum).Baseline;
figure
plot(Trace,'b')
hold on
plot(Thresh,'r')
plot(Base,'y')
if isempty(ROI_Spikes(randnum).PeakLoc)==0
    scatter(ROI_Spikes(randnum).PeakLoc,ROI_Spikes(randnum).Peaks,'.g')
end
title('Exampe Tracce with Spike Detection')
xlabel('Number of Frames')
ylabel('df over f')

%% Population data
%Collate Data
n=1;
Duration=zeros(s(1),1);
for i=1:s(1)
    chk=isempty(ROI_Spikes(i).Frequency);
    if chk==0
        Freq(n,1)=ROI_Spikes(i).Frequency;
        Amp(n,1)=mean(ROI_Spikes(i).Peaks);
        AmpStd(n,1)=std(ROI_Spikes(i).Peaks);
        Duration(n,1)=mean(ROI_Spikes(i).Duration);
        DurationStd(n,1)=std(ROI_Spikes(i).Duration);
        n=n+1;
    end
end
figure,
title('Spike Properties')
% Subplot 1 - Frequncy of Spikes
subplot(1,3,1)
x=1;
y=Freq;
plot(x,y,'ob')
hold on
plot(x,mean(Freq),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10)
errorbar(x,mean(Freq),std(Freq),'k','LineWidth',2)
ylabel('Frequencies (Hz)')
hold off
% Subplot 2 - Duration of Spikes
subplot(1,3,2)
num=size(Duration);
x=ones(num(1),1);
y=Duration;
plot(x,y','ob')
hold on
for i=1:num(1)
    errorbar(x(i),y(i),DurationStd(i),'b')
end
plot(x,mean(Duration),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10)
errorbar(x(1),mean(Duration),std(Duration),'k','LineWidth',2)
ylabel('Spike Duration (ms)')
hold off
% Subplot 3 - Amplitude of Spikes
subplot(1,3,3)
num=size(Amp);
x=ones(num(1),1);
y=Amp;
plot(x,y,'ob')
hold on
for i=1:num(1)
    errorbar(x(i),y(i),AmpStd(i),'b')
end
plot(x,mean(Amp),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10)
errorbar(x(1),mean(Amp),std(Amp),'k','LineWidth',2)
ylabel('Spike Amplitude (deltaF/meanF)')
hold off
savefig('SpikeProperties')

% Distribution of Spike Amplitudes
sz=size(ROI_Spikes);
[~,~,bin_size]=asl_opt_bin_size(Amp,sz(2));
figure,
hist(Amp,bin_size)
title('Intensity Distribution of Spike Amplitudes')
xlabel('Intensity Values')
ylabel('Frequency')

% Distribution of Intensity Values
sz=size(dF);
values=zeros((sz(1)*sz(2)),1);
n=1;
for i=1:sz(1)
    for i2=1:sz(2)
        values(n)=dF(i,i2);
        n=n+1;
    end
end
figure
[~,~,bin_size]=asl_opt_bin_size(values,1000);
hist(values,bin_size)
xlabel('Intensity Values')
ylabel('Frequency')
title('Overall Intensity Distribution')

%% Write to excell file
%Raw Spike Data
Row1=zeros(1,(sz(2)+1));
Row1(1,2:(sz(2)+1))=linspace(1,sz(2),sz(2));

limit=1;
for i=1:sz(1)
    sz_temp=size(ROI_Spikes(i).Peaks);
    if limit<=sz_temp(2)
        limit=sz_temp(2);
    end
end
dfofSpikes=zeros(sz(2),limit);
for i=1:sz(1)
    sz2=size(ROI_Spikes(i).Peaks);
    for j=1:sz2(2)
        dfofSpikes(i,j)=ROI_Spikes(i).Peaks(1,j);
    end
end
sz2=size(dfofSpikes);
for i=1:sz2(1)
    for j=1:sz2(2)
        if dfofSpikes(i,j)==0
            dfofSpikes(i,j)=NaN;
        end
    end
end
Col1=linspace(1,sz2(2),sz2(2))';
Cols=[Col1 dfofSpikes'];
T=[Row1;Cols];
filename = sprintf('%s%s',workspace,'.xlsx');
xlswrite(filename,T,'Spike Data');

%Summarised Spike Data
GlomNum=linspace(1,sz(1),sz(1))';
Frequency=Freq;
MeanAmplitude=Amp;
SummarisedSpikeData=table(GlomNum,Frequency,MeanAmplitude,Duration);
writetable(SummarisedSpikeData,filename,'Sheet','Summarised Spike Data');
