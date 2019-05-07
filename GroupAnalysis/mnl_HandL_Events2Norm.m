function [PerSessionData]=mnl_HandL_Events2Norm(string)
display('Select the AgeGroupData')
[Wkspaces]=uipickfiles;
%% Step 1 - Load the Data
sz=size(Wkspaces);
for i=1:sz(2)
    load(Wkspaces{1,i});
end
%% Step 2 - Extract Age Data
[P1_ActiveEvents]=mnl_ExtractAgeData(P1_80percent_all,string);
[P2_ActiveEvents]=mnl_ExtractAgeData(P2_80percent_all,string);
[P3_ActiveEvents]=mnl_ExtractAgeData(P3_80percent_all,string);
[P4_ActiveEvents]=mnl_ExtractAgeData(P4_80percent_all,string);
[P5_ActiveEvents]=mnl_ExtractAgeData(P5_80percent_all,string);
[P6_ActiveEvents]=mnl_ExtractAgeData(P6_80percent_all,string);
[P7_ActiveEvents]=mnl_ExtractAgeData(P7_80percent_all,string);
[P10_ActiveEvents]=mnl_ExtractAgeData(P10_80percent_all,string);
% Produce Example Plots
figure('Name','Example Average Plots')
subplot(2,4,1)
bar(P1_ActiveEvents(1).AllNorm)
xlim([0 500])
ylim([0 25])

subplot(2,4,2)
title('P2')
bar(P2_ActiveEvents(1).AllNorm)
xlim([0 500])
ylim([0 25])

subplot(2,4,3)
title('P3')
bar(P3_ActiveEvents(1).AllNorm)
xlim([0 500])
ylim([0 25])

subplot(2,4,4)
title('P4')
bar(P4_ActiveEvents(1).AllNorm)
xlim([0 500])
ylim([0 25])

subplot(2,4,5)
title('P5')
bar(P5_ActiveEvents(1).AllNorm)
xlim([0 500])
ylim([0 25])

subplot(2,4,6)
title('P6')
bar(P6_ActiveEvents(1).AllNorm)
xlim([0 500])
ylim([0 25])

subplot(2,4,7)
title('P7')
bar(P7_ActiveEvents(1).AllNorm)
xlim([0 500])
ylim([0 25])

subplot(2,4,8)
title('P10')
bar(P10_ActiveEvents(2).AllNorm)
xlim([0 500])
ylim([0 25])

%% Step 3 - Determine the H and L events
thresh=5;
[P1_ActiveEvents]=mnl_FindHLevents(P1_ActiveEvents,thresh);
[P2_ActiveEvents]=mnl_FindHLevents(P2_ActiveEvents,thresh);
[P3_ActiveEvents]=mnl_FindHLevents(P3_ActiveEvents,thresh);
[P4_ActiveEvents]=mnl_FindHLevents(P4_ActiveEvents,thresh);
[P5_ActiveEvents]=mnl_FindHLevents(P5_ActiveEvents,thresh);
[P6_ActiveEvents]=mnl_FindHLevents(P6_ActiveEvents,thresh);
[P7_ActiveEvents]=mnl_FindHLevents(P7_ActiveEvents,thresh);
[P10_ActiveEvents]=mnl_FindHLevents(P10_ActiveEvents,thresh);

PerSessionData=struct('P1',P1_ActiveEvents,'P2',P2_ActiveEvents,'P3',P3_ActiveEvents,'P4',P4_ActiveEvents,'P5',P5_ActiveEvents,'P6',P6_ActiveEvents,'P7',P7_ActiveEvents,'P10',P10_ActiveEvents);
%% Step 4 - Plot Figures
%Plot HL ratio,Frequencies, etc...
[P1_Freq]=mnl_ExtractFreqData(P1_ActiveEvents);
[P2_Freq]=mnl_ExtractFreqData(P2_ActiveEvents);
[P3_Freq]=mnl_ExtractFreqData(P3_ActiveEvents);
[P4_Freq]=mnl_ExtractFreqData(P4_ActiveEvents);
[P5_Freq]=mnl_ExtractFreqData(P5_ActiveEvents);
[P6_Freq]=mnl_ExtractFreqData(P6_ActiveEvents);
[P7_Freq]=mnl_ExtractFreqData(P7_ActiveEvents);
[P10_Freq]=mnl_ExtractFreqData(P10_ActiveEvents);
% Scatter Plots
figure('Name','H Frequency')
plot(1,P1_Freq(:,1),'.b')
hold on
plot(2,P2_Freq(:,1),'.b')
plot(3,P3_Freq(:,1),'.b')
plot(4,P4_Freq(:,1),'.b')
plot(5,P5_Freq(:,1),'.b')
plot(6,P6_Freq(:,1),'.b')
plot(7,P7_Freq(:,1),'.b')
plot(8,P10_Freq(:,1),'.b')
xlim([0 9])
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10',' '});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);

figure('Name','L Frequency')
plot(1,P1_Freq(:,2),'.b')
hold on
plot(2,P2_Freq(:,2),'.b')
plot(3,P3_Freq(:,2),'.b')
plot(4,P4_Freq(:,2),'.b')
plot(5,P5_Freq(:,2),'.b')
plot(6,P6_Freq(:,2),'.b')
plot(7,P7_Freq(:,2),'.b')
plot(8,P10_Freq(:,2),'.b')
xlim([0 9])
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10',' '});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);

figure('Name','HL Ratio')
plot(1,P1_Freq(:,3),'.b')
hold on
plot(2,P2_Freq(:,3),'.b')
plot(3,P3_Freq(:,3),'.b')
plot(4,P4_Freq(:,3),'.b')
plot(5,P5_Freq(:,3),'.b')
plot(6,P6_Freq(:,3),'.b')
plot(7,P7_Freq(:,3),'.b')
plot(8,P10_Freq(:,3),'.b')
xlim([0 9])
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10',' '});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);

% Plot bars
AgeGroups={'P1','P2','P3','P4','P5','P6','P7','P10',' '};
H_Freq_mean=[mean(P1_Freq(:,1)),mean(P2_Freq(:,1)),mean(P3_Freq(:,1)),mean(P4_Freq(:,1)),mean(P5_Freq(:,1)),mean(P6_Freq(:,1)),mean(P7_Freq(:,1)),mean(P10_Freq(:,1))];
H_Freq_std=[std(P1_Freq(:,1)),std(P2_Freq(:,1)),std(P3_Freq(:,1)),std(P4_Freq(:,1)),std(P5_Freq(:,1)),std(P6_Freq(:,1)),std(P7_Freq(:,1)),std(P10_Freq(:,1))];
H_Freq_sem=[std(P1_Freq(:,1))/sqrt(size(P1_Freq,1)),std(P2_Freq(:,1))/sqrt(size(P2_Freq,1)),std(P3_Freq(:,1))/sqrt(size(P3_Freq,1)),std(P4_Freq(:,1))/sqrt(size(P4_Freq,1)),std(P5_Freq(:,1))/sqrt(size(P5_Freq,1)),std(P6_Freq(:,1))/sqrt(size(P6_Freq,1)),std(P7_Freq(:,1))/sqrt(size(P7_Freq,1)),std(P10_Freq(:,1))/sqrt(size(P10_Freq,1))];

L_Freq_mean=[mean(P1_Freq(:,2)),mean(P2_Freq(:,2)),mean(P3_Freq(:,2)),mean(P4_Freq(:,2)),mean(P5_Freq(:,2)),mean(P6_Freq(:,2)),mean(P7_Freq(:,2)),mean(P10_Freq(:,2))];
L_Freq_std=[std(P1_Freq(:,2)),std(P2_Freq(:,2)),std(P3_Freq(:,2)),std(P4_Freq(:,2)),std(P5_Freq(:,2)),std(P6_Freq(:,2)),std(P7_Freq(:,2)),std(P10_Freq(:,2))];
L_Freq_sem=[std(P1_Freq(:,2))/sqrt(size(P1_Freq,1)),std(P2_Freq(:,2))/sqrt(size(P2_Freq,1)),std(P3_Freq(:,2))/sqrt(size(P3_Freq,1)),std(P4_Freq(:,2))/sqrt(size(P4_Freq,1)),std(P5_Freq(:,2))/sqrt(size(P5_Freq,1)),std(P6_Freq(:,2))/sqrt(size(P6_Freq,1)),std(P7_Freq(:,2))/sqrt(size(P7_Freq,1)),std(P10_Freq(:,2))/sqrt(size(P10_Freq,1))];

HL_Ratio_mean=[mean(P1_Freq(:,3)),mean(P2_Freq(:,3)),mean(P3_Freq(:,3)),mean(P4_Freq(:,3)),mean(P5_Freq(:,3)),mean(P6_Freq(:,3)),mean(P7_Freq(:,3)),mean(P10_Freq(:,3))];
HL_Ratio_std=[std(P1_Freq(:,3)),std(P2_Freq(:,3)),std(P3_Freq(:,3)),std(P4_Freq(:,3)),std(P5_Freq(:,3)),std(P6_Freq(:,3)),std(P7_Freq(:,3)),std(P10_Freq(:,3))];
HL_Ratio_sem=[std(P1_Freq(:,3))/sqrt(size(P1_Freq,1)),std(P2_Freq(:,3))/sqrt(size(P2_Freq,1)),std(P3_Freq(:,3))/sqrt(size(P3_Freq,1)),std(P4_Freq(:,3))/sqrt(size(P4_Freq,1)),std(P5_Freq(:,3))/sqrt(size(P5_Freq,1)),std(P6_Freq(:,3))/sqrt(size(P6_Freq,1)),std(P7_Freq(:,3))/sqrt(size(P7_Freq,1)),std(P10_Freq(:,3))/sqrt(size(P10_Freq,1))];

figure('Name','H event frequency')
mnl_BarGraphs(H_Freq_mean,H_Freq_std,'H Event Frequency',AgeGroups);
figure('Name','H event frequency SEM')
mnl_BarGraphs(H_Freq_mean,H_Freq_sem,'H Event Frequency',AgeGroups);
figure('Name','L event frequency')
mnl_BarGraphs(L_Freq_mean,L_Freq_std,'L Event Frequency',AgeGroups);
figure('Name','L event frequency')
mnl_BarGraphs(L_Freq_mean,L_Freq_sem,'L Event Frequency',AgeGroups);
figure('Name','HL event ratio')
mnl_BarGraphs(HL_Ratio_mean,HL_Ratio_std,'HL Event Ratio',AgeGroups);
figure('Name','HL event ratio')
mnl_BarGraphs(HL_Ratio_mean,HL_Ratio_sem,'HL Event Ratio',AgeGroups);

figure('Name','Combined Figure')
subplot(1,3,1)
mnl_BarGraphs(H_Freq_mean,H_Freq_sem,'H Event Frequency',AgeGroups);
subplot(1,3,2)
mnl_BarGraphs(L_Freq_mean,L_Freq_sem,'L Event Frequency',AgeGroups);
subplot(1,3,3)
mnl_BarGraphs(HL_Ratio_mean,HL_Ratio_sem,'HL Event Ratio',AgeGroups);

end

function [P1_ActiveEvents]=mnl_ExtractAgeData(P1_all,string)
sz=size(P1_all);
gc=1;
for i=1:sz(2) % Per Image
    n=1;
    a=1;
    TF=strcmp(P1_all(i).BasicInfo.IndicatorType,string); %Is it the right Indicator?
    if TF==1
        P1_ActiveEvents(gc).Time=P1_all(i).BasicInfo.MovieLength; %Extract the imaging session length (in seconds)
        sz1=size(P1_all(i).BurstData.ColBursts.SumSpikes);
        count=0;
        Hcount=0;
        Lcount=0;
        % Extract Data
        AvNum=mean(P1_all(i).BurstData.ColBursts.SumSpikes); %Find the average number of active events per frame)
        P1_ActiveEvents(gc).AvNum=AvNum;
        P1_ActiveEvents(gc).NumFrames=sz1(2);
        P1_ActiveEvents(gc).spf=P1_all(i).BasicInfo.FrameRate;
        for i2=1:sz1(2)
            if P1_all(i).BurstData.ColBursts.SumSpikes(i2)~=0
                %Extract the  Active  Events
                P1_ActiveEvents(gc).Norm(n)=P1_all(i).BurstData.ColBursts.SumSpikes(i2)/AvNum; %Events-Average/Average
                n=n+1;
                P1_ActiveEvents(gc).AllNorm(a)=P1_all(i).BurstData.ColBursts.NormSumSpikes(i2)/AvNum; %Events-Average/Average
                a=a+1;
            elseif P1_all(i).BurstData.ColBursts.NormSumSpikes(i2)==0
                P1_ActiveEvents(gc).AllNorm(a)=0; %Events-Average/Average
                a=a+1;
            end
        end
        gc=gc+1;
    end
end
a=1;
end
function [NewData]=mnl_FindHLevents(data,thresh)
sz=size(data);
NewData=data;
for i=1:sz(2)
    NumFrames=data(i).NumFrames;
    H=0;
    L=0;    
    sz1=size(data(i).Norm);
    for i2=1:sz1(2)
        if data(i).Norm(i2)>=thresh
            H=H+1;
            NewData(i).Hevents(H)=data(i).Norm(i2);
        elseif data(i).Norm(i2)<thresh && data(i).Norm(i2)~=0
            L=L+1;
            NewData(i).Levents(L)=data(i).Norm(i2);
        end
    end
    sz2=size(data(i).AllNorm);
    % Now work out the other stuff
    NewData(i).SilentFrames=zeros(1,sz2(2)-sz1(2)); %Silent Frames
    % Frequency Data    
    NewData(i).HLratio=H/L;
    if H==0
        NewData(i).Hevents=[];
        NewData(i).H_freq=0;
        NewData(i).HLratio=0;
    else
        NewData(i).H_freq=H/data(i).Time;
    end
    if L==0
        NewData(i).Levents=[];
        NewData(i).L_freq=0;
        NewData(i).HLratio=NaN;
    else
        NewData(i).L_freq=L/data(i).Time;
    end
    NewData(i).HLratio=H/L;
end
end
function [FreqMatrix]=mnl_ExtractFreqData(data)
sz=size(data);
n=1;
for i=1:sz(2)
    FreqMatrix(i,1)=data(i).H_freq;
    FreqMatrix(i,2)=data(i).L_freq;
    FreqMatrix(i,3)=data(i).HLratio;
end
end