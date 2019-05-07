function [Freq,Freq_6f,Amp,Amp_6f,GCaMP3_AmpFreq,GCaMP6f_AmpFreq,HL_AllData,HL_PerSessionData,HL_AllData_6f,HL_PerSessionData_6f,HL_AllData_3,HL_PerSessionData_3,GroupSTTC,STTCdata]=mnl_SpontGroupDataAnalysis

display('Select the AgeGroupData')
[Wkspaces]=uipickfiles;
%% Load the Data
sz=size(Wkspaces);
for i=1:sz(2)
    load(Wkspaces{1,i});
end
%% Amplitude Distribution
[Amp,Amp_6f]=mnl_AmplitudeBoxPlots(P1_80percent_all,P2_80percent_all,P3_80percent_all,P4_80percent_all,P5_80percent_all,P6_80percent_all,P7_80percent_all,P10_80percent_all);
%% Frequency Distribution
[Freq,Freq_6f]=mnl_FrequencyBoxPlots(P1_80percent_all,P2_80percent_all,P3_80percent_all,P4_80percent_all,P5_80percent_all,P6_80percent_all,P7_80percent_all,P10_80percent_all);
%% Amplitude and Frequeency Relationships
[GCaMP3_AmpFreq,GCaMP6f_AmpFreq]=mnl_FreqAmpRelationship(Freq,Amp,Freq_6f,Amp_6f);
%%  STTC Group Curves
[a_grouped,b_grouped,HalfLife_grouped]=mnl_STTCgroups(P1_80percent_all,P2_80percent_all,P3_80percent_all,P4_80percent_all,P5_80percent_all,P6_80percent_all,P7_80percent_all,P10_80percent_all);
GroupSTTC=struct('Span',a_grouped,'RateConstant',b_grouped,'HalfLife',HalfLife_grouped);
%% STTC Fit Comparissons
[Span,RateConstant,HalfLife]=mnl_STTC_FitComparissons(P1_80percent_all,P2_80percent_all,P3_80percent_all,P4_80percent_all,P5_80percent_all,P6_80percent_all,P7_80percent_all,P10_80percent_all);
STTCdata=struct('Span',Span,'RateConstant',RateConstant,'HalfLife',HalfLife);
%% Save Worskspace
save('AllSpontData','-v7.3')
end
%% Nested Functions
function [Amp,Amp_6f]=mnl_AmplitudeBoxPlots(P1_all,P2_all,P3_all,P4_all,P5_all,P6_all,P7_all,P10_all)
%% Extract Information
%P1 Amp
sz=size(P1_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF = strcmp(P1_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P1_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P1_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P1_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=sz2(2)
                P1AllAmp(n2)=(P1_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P1Amp(n)=(mean(P1_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P1_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P1_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P1AllAmp_6f(n3)=(P1_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P1Amp_6f(n1)=(mean(P1_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end

if exist('P1Amp','var')==0
        P1Amp=NaN;
end
if exist('P1AllAmp','var')==0
        P1AllAmp=NaN;
end
if exist('P1Amp_6f','var')==0
    P1Amp_6f=NaN;
end
if exist('P1AllAmp_6f','var')==0
        P1AllAmp_6f=NaN;
end
maxROI=n-1;
maxROI_6f=n1-1;
%P2 Frequency
sz=size(P2_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF = strcmp(P2_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P2_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P2_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P2_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P2AllAmp(n2)=(P2_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P2Amp(n)=(mean(P2_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P2_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P2_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P2AllAmp_6f(n3)=(P2_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P2Amp_6f(n1)=(mean(P2_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end
if exist('P2Amp','var')==0
        P2Amp=NaN;
end
if exist('P2AllAmp','var')==0
        P2AllAmp=NaN;
end
if exist('P2Amp_6f','var')==0
    P2Amp_6f=NaN;
end
if exist('P2AllAmp_6f','var')==0
        P2AllAmp_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P3 Frequency
sz=size(P3_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF = strcmp(P3_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P3_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P3_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P3_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P3AllAmp(n2)=(P3_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P3Amp(n)=(mean(P3_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P3_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P3_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:1:sz2(2)
                P3AllAmp_6f(n3)=(P3_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P3Amp_6f(n1)=(mean(P3_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end
if exist('P3Amp','var')==0
        P3Amp=NaN;
end
if exist('P3AllAmp','var')==0
        P3AllAmp=NaN;
end
if exist('P3Amp_6f','var')==0
    P3Amp_6f=NaN;
end
if exist('P3AllAmp_6f','var')==0
        P3AllAmp_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P4 Frequency
sz=size(P4_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF = strcmp(P4_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P4_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P4_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P4_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P4AllAmp(n2)=(P4_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P4Amp(n)=(mean(P4_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P4_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P4_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:1:sz2(2)
                P4AllAmp_6f(n3)=(P4_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P4Amp_6f(n1)=(mean(P4_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end
if exist('P4Amp','var')==0
        P4Amp=NaN;
end
if exist('P4AllAmp','var')==0
        P4AllAmp=NaN;
end
if exist('P4Amp_6f','var')==0
    P4Amp_6f=NaN;
end
if exist('P4AllAmp_6f','var')==0
        P4AllAmp_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P5 Frequency
sz=size(P5_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF=strcmp(P5_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2=strcmp(P5_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P5_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P5_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P5AllAmp(n2)=(P5_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P5Amp(n)=(mean(P5_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P5_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P5_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P5AllAmp_6f(n3)=(P5_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P5Amp_6f(n1)=(mean(P5_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end
if exist('P5Amp','var')==0
        P1Amp=NaN;
end
if exist('P5AllAmp','var')==0
        P1AllAmp=NaN;
end
if exist('P5Amp_6f','var')==0
    P1Amp_6f=NaN;
end
if exist('P5AllAmp_6f','var')==0
        P1AllAmp_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P6 Frequency
sz=size(P6_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF = strcmp(P6_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P6_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P6_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P6_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P6AllAmp(n2)=(P6_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P6Amp(n)=(mean(P6_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P6_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P6_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P6AllAmp_6f(n3)=(P6_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P6Amp_6f(n1)=(mean(P6_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end
if exist('P6Amp','var')==0
        P6Amp=NaN;
end
if exist('P6AllAmp','var')==0
        P6AllAmp=NaN;
end
if exist('P6Amp_6f','var')==0
    P6Amp_6f=NaN;
end
if exist('P6AllAmp_6f','var')==0
        P6AllAmp_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P7 Frequency
sz=size(P7_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF = strcmp(P7_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P7_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P7_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P7_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P7AllAmp(n2)=(P7_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P7Amp(n)=(mean(P7_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P7_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P7_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P7AllAmp_6f(n3)=(P7_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P7Amp_6f(n1)=(mean(P7_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end
if exist('P7Amp','var')==0
        P7Amp=NaN;
end
if exist('P7AllAmp','var')==0
        P7AllAmp=NaN;
end
if exist('P7Amp_6f','var')==0
    P7Amp_6f=NaN;
end
if exist('P7AllAmp_6f','var')==0
        P7AllAmp_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P10 Frequency
sz=size(P10_all);
n=1;
n1=1;
n2=1;
n3=1;
for i=1:sz(2)
    TF = strcmp(P10_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P10_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P10_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P10_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P10AllAmp(n2)=(P10_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n2=n2+1;
            end
            P10Amp(n)=(mean(P10_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P10_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            sz2=size(P10_all(i).GlomerularData.ROI_Spikes(i2).Peaks);
            for i3=1:sz2(2)
                P10AllAmp_6f(n3)=(P10_all(i).GlomerularData.ROI_Spikes(i2).Peaks(i3)-1000)/10;
                n3=n3+1;
            end
            P10Amp_6f(n1)=(mean(P10_all(i).GlomerularData.ROI_Spikes(i2).Peaks)-1000)/10;
            n1=n1+1;
        end
    end
end
if exist('P10Amp','var')==0
        P1Amp=NaN;
end
if exist('P10AllAmp','var')==0
        P10AllAmp=NaN;
end
if exist('P10Amp_6f','var')==0
    P10Amp_6f=NaN;
end
if exist('P10AllAmp_6f','var')==0
        P10AllAmp_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%% Now collate into one Matrix
Amp=NaN(maxROI,8);
if exist('P1Amp','var')==1
    sz=size(P1Amp);
    for i=1:sz(2)
        Amp(i,1)=P1Amp(i);
    end
end

if exist('P2Amp','var')==1
    sz=size(P2Amp);
    for i=1:sz(2)
        Amp(i,2)=P2Amp(i);
    end
end

if exist('P3Amp','var')==1
    sz=size(P3Amp);
    for i=1:sz(2)
        Amp(i,3)=P3Amp(i);
    end
end

if exist('P4Amp','var')==1
    sz=size(P4Amp);
    for i=1:sz(2)
        Amp(i,4)=P4Amp(i);
    end
end

if exist('P5Amp','var')==1
    sz=size(P5Amp);
    for i=1:sz(2)
        Amp(i,5)=P5Amp(i);
    end
end

if exist('P6Amp','var')==1
    sz=size(P6Amp);
    for i=1:sz(2)
        Amp(i,6)=P6Amp(i);
    end
end

if exist('P7Amp','var')==1
    sz=size(P7Amp);
    for i=1:sz(2)
        Amp(i,7)=P7Amp(i);
    end
end

if exist('P10Amp','var')==1
    sz=size(P10Amp);
    for i=1:sz(2)
        Amp(i,8)=P10Amp(i);
    end
end

%Now for GCaMP6f
Amp_6f=NaN(maxROI_6f,8);
if exist('P1Amp_6f','var')==1
    sz=size(P1Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,1)=P1Amp_6f(i);
    end
end

if exist('P2Amp_6f','var')==1
    sz=size(P2Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,2)=P2Amp_6f(i);
    end
end

if exist('P3Amp_6f','var')==1
    sz=size(P3Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,3)=P3Amp_6f(i);
    end
end

if exist('P4Amp_6f','var')==1
    sz=size(P4Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,4)=P4Amp_6f(i);
    end
end

if exist('P5Amp_6f','var')==1
    sz=size(P5Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,5)=P5Amp_6f(i);
    end
end

if exist('P6Amp_6f','var')==1
    sz=size(P6Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,6)=P6Amp_6f(i);
    end
end

if exist('P7Amp_6f','var')==1
    sz=size(P7Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,7)=P7Amp_6f(i);
    end
end

if exist('P10Amp_6f','var')==1
    sz=size(P10Amp_6f);
    for i=1:sz(2)
        Amp_6f(i,8)=P10Amp_6f(i);
    end
end

%% Now plot the data from the Means
figure('Name','GCaMP3 Amplitude Boxplots')
boxplot(Amp)
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Amplitude \Delta F/F')
savefig('GCaMP3 Glomerular Firing Amplitude')

figure('Name','GCaMP6f Amplitude Boxplots')
boxplot(Amp_6f)
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Amplitude \DeltaF/F')
savefig('GCaMP6f Glomerular Firing Amplitude')

%% Now  Plot the Data treating each spike independently
%GCaMP3
figure('Name','GCaMP3 Amplitude Distribution')
if exist('P1AllAmp','var')==1
    sz=size(P1AllAmp);
    for i=1:sz(2)
        P1scatter(1,i)=1;
        P1scatter(2,i)=P1AllAmp(i);
    end
else P1scatter=[NaN;NaN];
end
if exist('P2AllAmp','var')==1
    sz=size(P2AllAmp);
    for i=1:sz(2)
        P2scatter(1,i)=2;
        P2scatter(2,i)=P2AllAmp(i);
    end
else P2scatter=[NaN;NaN];
end
if exist('P3AllAmp','var')==1
    sz=size(P3AllAmp);
    for i=1:sz(2)
        P3scatter(1,i)=3;
        P3scatter(2,i)=P3AllAmp(i);
    end
else P3scatter=[NaN;NaN];
end
if exist('P4AllAmp','var')==1
    sz=size(P4AllAmp);
    for i=1:sz(2)
        P4scatter(1,i)=4;
        P4scatter(2,i)=P4AllAmp(i);
    end
else P4scatter=[NaN;NaN];
end
if exist('P5AllAmp','var')==1
    sz=size(P5AllAmp);
    for i=1:sz(2)
        P5scatter(1,i)=5;
        P5scatter(2,i)=P5AllAmp(i);
    end
else P5scatter=[NaN;NaN];
end
if exist('P6AllAmp','var')==1
    sz=size(P6AllAmp);
    for i=1:sz(2)
        P6scatter(1,i)=6;
        P6scatter(2,i)=P6AllAmp(i);
    end
else P6scatter=[NaN;NaN];
end
if exist('P7AllAmp','var')==1
    sz=size(P7AllAmp);
    for i=1:sz(2)
        P7scatter(1,i)=7;
        P7scatter(2,i)=P7AllAmp(i);
    end
else P7scatter=[NaN;NaN];
end
if exist('P10AllAmp','var')==1
    sz=size(P10AllAmp);
    for i=1:sz(2)
        P10scatter(1,i)=8;
        P10scatter(2,i)=P10AllAmp(i);
    end
else P10scatter=[NaN;NaN];
end
scatter(P1scatter(1,:),P1scatter(2,:),'.b')
hold on
plot(mean(P1scatter(1,:)),mean(P1scatter(2,:)),'.r','MarkerSize',20)
scatter(P2scatter(1,:),P2scatter(2,:),'.b')
plot(mean(P2scatter(1,:)),mean(P2scatter(2,:)),'.r','MarkerSize',20)
scatter(P3scatter(1,:),P3scatter(2,:),'.b')
plot(mean(P3scatter(1,:)),mean(P3scatter(2,:)),'.r','MarkerSize',20)
scatter(P4scatter(1,:),P4scatter(2,:),'.b')
plot(mean(P4scatter(1,:)),mean(P4scatter(2,:)),'.r','MarkerSize',20)
scatter(P5scatter(1,:),P5scatter(2,:),'.b')
plot(mean(P5scatter(1,:)),mean(P5scatter(2,:)),'.r','MarkerSize',20)
scatter(P6scatter(1,:),P6scatter(2,:),'.b')
plot(mean(P6scatter(1,:)),mean(P6scatter(2,:)),'.r','MarkerSize',20)
scatter(P7scatter(1,:),P7scatter(2,:),'.b')
plot(mean(P7scatter(1,:)),mean(P7scatter(2,:)),'.r','MarkerSize',20)
scatter(P10scatter(1,:),P10scatter(2,:),'.b')
plot(mean(P10scatter(1,:)),mean(P10scatter(2,:)),'.r','MarkerSize',20)
xlim([0.5 8.5]);
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Amplitude \DeltaF/F')
savefig('GCaMP3 Glomerular Firing Amplitude')

%GCaMP6f
figure('Name','GCaMP6f Amplitude Distribution')
%Clear Scatter Data
P1scatter=[];
P2scatter=[];
P3scatter=[];
P4scatter=[];
P5scatter=[];
P6scatter=[];
P7scatter=[];
P10scatter=[];
if exist('P1AllAmp_6f','var')==1
    sz=size(P1AllAmp_6f);
    for i=1:sz(2)
        P1scatter(1,i)=1;
        P1scatter(2,i)=P1AllAmp_6f(i);
    end
else P1scatter=[NaN;NaN];
end
if exist('P2AllAmp_6f','var')==1
    sz=size(P2AllAmp_6f);
    for i=1:sz(2)
        P2scatter(1,i)=2;
        P2scatter(2,i)=P2AllAmp_6f(i);
    end
else P2scatter=[NaN;NaN];
end
if exist('P3AllAmp_6f','var')==1
    sz=size(P3AllAmp_6f);
    for i=1:sz(2)
        P3scatter(1,i)=3;
        P3scatter(2,i)=P3AllAmp_6f(i);
    end
else P3scatter=[NaN;NaN];
end
if exist('P4AllAmp_6f','var')==1
    sz=size(P4AllAmp_6f);
    for i=1:sz(2)
        P4scatter(1,i)=4;
        P4scatter(2,i)=P4AllAmp_6f(i);
    end
else P4scatter=[NaN;NaN];
end
if exist('P5AllAmp_6f','var')==1
    sz=size(P5AllAmp_6f);
    for i=1:sz(2)
        P5scatter(1,i)=5;
        P5scatter(2,i)=P5AllAmp_6f(i);
    end
else P5scatter=[NaN;NaN];
end
if exist('P6AllAmp_6f','var')==1
    sz=size(P6AllAmp_6f);
    for i=1:sz(2)
        P6scatter(1,i)=6;
        P6scatter(2,i)=P6AllAmp_6f(i);
    end
else P6scatter=[NaN;NaN];
end
if exist('P7AllAmp_6f','var')==1
    sz=size(P7AllAmp_6f);
    for i=1:sz(2)
        P7scatter(1,i)=7;
        P7scatter(2,i)=P7AllAmp_6f(i);
    end
else P7scatter=[NaN;NaN];
end
if exist('P10AllAmp_6f','var')==1
    sz=size(P10AllAmp_6f);
    for i=1:sz(2)
        P10scatter(1,i)=8;
        P10scatter(2,i)=P10AllAmp_6f(i);
    end
else P10scatter=[NaN;NaN];
end
scatter(P1scatter(1,:),P1scatter(2,:),'.b')
hold on
plot(mean(P1scatter(1,:)),mean(P1scatter(2,:)),'.r','MarkerSize',20)
scatter(P2scatter(1,:),P2scatter(2,:),'.b')
plot(mean(P2scatter(1,:)),mean(P2scatter(2,:)),'.r','MarkerSize',20)
scatter(P3scatter(1,:),P3scatter(2,:),'.b')
plot(mean(P3scatter(1,:)),mean(P3scatter(2,:)),'.r','MarkerSize',20)
scatter(P4scatter(1,:),P4scatter(2,:),'.b')
plot(mean(P4scatter(1,:)),mean(P4scatter(2,:)),'.r','MarkerSize',20)
scatter(P5scatter(1,:),P5scatter(2,:),'.b')
plot(mean(P5scatter(1,:)),mean(P5scatter(2,:)),'.r','MarkerSize',20)
scatter(P6scatter(1,:),P6scatter(2,:),'.b')
plot(mean(P6scatter(1,:)),mean(P6scatter(2,:)),'.r','MarkerSize',20)
scatter(P7scatter(1,:),P7scatter(2,:),'.b')
plot(mean(P7scatter(1,:)),mean(P7scatter(2,:)),'.r','MarkerSize',20)
scatter(P10scatter(1,:),P10scatter(2,:),'.b')
plot(mean(P10scatter(1,:)),mean(P10scatter(2,:)),'.r','MarkerSize',20)
xlim([0.5 8.5]);
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Amplitude \DeltaF/F')
savefig('GCaMP6f Glomerular Firing Amplitude')

%% Now  Plot the Data for the mean Amplitude of Glomeruli
%Clear Scatter Data
P1scatter=[];
P2scatter=[];
P3scatter=[];
P4scatter=[];
P5scatter=[];
P6scatter=[];
P7scatter=[];
P10scatter=[];
%GCaMP3
figure('Name','GCaMP3 Amplitude Distribution')
if exist('P1Amp','var')==1
    sz=size(P1Amp);
    for i=1:sz(2)
        P1scatter(1,i)=1;
        P1scatter(2,i)=P1Amp(i);
    end
else P1scatter=[NaN;NaN];
end
if exist('P2Amp','var')==1
    sz=size(P2Amp);
    for i=1:sz(2)
        P2scatter(1,i)=2;
        P2scatter(2,i)=P2Amp(i);
    end
else P2scatter=[NaN;NaN];
end
if exist('P3Amp','var')==1
    sz=size(P3Amp);
    for i=1:sz(2)
        P3scatter(1,i)=3;
        P3scatter(2,i)=P3Amp(i);
    end
else P3scatter=[NaN;NaN];
end
if exist('P4Amp','var')==1
    sz=size(P4Amp);
    for i=1:sz(2)
        P4scatter(1,i)=4;
        P4scatter(2,i)=P4Amp(i);
    end
else P4scatter=[NaN;NaN];
end
if exist('P5Amp','var')==1
    sz=size(P5Amp);
    for i=1:sz(2)
        P5scatter(1,i)=5;
        P5scatter(2,i)=P5Amp(i);
    end
else P5scatter=[NaN;NaN];
end
if exist('P6Amp','var')==1
    sz=size(P6Amp);
    for i=1:sz(2)
        P6scatter(1,i)=6;
        P6scatter(2,i)=P6Amp(i);
    end
else P6scatter=[NaN;NaN];
end
if exist('P7Amp','var')==1
    sz=size(P7Amp);
    for i=1:sz(2)
        P7scatter(1,i)=7;
        P7scatter(2,i)=P7Amp(i);
    end
else P7scatter=[NaN;NaN];
end
if exist('P10Amp','var')==1
    sz=size(P10Amp);
    for i=1:sz(2)
        P10scatter(1,i)=8;
        P10scatter(2,i)=P10Amp(i);
    end
else P10scatter=[NaN;NaN];
end
scatter(P1scatter(1,:),P1scatter(2,:),'.b')
hold on
plot(mean(P1scatter(1,:)),mean(P1scatter(2,:)),'.r','MarkerSize',20)
scatter(P2scatter(1,:),P2scatter(2,:),'.b')
plot(mean(P2scatter(1,:)),mean(P2scatter(2,:)),'.r','MarkerSize',20)
scatter(P3scatter(1,:),P3scatter(2,:),'.b')
plot(mean(P3scatter(1,:)),mean(P3scatter(2,:)),'.r','MarkerSize',20)
scatter(P4scatter(1,:),P4scatter(2,:),'.b')
plot(mean(P4scatter(1,:)),mean(P4scatter(2,:)),'.r','MarkerSize',20)
scatter(P5scatter(1,:),P5scatter(2,:),'.b')
plot(mean(P5scatter(1,:)),mean(P5scatter(2,:)),'.r','MarkerSize',20)
scatter(P6scatter(1,:),P6scatter(2,:),'.b')
plot(mean(P6scatter(1,:)),mean(P6scatter(2,:)),'.r','MarkerSize',20)
scatter(P7scatter(1,:),P7scatter(2,:),'.b')
plot(mean(P7scatter(1,:)),mean(P7scatter(2,:)),'.r','MarkerSize',20)
scatter(P10scatter(1,:),P10scatter(2,:),'.b')
plot(mean(P10scatter(1,:)),mean(P10scatter(2,:)),'.r','MarkerSize',20)
xlim([0.5 8.5]);
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Amplitude \DeltaF/F')
savefig('GCaMP3 Glomerular Firing Amplitude per Glomerulus')

%GCaMP6f
%Clear Scatter Data
P1scatter=[];
P2scatter=[];
P3scatter=[];
P4scatter=[];
P5scatter=[];
P6scatter=[];
P7scatter=[];
P10scatter=[];
figure('Name','GCaMP6f Amplitude Distribution per Glomerulus')
if exist('P1Amp_6f','var')==1
    sz=size(P1Amp_6f);
    for i=1:sz(2)
        P1scatter(1,i)=1;
        P1scatter(2,i)=P1Amp_6f(i);
    end
else P1scatter=[NaN;NaN];
end
if exist('P2Amp_6f','var')==1
    sz=size(P2Amp_6f);
    for i=1:sz(2)
        P2scatter(1,i)=2;
        P2scatter(2,i)=P2Amp_6f(i);
    end
else P2scatter=[NaN;NaN];
end
if exist('P3Amp_6f','var')==1
    sz=size(P3Amp_6f);
    for i=1:sz(2)
        P3scatter(1,i)=3;
        P3scatter(2,i)=P3Amp_6f(i);
    end
else P3scatter=[NaN;NaN];
end
if exist('P4Amp_6f','var')==1
    sz=size(P4Amp_6f);
    for i=1:sz(2)
        P4scatter(1,i)=4;
        P4scatter(2,i)=P4Amp_6f(i);
    end
else P4scatter=[NaN;NaN];
end
if exist('P5Amp_6f','var')==1
    sz=size(P5Amp_6f);
    for i=1:sz(2)
        P5scatter(1,i)=5;
        P5scatter(2,i)=P5Amp_6f(i);
    end
else P5scatter=[NaN;NaN];
end
if exist('P6Amp_6f','var')==1
    sz=size(P6Amp_6f);
    for i=1:sz(2)
        P6scatter(1,i)=6;
        P6scatter(2,i)=P6Amp_6f(i);
    end
else P6scatter=[NaN;NaN];
end
if exist('P7Amp_6f','var')==1
    sz=size(P7Amp_6f);
    for i=1:sz(2)
        P7scatter(1,i)=7;
        P7scatter(2,i)=P7Amp_6f(i);
    end
else P7scatter=[NaN;NaN];
end
if exist('P10Amp_6f','var')==1
    sz=size(P10Amp_6f);
    for i=1:sz(2)
        P10scatter(1,i)=8;
        P10scatter(2,i)=P10Amp_6f(i);
    end
else P10scatter=[NaN;NaN];
end
scatter(P1scatter(1,:),P1scatter(2,:),'.b')
hold on
plot(mean(P1scatter(1,:)),mean(P1scatter(2,:)),'.r','MarkerSize',20)
scatter(P2scatter(1,:),P2scatter(2,:),'.b')
plot(mean(P2scatter(1,:)),mean(P2scatter(2,:)),'.r','MarkerSize',20)
scatter(P3scatter(1,:),P3scatter(2,:),'.b')
plot(mean(P3scatter(1,:)),mean(P3scatter(2,:)),'.r','MarkerSize',20)
scatter(P4scatter(1,:),P4scatter(2,:),'.b')
plot(mean(P4scatter(1,:)),mean(P4scatter(2,:)),'.r','MarkerSize',20)
scatter(P5scatter(1,:),P5scatter(2,:),'.b')
plot(mean(P5scatter(1,:)),mean(P5scatter(2,:)),'.r','MarkerSize',20)
scatter(P6scatter(1,:),P6scatter(2,:),'.b')
plot(mean(P6scatter(1,:)),mean(P6scatter(2,:)),'.r','MarkerSize',20)
scatter(P7scatter(1,:),P7scatter(2,:),'.b')
plot(mean(P7scatter(1,:)),mean(P7scatter(2,:)),'.r','MarkerSize',20)
scatter(P10scatter(1,:),P10scatter(2,:),'.b')
plot(mean(P10scatter(1,:)),mean(P10scatter(2,:)),'.r','MarkerSize',20)
xlim([0.5 8.5]);
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Amplitude \DeltaF/F')
savefig('GCaMP6f Glomerular Firing Amplitude per glomerulus')

%% Cumulative Plots
%figure('Name','GCaMP3 - Cumulative Amplitude Plot')
figure('Name','GCaMP3 - Cumulative Amplitude Plot')
mnl_CumulativePlot3(P1Amp',P2Amp',P3Amp',P4Amp',P5Amp',P6Amp',P7Amp',P10Amp');
xlabel('Amplitude \DeltaF/F')
ylabel('Cuumulative Percent')
hleg=legend('P1','P2','P3','P4','P5','P6','P7','P10');
savefig('GCaMP3_CumulativeAmplitudePlotPerGlom')
figure('Name','GCaMP3 - Cumulative Amplitude Plot All Spikes')
mnl_CumulativePlot3(P1AllAmp',P2AllAmp',P3AllAmp',P4AllAmp',P5AllAmp',P6AllAmp',P7AllAmp',P10AllAmp');
xlabel('Amplitude \DeltaF/F')
ylabel('Cuumulative Percent')
hleg=legend('P1','P2','P3','P4','P5','P6','P7','P10');
savefig('GCaMP3_CumulativeAmplitudePlotAllSpikes')
figure('Name','GCaMP6f - Cumulative Amplitude Plot')
mnl_CumulativePlot3(P1Amp_6f',P2Amp_6f',P3Amp_6f',P4Amp_6f',P5Amp_6f',P6Amp_6f',P7Amp_6f',P10Amp_6f');
xlabel('Amplitude \DeltaF/F')
ylabel('Cuumulative Percent')
hleg=legend('P1','P2','P3','P4','P5','P6','P7','P10');
savefig('GCaMP6f_CumulativeAmplitudePlotPerGlom')
figure('Name','GCaMP6f - Cumulative Amplitude Plot All Spikes')
mnl_CumulativePlot3(P1AllAmp_6f',P2AllAmp_6f',P3AllAmp_6f',P4AllAmp_6f',P5AllAmp_6f',P6AllAmp_6f',P7AllAmp_6f',P10AllAmp_6f');
xlabel('Amplitude \DeltaF/F')
ylabel('Cuumulative Percent')
savefig('GCaMP6f_CumulativeAmplitudePlotAllSpikes')
end
function [Freq,Freq_6f]=mnl_FrequencyBoxPlots(P1_all,P2_all,P3_all,P4_all,P5_all,P6_all,P7_all,P10_all)
%% Extract Information
%P1 Frequency
sz=size(P1_all);
n=1;
n1=1;
for i=1:sz(2)
    TF = strcmp(P1_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P1_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P1_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P1freq(n)=P1_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P1_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P1freq_6f(n1)=P1_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P1freq')==0
        P1freq=NaN;
end
if exist('P1freq_6f')==0
    P1freq_6f=NaN;
end
maxROI=n-1;
maxROI_6f=n1-1;
%P2 Frequency
sz=size(P2_all);
n=1;
n1=1;
for i=1:sz(2)
    TF = strcmp(P2_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P2_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P2_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P2freq(n)=P2_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P2_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P2freq_6f(n1)=P2_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P2freq')==0
    P2freq=NaN;
end
if exist('P2freq_6f')==0
    P2freq_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P3 Frequency
sz=size(P3_all);
n=1;
n1=1;
for i=1:sz(2)
    TF = strcmp(P3_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P3_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P3_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P3freq(n)=P3_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P3_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P3freq_6f(n1)=P3_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P3freq')==0
    P3freq=NaN;
end
if exist('P3freq_6f')==0
    P3freq_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P4 Frequency
sz=size(P4_all);
n=1;
n1=1;
for i=1:sz(2)
    TF = strcmp(P4_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P4_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P4_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P4freq(n)=P4_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P4_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P4freq_6f(n1)=P4_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P4freq')==0
    P4freq=NaN;
end
if exist('P4freq_6f')==0
    P4freq_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P5 Frequency
sz=size(P5_all);
n=1;
n1=1;
for i=1:sz(2)
    TF=strcmp(P5_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2=strcmp(P5_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P5_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P5freq(n)=P5_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P5_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P5freq_6f(n1)=P5_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P5freq')==0
    P5freq=NaN;
end
if exist('P5freq_6f')==0
    P5freq_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P6 Frequency
sz=size(P6_all);
n=1;
n1=1;
for i=1:sz(2)
    TF = strcmp(P6_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P6_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P6_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P6freq(n)=P6_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P6_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P6freq_6f(n1)=P6_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P6freq')==0
    P6freq=NaN;
end
if exist('P6freq_6f')==0
    P6freq_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P7 Frequency
sz=size(P7_all);
n=1;
n1=1;
for i=1:sz(2)
    TF = strcmp(P7_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P7_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P7_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P7freq(n)=P7_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P7_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P7freq_6f(n1)=P7_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P7freq')==0
    P7freq=NaN;
end
if exist('P7freq_6f')==0
    P7freq_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%P10 Frequency
sz=size(P10_all);
n=1;
n1=1;
for i=1:sz(2)
    TF = strcmp(P10_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P10_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        sz1=size(P10_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P10freq(n)=P10_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n=n+1;
        end
    elseif TF2==1
        sz1=size(P10_all(i).GlomerularData.ROI_Spikes);
        for i2=1:sz1(2)
            P10freq_6f(n1)=P10_all(i).GlomerularData.ROI_Spikes(i2).Frequency;
            n1=n1+1;
        end
    end
end
if exist('P10freq')==0
    P10freq=NaN;
end
if exist('P10freq_6f')==0
    P10freq_6f=NaN;
end
if  maxROI<n-1
    maxROI=n-1;
end
if  maxROI_6f<n1-1
    maxROI_6f=n1-1;
end
%% Now collate into one Matrix
Freq=NaN(maxROI,8);
if exist('P1freq','var')==1
    sz=size(P1freq);
    for i=1:sz(2)
        Freq(i,1)=P1freq(i);
    end
end

if exist('P2freq','var')==1
    sz=size(P2freq);
    for i=1:sz(2)
        Freq(i,2)=P2freq(i);
    end
end

if exist('P3freq','var')==1
    sz=size(P3freq);
    for i=1:sz(2)
        Freq(i,3)=P3freq(i);
    end
end

if exist('P4freq','var')==1
    sz=size(P4freq);
    for i=1:sz(2)
        Freq(i,4)=P4freq(i);
    end
end

if exist('P5freq','var')==1
    sz=size(P5freq);
    for i=1:sz(2)
        Freq(i,5)=P5freq(i);
    end
end

if exist('P6freq','var')==1
    sz=size(P6freq);
    for i=1:sz(2)
        Freq(i,6)=P6freq(i);
    end
end

if exist('P7freq','var')==1
    sz=size(P7freq);
    for i=1:sz(2)
        Freq(i,7)=P7freq(i);
    end
end

if exist('P10freq','var')==1
    sz=size(P10freq);
    for i=1:sz(2)
        Freq(i,8)=P10freq(i);
    end
end

Freq=Freq*60;
%Now for GCaMP6f
Freq_6f=NaN(maxROI_6f,8);
if exist('P1freq_6f','var')==1
    sz=size(P1freq_6f);
    for i=1:sz(2)
        Freq_6f(i,1)=P1freq_6f(i);
    end
end

if exist('P2freq_6f','var')==1
    sz=size(P2freq_6f);
    for i=1:sz(2)
        Freq_6f(i,2)=P2freq_6f(i);
    end
end

if exist('P3freq_6f','var')==1
    sz=size(P3freq_6f);
    for i=1:sz(2)
        Freq_6f(i,3)=P3freq_6f(i);
    end
end

if exist('P4freq_6f','var')==1
    sz=size(P4freq_6f);
    for i=1:sz(2)
        Freq_6f(i,4)=P4freq_6f(i);
    end
end

if exist('P5freq_6f','var')==1
    sz=size(P5freq_6f);
    for i=1:sz(2)
        Freq_6f(i,5)=P5freq_6f(i);
    end
end

if exist('P6freq_6f','var')==1
    sz=size(P6freq_6f);
    for i=1:sz(2)
        Freq_6f(i,6)=P6freq_6f(i);
    end
end

if exist('P7freq_6f','var')==1
    sz=size(P7freq_6f);
    for i=1:sz(2)
        Freq_6f(i,7)=P7freq_6f(i);
    end
end

if exist('P10freq_6f','var')==1
    sz=size(P10freq_6f);
    for i=1:sz(2)
        Freq_6f(i,8)=P10freq_6f(i);
    end
end
Freq_6f=Freq_6f*60;

%% Now plot the data
%Boxplot
figure('Name','GCaMP3 boxplots')
boxplot(Freq)
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Frequency (Events per min)')
savefig('GCaMP3 Glomerular Firing Frequency')

figure('Name','GCaMP6f boxplots')
boxplot(Freq_6f)
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Frequency (Events per min)')
savefig('GCaMP6f Glomerular Firing Frequency')
%All Points plot
%GCaMP3
%Clear Scatter Data
P1scatter=[];
P2scatter=[];
P3scatter=[];
P4scatter=[];
P5scatter=[];
P6scatter=[];
P7scatter=[];
P10scatter=[];
figure('Name','GCaMP3 Frequency Distribution per Glomerulus')
if exist('P1freq','var')==1
    sz=size(P1freq);
    for i=1:sz(2)
        P1scatter(1,i)=1;
        P1scatter(2,i)=P1freq(i)*60;
    end
else P1scatter=[NaN;NaN];
end
if exist('P2freq','var')==1
    sz=size(P2freq);
    for i=1:sz(2)
        P2scatter(1,i)=2;
        P2scatter(2,i)=P2freq(i)*60;
    end
else P2scatter=[NaN;NaN];
end
if exist('P3freq','var')==1
    sz=size(P3freq);
    for i=1:sz(2)
        P3scatter(1,i)=3;
        P3scatter(2,i)=P3freq(i)*60;
    end
else P3scatter=[NaN;NaN];
end
if exist('P4freq','var')==1
    sz=size(P4freq);
    for i=1:sz(2)
        P4scatter(1,i)=4;
        P4scatter(2,i)=P4freq(i)*60;
    end
else P4scatter=[NaN;NaN];
end
if exist('P5freq','var')==1
    sz=size(P5freq);
    for i=1:sz(2)
        P5scatter(1,i)=5;
        P5scatter(2,i)=P5freq(i)*60;
    end
else P5scatter=[NaN;NaN];
end
if exist('P6freq','var')==1
    sz=size(P6freq);
    for i=1:sz(2)
        P6scatter(1,i)=6;
        P6scatter(2,i)=P6freq(i)*60;
    end
else P6scatter=[NaN;NaN];
end
if exist('P7freq','var')==1
    sz=size(P7freq);
    for i=1:sz(2)
        P7scatter(1,i)=7;
        P7scatter(2,i)=P7freq(i)*60;
    end
else P7scatter=[NaN;NaN];
end
if exist('P10freq','var')==1
    sz=size(P10freq);
    for i=1:sz(2)
        P10scatter(1,i)=8;
        P10scatter(2,i)=P10freq(i)*60;
    end
else P10scatter=[NaN;NaN];
end
scatter(P1scatter(1,:),P1scatter(2,:),'.b')
hold on
plot(mean(P1scatter(1,:)),mean(P1scatter(2,:)),'.r','MarkerSize',20)
scatter(P2scatter(1,:),P2scatter(2,:),'.b')
plot(mean(P2scatter(1,:)),mean(P2scatter(2,:)),'.r','MarkerSize',20)
scatter(P3scatter(1,:),P3scatter(2,:),'.b')
plot(mean(P3scatter(1,:)),mean(P3scatter(2,:)),'.r','MarkerSize',20)
scatter(P4scatter(1,:),P4scatter(2,:),'.b')
plot(mean(P4scatter(1,:)),mean(P4scatter(2,:)),'.r','MarkerSize',20)
scatter(P5scatter(1,:),P5scatter(2,:),'.b')
plot(mean(P5scatter(1,:)),mean(P5scatter(2,:)),'.r','MarkerSize',20)
scatter(P6scatter(1,:),P6scatter(2,:),'.b')
plot(mean(P6scatter(1,:)),mean(P6scatter(2,:)),'.r','MarkerSize',20)
scatter(P7scatter(1,:),P7scatter(2,:),'.b')
plot(mean(P7scatter(1,:)),mean(P7scatter(2,:)),'.r','MarkerSize',20)
scatter(P10scatter(1,:),P10scatter(2,:),'.b')
plot(mean(P10scatter(1,:)),mean(P10scatter(2,:)),'.r','MarkerSize',20)
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Frequency (Events per min')
savefig('GCaMP6f Glomerular Firing Frequency per glomerulus')
%GCaMP6f
%Clear Scatter Data
P1scatter=[];
P2scatter=[];
P3scatter=[];
P4scatter=[];
P5scatter=[];
P6scatter=[];
P7scatter=[];
P10scatter=[];
figure('Name','GCaMP6f Frequency Distribution per Glomerulus')
if exist('P1freq_6f','var')==1
    sz=size(P1freq_6f);
    for i=1:sz(2)
        P1scatter(1,i)=1;
        P1scatter(2,i)=P1freq_6f(i)*60;
    end
else P1scatter=[NaN;NaN];
end
if exist('P2freq_6f','var')==1
    sz=size(P2freq_6f);
    for i=1:sz(2)
        P2scatter(1,i)=2;
        P2scatter(2,i)=P2freq_6f(i)*60;
    end
else P2scatter=[NaN;NaN];
end
if exist('P3freq_6f','var')==1
    sz=size(P3freq_6f);
    for i=1:sz(2)
        P3scatter(1,i)=3;
        P3scatter(2,i)=P3freq_6f(i)*60;
    end
else P3scatter=[NaN;NaN];
end
if exist('P4freq_6f','var')==1
    sz=size(P4freq_6f);
    for i=1:sz(2)
        P4scatter(1,i)=4;
        P4scatter(2,i)=P4freq_6f(i)*60;
    end
else P4scatter=[NaN;NaN];
end
if exist('P5freq_6f','var')==1
    sz=size(P5freq_6f);
    for i=1:sz(2)
        P5scatter(1,i)=5;
        P5scatter(2,i)=P5freq_6f(i)*60;
    end
else P5scatter=[NaN;NaN];
end
if exist('P6freq_6f','var')==1
    sz=size(P6freq_6f);
    for i=1:sz(2)
        P6scatter(1,i)=6;
        P6scatter(2,i)=P6freq_6f(i)*60;
    end
else P6scatter=[NaN;NaN];
end
if exist('P7freq_6f','var')==1
    sz=size(P7freq_6f);
    for i=1:sz(2)
        P7scatter(1,i)=7;
        P7scatter(2,i)=P7freq_6f(i)*60;
    end
else P7scatter=[NaN;NaN];
end
if exist('P10freq_6f','var')==1
    sz=size(P10freq_6f);
    for i=1:sz(2)
        P10scatter(1,i)=8;
        P10scatter(2,i)=P10freq_6f(i)*60;
    end
else P10scatter=[NaN;NaN];
end
scatter(P1scatter(1,:),P1scatter(2,:),'.b')
hold on
plot(mean(P1scatter(1,:)),mean(P1scatter(2,:)),'.r','MarkerSize',20)
scatter(P2scatter(1,:),P2scatter(2,:),'.b')
plot(mean(P2scatter(1,:)),mean(P2scatter(2,:)),'.r','MarkerSize',20)
scatter(P3scatter(1,:),P3scatter(2,:),'.b')
plot(mean(P3scatter(1,:)),mean(P3scatter(2,:)),'.r','MarkerSize',20)
scatter(P4scatter(1,:),P4scatter(2,:),'.b')
plot(mean(P4scatter(1,:)),mean(P4scatter(2,:)),'.r','MarkerSize',20)
scatter(P5scatter(1,:),P5scatter(2,:),'.b')
plot(mean(P5scatter(1,:)),mean(P5scatter(2,:)),'.r','MarkerSize',20)
scatter(P6scatter(1,:),P6scatter(2,:),'.b')
plot(mean(P6scatter(1,:)),mean(P6scatter(2,:)),'.r','MarkerSize',20)
scatter(P7scatter(1,:),P7scatter(2,:),'.b')
plot(mean(P7scatter(1,:)),mean(P7scatter(2,:)),'.r','MarkerSize',20)
scatter(P10scatter(1,:),P10scatter(2,:),'.b')
plot(mean(P10scatter(1,:)),mean(P10scatter(2,:)),'.r','MarkerSize',20)
ax=gca;
set(ax,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P10'});
set(ax,'XTick',[1 2 3 4 5 6 7 8]);
ylabel('Frequency (Events per min)')
savefig('GCaMP6f Glomerular Firing Frequency per glomerulus')
%% Cumulative Plots
figure('Name','GCaMP3 - Cumulative Frequency Plot')
mnl_CumulativePlot3(P1freq'*60,P2freq'*60,P3freq'*60,P4freq'*60,P5freq'*60,P6freq'*60,P7freq'*60,P10freq'*60);
xlabel('Frequency (Events per Minute)')
ylabel('Cuumulative Percent')
hleg=legend('P1','P2','P3','P4','P5','P6','P7','P10');
savefig('GCaMP3_CumulativeFrequencyPlotPerGlom')
figure('Name','GCaMP6f - Cumulative Frequency Plot')
mnl_CumulativePlot3(P1freq_6f'*60,P2freq_6f'*60,P3freq_6f'*60,P4freq_6f'*60,P5freq_6f'*60,P6freq_6f'*60,P7freq_6f'*60,P10freq_6f'*60);
xlabel('Frequemcy (Events per Minute)')
ylabel('Cuumulative Percent')
hleg=legend('P1','P2','P3','P4','P5','P6','P7','P10');
savefig('GCaMP6f_CumulativeFrequencyPlotPerGlom')

end
function [GCaMP3_AmpFreq,GCaMP6f_AmpFreq]=mnl_FreqAmpRelationship(Freq,Amp,Freq_6f,Amp_6f)
%Plot GCaMP3 data
sz=size(Freq);
figure('Name','GCaMP3 Scatter')
cmap=colormap(jet(sz(2)));
for i=1:sz(2)
    n=1;
    x=[];
    y=[];
    if isnan(Freq(1,i))==0
        for i2=1:sz(1)
            if  isnan(Freq(i2,i))==0
                x(n)=Freq(i2,i);
                y(n)=Amp(i2,i);
                n=n+1;
            end
        end
    end
    scatter(x,y,5,'MarkerFaceColor',cmap(i,:,:),'MarkerEdgeColor',cmap(i,:,:))
    hold on
    if isempty(x)==0
        mdl=fitlm(x,y);
        R2values(i)=mdl.Rsquared.Adjusted;
        fitX(:,i)=linspace(0,max(x),100);
        Coeff=table2array(mdl.Coefficients);
        c=Coeff(1,1);
        m=Coeff(2,1);
        CoeffVals(i).Table=mdl.Coefficients;
        for i3=1:100
            fitY(i3,i)=(fitX(i3,i)*m)+c;
        end
    end
end
for i=1:sz(2)
    plot(fitX(:,i),fitY(:,i),'Color',cmap(i,:,:),'LineWidth',2)
end
xlabel('Frequency (Events per Minute)')
ylabel('Amplitude \DeltaF/F')
savefig('GCaMP3 Frequence vs Amplitude')
GCaMP3_AmpFreq=struct('Coefff',CoeffVals,'R2values',R2values,'fitX',fitX,'fitY',fitY);
%Plot GCaMP6f data
sz=size(Freq_6f);
figure('Name','GCaMP6f Scatter')
cmap=colormap(jet(sz(2)));
for i=1:sz(2)
    n=1;
    x=[];
    y=[];
    if isnan(Freq_6f(1,i))==0
        for i2=1:sz(1)
            if isnan(Freq_6f(i2,i))==0
                x(n)=Freq_6f(i2,i);
                y(n)=Amp_6f(i2,i);
                n=n+1;
            end
        end
    end
    scatter(x,y,5,'MarkerFaceColor',cmap(i,:,:),'MarkerEdgeColor',cmap(i,:,:))
    hold on
    if isempty(x)==0
        mdl=fitlm(x,y);
        R2values_6f(i)=mdl.Rsquared.Adjusted;
        fitX_6f(:,i)=linspace(0,max(x),100);
        Coeff_6f=table2array(mdl.Coefficients);
        c=Coeff_6f(1,1);
        m=Coeff_6f(2,1);
        CoeffVals(i).Table=mdl.Coefficients;
        for i3=1:100
            fitY_6f(i3,i)=(fitX_6f(i3,i)*m)+c;
        end
    end
end
for i=1:sz(2)
    plot(fitX_6f(:,i),fitY_6f(:,i),'Color',cmap(i,:,:),'LineWidth',2)
end
hleg=legend('P1','P2','P3','P4','P5','P6','P7','P10');
xlabel('Frequency (Events per Minute)')
ylabel('Amplitude \DeltaF/F')
savefig('GCaMP6f Frequence vs Amplitude')
GCaMP6f_AmpFreq=struct('Coefff',CoeffVals,'R2values',R2values,'fitX',fitX,'fitY',fitY);
end
function [a,b,HalfLife]=mnl_STTCgroups(P1_all,P2_all,P3_all,P4_all,P5_all,P6_all,P7_all,P10_all) %NB need to remove [0,0] STTC comparisons
sz=size(P1_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P1_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P1_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P1_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P1_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P1_STTC_GCthree(GCthree,:)=P1_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P1_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P1_STTC_GCsix(GCsix,:)=P1_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P1_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P1_STTC(n,:)=P1_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end
sz=size(P2_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P2_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P2_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P2_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P2_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P2_STTC_GCthree(GCthree,:)=P2_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P2_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P2_STTC_GCsix(GCsix,:)=P2_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P2_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P2_STTC(n,:)=P2_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end
sz=size(P3_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P3_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P3_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P3_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P3_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P3_STTC_GCthree(GCthree,:)=P3_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P3_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P3_STTC_GCsix(GCsix,:)=P3_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P3_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P3_STTC(n,:)=P3_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end
sz=size(P4_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P4_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P4_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P4_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P4_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P4_STTC_GCthree(GCthree,:)=P4_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P4_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P4_STTC_GCsix(GCsix,:)=P4_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P4_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P4_STTC(n,:)=P4_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end
sz=size(P5_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P5_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P5_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P5_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P5_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P5_STTC_GCthree(GCthree,:)=P5_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P5_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P5_STTC_GCsix(GCsix,:)=P5_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P5_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P5_STTC(n,:)=P5_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end
sz=size(P6_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P6_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P6_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P6_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P6_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P6_STTC_GCthree(GCthree,:)=P6_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P6_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P6_STTC_GCsix(GCsix,:)=P6_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P6_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P6_STTC(n,:)=P6_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end
sz=size(P7_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P7_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P7_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P7_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P7_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P7_STTC_GCthree(GCthree,:)=P7_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P7_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P7_STTC_GCsix(GCsix,:)=P7_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P7_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P7_STTC(n,:)=P7_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end
sz=size(P10_all);
n=1;
GCthree=1;
GCsix=1;
for i=1:sz(2)
    sz1=size(P10_all(i).STTC.SimpleSTTC.STTC);
    TF = strcmp(P10_all(i).BasicInfo.IndicatorType,'GCaMP3');
    TF2 = strcmp(P10_all(i).BasicInfo.IndicatorType,'GCaMP6f');
    if TF==1
        for i2=1:sz1(1)
            if  P10_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P10_STTC_GCthree(GCthree,:)=P10_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCthree=GCthree+1;
            end
        end
    end
    if TF2==1
        for i2=1:sz1(1)
            if  P10_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
                P10_STTC_GCsix(GCsix,:)=P10_all(i).STTC.SimpleSTTC.STTC(i2,:);
                GCsix=GCsix+1;
            end
        end
    end
    for i2=1:sz1(1)
        if P10_all(i).STTC.SimpleSTTC.STTC(i2,2)~=0
            P10_STTC(n,:)=P10_all(i).STTC.SimpleSTTC.STTC(i2,:);
            n=n+1;
        end
    end
end

%Plot a path with error bars - Combined
figure('name','STTC Combined')
cmap=colormap(jet(8));

sz=size(P1_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P1_bin,P1_sem_bin,P1_std_bin] = mnl_BinInputs(P1_STTC(:,2),P1_STTC(:,1),bin);
errorbar(P1_bin(:,1),P1_bin(:,2),P1_sem_bin(:,2),'color',cmap(1,:))
hold on

sz=size(P2_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P2_bin,P2_sem_bin,P2_std_bin] = mnl_BinInputs(P2_STTC(:,2),P2_STTC(:,1),bin);
errorbar(P2_bin(:,1),P2_bin(:,2),P2_sem_bin(:,2),'color',cmap(2,:))
hold on

sz=size(P3_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P3_bin,P3_sem_bin,P3_std_bin] = mnl_BinInputs(P3_STTC(:,2),P3_STTC(:,1),bin);
errorbar(P3_bin(:,1),P3_bin(:,2),P3_sem_bin(:,2),'color',cmap(3,:))

sz=size(P4_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P4_bin,P4_sem_bin,P4_std_bin] = mnl_BinInputs(P4_STTC(:,2),P4_STTC(:,1),bin);
errorbar(P4_bin(:,1),P4_bin(:,2),P4_sem_bin(:,2),'color',cmap(4,:))

sz=size(P5_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P5_bin,P5_sem_bin,P5_std_bin] = mnl_BinInputs(P5_STTC(:,2),P5_STTC(:,1),bin);
errorbar(P5_bin(:,1),P5_bin(:,2),P5_sem_bin(:,2),'color',cmap(5,:))

sz=size(P6_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P6_bin,P6_sem_bin,P6_std_bin] = mnl_BinInputs(P6_STTC(:,2),P6_STTC(:,1),bin);
errorbar(P6_bin(:,1),P6_bin(:,2),P6_sem_bin(:,2),'color',cmap(6,:))

sz=size(P7_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P7_bin,P7_sem_bin,P7_std_bin] = mnl_BinInputs(P7_STTC(:,2),P7_STTC(:,1),bin);
errorbar(P7_bin(:,1),P7_bin(:,2),P7_sem_bin(:,2),'color',cmap(7,:))

sz=size(P10_STTC(:,2));
bin=round(sz(1)/20); % Every 5% binned
[P10_bin,P10_sem_bin,P10_std_bin] = mnl_BinInputs(P10_STTC(:,2),P10_STTC(:,1),bin);
errorbar(P10_bin(:,1),P10_bin(:,2),P10_sem_bin(:,2),'color',cmap(8,:))
legend('P1','P2','P3','P4','P5','P6','P7','P10')
xlabel('Distance (um)')
ylabel('STTC')

%Plot a path with error bars - GCaMP3
figure('name','STTC GCaMP3')
cmap=colormap(jet(8));
if  exist('P1_STTC_GCthree','var')==1
    sz=size(P1_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P1_bin_GC3,P1_sem_bin_GC3,P1_std_bin_GC3] = mnl_BinInputs(P1_STTC_GCthree(:,2),P1_STTC_GCthree(:,1),bin);
    errorbar(P1_bin_GC3(:,1),P1_bin_GC3(:,2),P1_sem_bin_GC3(:,2),'color',cmap(1,:))
    hold on
end

if  exist('P2_STTC_GCthree','var')==1
    sz=size(P2_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P2_bin_GC3,P2_sem_bin_GC3,P2_std_bin_GC3] = mnl_BinInputs(P2_STTC_GCthree(:,2),P2_STTC_GCthree(:,1),bin);
    errorbar(P2_bin_GC3(:,1),P2_bin_GC3(:,2),P2_sem_bin_GC3(:,2),'color',cmap(2,:))
    hold on
end

if  exist('P3_STTC_GCthree','var')==1
    sz=size(P3_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P3_bin_GC3,P3_sem_bin_GC3,P3_std_bin_GC3] = mnl_BinInputs(P3_STTC_GCthree(:,2),P3_STTC_GCthree(:,1),bin);
    errorbar(P3_bin_GC3(:,1),P3_bin_GC3(:,2),P3_sem_bin_GC3(:,2),'color',cmap(3,:))
    hold on
end

if  exist('P4_STTC_GCthree','var')==1
    sz=size(P4_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P4_bin_GC3,P4_sem_bin_GC3,P4_std_bin_GC3] = mnl_BinInputs(P4_STTC_GCthree(:,2),P4_STTC_GCthree(:,1),bin);
    errorbar(P4_bin_GC3(:,1),P4_bin_GC3(:,2),P4_sem_bin_GC3(:,2),'color',cmap(4,:))
    hold on
end

if  exist('P5_STTC_GCthree','var')==1
    sz=size(P5_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P5_bin_GC3,P5_sem_bin_GC3,P5_std_bin_GC3] = mnl_BinInputs(P5_STTC_GCthree(:,2),P5_STTC_GCthree(:,1),bin);
    errorbar(P5_bin_GC3(:,1),P5_bin_GC3(:,2),P5_sem_bin_GC3(:,2),'color',cmap(5,:))
    hold on
end

if  exist('P6_STTC_GCthree','var')==1
    sz=size(P6_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P6_bin_GC3,P6_sem_bin_GC3,P6_std_bin_GC3] = mnl_BinInputs(P6_STTC_GCthree(:,2),P6_STTC_GCthree(:,1),bin);
    errorbar(P6_bin_GC3(:,1),P6_bin_GC3(:,2),P6_sem_bin_GC3(:,2),'color',cmap(6,:))
    hold on
end

if  exist('P7_STTC_GCthree','var')==1
    sz=size(P7_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P7_bin_GC3,P7_sem_bin_GC3,P7_std_bin_GC3] = mnl_BinInputs(P7_STTC_GCthree(:,2),P7_STTC_GCthree(:,1),bin);
    errorbar(P7_bin_GC3(:,1),P7_bin_GC3(:,2),P7_sem_bin_GC3(:,2),'color',cmap(7,:))
    hold on
end

if  exist('P10_STTC_GCthree','var')==1
    sz=size(P10_STTC_GCthree(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P10_bin_GC3,P10_sem_bin_GC3,P10_std_bin_GC3] = mnl_BinInputs(P10_STTC_GCthree(:,2),P10_STTC_GCthree(:,1),bin);
    errorbar(P10_bin_GC3(:,1),P10_bin_GC3(:,2),P10_sem_bin_GC3(:,2),'color',cmap(8,:))
    hold on
end
legend('P1','P2','P3','P4','P5','P6','P7','P10')
xlabel('Distance (um)')
ylabel('STTC')

%Plot a path with error bars - GCaMP6
figure('name','STTC GCaMP6')
cmap=colormap(jet(8));
if  exist('P1_STTC_GCsix','var')==1
    sz=size(P1_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P1_bin_GC6,P1_sem_bin_GC6,P1_std_bin_GC6] = mnl_BinInputs(P1_STTC_GCsix(:,2),P1_STTC_GCsix(:,1),bin);
    errorbar(P1_bin_GC6(:,1),P1_bin_GC6(:,2),P1_sem_bin_GC6(:,2),'color',cmap(1,:))
    hold on
end

if  exist('P2_STTC_GCsix','var')==1
    sz=size(P2_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P2_bin_GC6,P2_sem_bin_GC6,P2_std_bin_GC6] = mnl_BinInputs(P2_STTC_GCsix(:,2),P2_STTC_GCsix(:,1),bin);
    errorbar(P2_bin_GC6(:,1),P2_bin_GC6(:,2),P2_sem_bin_GC6(:,2),'color',cmap(2,:))
    hold on
end

if  exist('P3_STTC_GCsix','var')==1
    sz=size(P3_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P3_bin_GC6,P3_sem_bin_GC6,P3_std_bin_GC6] = mnl_BinInputs(P3_STTC_GCsix(:,2),P3_STTC_GCsix(:,1),bin);
    errorbar(P3_bin_GC6(:,1),P3_bin_GC6(:,2),P3_sem_bin_GC6(:,2),'color',cmap(3,:))
    hold on
end

if  exist('P4_STTC_GCsix','var')==1
    sz=size(P4_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P4_bin_GC6,P4_sem_bin_GC6,P4_std_bin_GC6] = mnl_BinInputs(P4_STTC_GCsix(:,2),P4_STTC_GCsix(:,1),bin);
    errorbar(P4_bin_GC6(:,1),P4_bin_GC6(:,2),P4_sem_bin_GC6(:,2),'color',cmap(4,:))
    hold on
end

if  exist('P5_STTC_GCsix','var')==1
    sz=size(P5_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P5_bin_GC6,P5_sem_bin_GC6,P5_std_bin_GC6] = mnl_BinInputs(P5_STTC_GCsix(:,2),P5_STTC_GCsix(:,1),bin);
    errorbar(P5_bin_GC6(:,1),P5_bin_GC6(:,2),P5_sem_bin_GC6(:,2),'color',cmap(5,:))
    hold on
end

if  exist('P6_STTC_GCsix','var')==1
    sz=size(P6_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P6_bin_GC6,P6_sem_bin_GC6,P6_std_bin_GC6] = mnl_BinInputs(P6_STTC_GCsix(:,2),P6_STTC_GCsix(:,1),bin);
    errorbar(P6_bin_GC6(:,1),P6_bin_GC6(:,2),P6_sem_bin_GC6(:,2),'color',cmap(6,:))
    hold on
end

if  exist('P7_STTC_GCsix','var')==1
    sz=size(P7_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P7_bin_GC6,P7_sem_bin_GC6,P7_std_bin_GC6] = mnl_BinInputs(P7_STTC_GCsix(:,2),P7_STTC_GCsix(:,1),bin);
    errorbar(P7_bin_GC6(:,1),P7_bin_GC6(:,2),P7_sem_bin_GC6(:,2),'color',cmap(7,:))
    hold on
end

if  exist('P10_STTC_GCsix','var')==1
    sz=size(P10_STTC_GCsix(:,2));
    bin=round(sz(1)/20); % Every 5% binned
    [P10_bin_GC6,P10_sem_bin_GC6,P10_std_bin_GC6] = mnl_BinInputs(P10_STTC_GCsix(:,2),P10_STTC_GCsix(:,1),bin);
    errorbar(P10_bin_GC6(:,1),P10_bin_GC6(:,2),P10_sem_bin_GC6(:,2),'color',cmap(8,:))
    hold on
end
legend('P1','P2','P3','P4','P5','P6','P7','P10')
xlabel('Distance (um)')
ylabel('STTC')
%% Curve Fits
figure('name','STTC Curve Fits')
[P1_Span,P1_RateConstant,P1_HalfLife]=mnl_ExponentialFit(P1_STTC(:,2),P1_STTC(:,1),1);
hold on
[P2_Span,P2_RateConstant,P2_HalfLife]=mnl_ExponentialFit(P2_STTC(:,2),P2_STTC(:,1),1);
[P3_Span,P3_RateConstant,P3_HalfLife]=mnl_ExponentialFit(P3_STTC(:,2),P3_STTC(:,1),2);
[P4_Span,P4_RateConstant,P4_HalfLife]=mnl_ExponentialFit(P4_STTC(:,2),P4_STTC(:,1),3);
[P5_Span,P5_RateConstant,P5_HalfLife]=mnl_ExponentialFit(P5_STTC(:,2),P5_STTC(:,1),4);
[P6_Span,P6_RateConstant,P6_HalfLife]=mnl_ExponentialFit(P6_STTC(:,2),P6_STTC(:,1),5);
[P7_Span,P7_RateConstant,P7_HalfLife]=mnl_ExponentialFit(P7_STTC(:,2),P7_STTC(:,1),6);
[P10_Span,P10_RateConstant,P10_HalfLife]=mnl_ExponentialFit(P10_STTC(:,2),P10_STTC(:,1),7);
legend('P1','P2','P3','P4','P5','P6','P7','P10')
xlabel('Distance (um)')
ylabel('STTC')

%% CollateData
a=[P1_Span;P2_Span;P3_Span;P4_Span;P5_Span;P6_Span;P7_Span;P10_Span];
b=[P1_RateConstant;P2_RateConstant;P3_RateConstant;P4_RateConstant;P5_RateConstant;P6_RateConstant;P7_RateConstant;P10_RateConstant];
HalfLife=[P1_HalfLife;P2_HalfLife;P3_HalfLife;P4_HalfLife;P5_HalfLife;P6_HalfLife;P7_HalfLife;P10_HalfLife];
end
function [Span,RateConstant,HalfLife]=mnl_ExponentialFit(x,y,colour)
%fits a curve of the following function...a*exp(b*x)
%Inputs
%x=x values
%y=y values
%colour=colormap based matrix [chosen numebr total number]
%
%Outputs
%Span=a in the function fit
%RateConstant=b in the function fit
cmap=colormap(jet(8));

f=fit(x,y,'exp1'); %exp1 fits a curve of the following function...a*exp(b*x)NB Have not factored in a constant
coeffvals=coeffvalues(f); %coeffvals(1)=a,coeffvals(2)=b
Span=coeffvals(1);
RateConstant=coeffvals(2);
MaxX=max(x);
FitX=(0:1:MaxX)';
FitY=Span*exp(RateConstant*FitX);
plot(FitX,FitY,'color',cmap(colour,:,:),'LineWidth',2)

%Half Life
x0=(log(0.5/Span))/RateConstant;
x1=(log(0.25/Span))/RateConstant;
HalfLife=x1-x0;
end
function [Span,RateConstant,HalfLife]=mnl_STTC_FitComparissons(P1_all,P2_all,P3_all,P4_all,P5_all,P6_all,P7_all,P10_all)
% Designed to plot the  mean for the exponential fits (from y=a*e^-bx)
%% Extract Information about Span(a),RateConstant(b),and HalfLife
sz=size(P1_all);
for i=1:sz(2)
    P1.Span.Values(i)=P1_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P1.Span.Zval(i)=P1_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P1.RateConstant.Values(i)=P1_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P1.RateConstant.Zval(i)=P1_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P1.HalfLife.Values(i)=P1_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P1.HalfLife.Zval(i)=P1_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
sz=size(P2_all);
for i=1:sz(2)
    P2.Span.Values(i)=P2_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P2.Span.Zval(i)=P2_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P2.RateConstant.Values(i)=P2_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P2.RateConstant.Zval(i)=P2_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P2.HalfLife.Values(i)=P2_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P2.HalfLife.Zval(i)=P2_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
sz=size(P3_all);
for i=1:sz(2)
    P3.Span.Values(i)=P3_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P3.Span.Zval(i)=P3_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P3.RateConstant.Values(i)=P3_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P3.RateConstant.Zval(i)=P3_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P3.HalfLife.Values(i)=P3_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P3.HalfLife.Zval(i)=P3_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
sz=size(P4_all);
for i=1:sz(2)
    P4.Span.Values(i)=P4_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P4.Span.Zval(i)=P4_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P4.RateConstant.Values(i)=P4_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P4.RateConstant.Zval(i)=P4_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P4.HalfLife.Values(i)=P4_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P4.HalfLife.Zval(i)=P4_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
sz=size(P5_all);
for i=1:sz(2)
    P5.Span.Values(i)=P5_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P5.Span.Zval(i)=P5_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P5.RateConstant.Values(i)=P5_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P5.RateConstant.Zval(i)=P5_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P5.HalfLife.Values(i)=P5_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P5.HalfLife.Zval(i)=P5_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
sz=size(P6_all);
for i=1:sz(2)
    P6.Span.Values(i)=P6_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P6.Span.Zval(i)=P6_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P6.RateConstant.Values(i)=P6_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P6.RateConstant.Zval(i)=P6_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P6.HalfLife.Values(i)=P6_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P6.HalfLife.Zval(i)=P6_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
sz=size(P7_all);
for i=1:sz(2)
    P7.Span.Values(i)=P7_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P7.Span.Zval(i)=P7_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P7.RateConstant.Values(i)=P7_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P7.RateConstant.Zval(i)=P7_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P7.HalfLife.Values(i)=P7_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P7.HalfLife.Zval(i)=P7_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
sz=size(P10_all);
for i=1:sz(2)
    P10.Span.Values(i)=P10_all(i).STTC.Bootstrapped.STTCfits.SpanStats.Span;
    P10.Span.Zval(i)=P10_all(i).STTC.Bootstrapped.STTCfits.SpanStats.zval;
    
    P10.RateConstant.Values(i)=P10_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.RateConstant;
    P10.RateConstant.Zval(i)=P10_all(i).STTC.Bootstrapped.STTCfits.RateConstantStats.zval;
    
    P10.HalfLife.Values(i)=P10_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.HalfLife;
    P10.HalfLife.Zval(i)=P10_all(i).STTC.Bootstrapped.STTCfits.HalfLifeStats.zval;
end
a=[mean(P1.Span.Values),std(P1.Span.Values),size(P1.Span.Values,2);mean(P2.Span.Values),std(P2.Span.Values),size(P2.Span.Values,2);mean(P3.Span.Values),std(P3.Span.Values),size(P3.Span.Values,2);mean(P4.Span.Values),std(P4.Span.Values),size(P4.Span.Values,2);mean(P5.Span.Values),std(P5.Span.Values),size(P5.Span.Values,2);mean(P6.Span.Values),std(P6.Span.Values),size(P6.Span.Values,2);mean(P7.Span.Values),std(P7.Span.Values),size(P7.Span.Values,2);mean(P10.Span.Values),std(P10.Span.Values),size(P10.Span.Values,2)];
az=[mean(P1.Span.Zval),std(P1.Span.Zval),size(P1.Span.Zval,2);mean(P2.Span.Zval),std(P2.Span.Zval),size(P2.Span.Zval,2);mean(P3.Span.Zval),std(P3.Span.Zval),size(P3.Span.Zval,2);mean(P4.Span.Zval),std(P4.Span.Zval),size(P4.Span.Zval,2);mean(P5.Span.Zval),std(P5.Span.Zval),size(P5.Span.Zval,2);mean(P6.Span.Zval),std(P6.Span.Zval),size(P6.Span.Zval,2);mean(P7.Span.Zval),std(P7.Span.Zval),size(P7.Span.Zval,2);mean(P10.Span.Zval),std(P10.Span.Zval),size(P10.Span.Zval,2)];

b=[mean(P1.RateConstant.Values),std(P1.RateConstant.Values),size(P1.RateConstant.Values,2);mean(P2.RateConstant.Values),std(P2.RateConstant.Values),size(P2.RateConstant.Values,2);mean(P3.RateConstant.Values),std(P3.RateConstant.Values),size(P3.RateConstant.Values,2);mean(P4.RateConstant.Values),std(P4.RateConstant.Values),size(P4.RateConstant.Values,2);mean(P5.RateConstant.Values),std(P5.RateConstant.Values),size(P5.RateConstant.Values,2);mean(P6.RateConstant.Values),std(P6.RateConstant.Values),size(P6.RateConstant.Values,2);mean(P7.RateConstant.Values),std(P7.RateConstant.Values),size(P7.RateConstant.Values,2);mean(P10.RateConstant.Values),std(P10.RateConstant.Values),size(P10.RateConstant.Values,2)];
bz=[mean(P1.RateConstant.Zval),std(P1.RateConstant.Zval),size(P1.RateConstant.Zval,2);mean(P2.RateConstant.Zval),std(P2.RateConstant.Zval),size(P2.RateConstant.Zval,2);mean(P3.RateConstant.Zval),std(P3.RateConstant.Zval),size(P3.RateConstant.Zval,2);mean(P4.RateConstant.Zval),std(P4.RateConstant.Zval),size(P4.RateConstant.Zval,2);mean(P5.RateConstant.Zval),std(P5.RateConstant.Zval),size(P5.RateConstant.Zval,2);mean(P6.RateConstant.Zval),std(P6.RateConstant.Zval),size(P6.RateConstant.Zval,2);mean(P7.RateConstant.Zval),std(P7.RateConstant.Zval),size(P7.RateConstant.Zval,2);mean(P10.RateConstant.Zval),std(P10.RateConstant.Zval),size(P10.RateConstant.Zval,2)];

hl=[mean(P1.HalfLife.Values),std(P1.HalfLife.Values),size(P1.HalfLife.Values,2);mean(P2.HalfLife.Values),std(P2.HalfLife.Values),size(P2.HalfLife.Values,2);mean(P3.HalfLife.Values),std(P3.HalfLife.Values),size(P3.HalfLife.Values,2);mean(P4.HalfLife.Values),std(P4.HalfLife.Values),size(P4.HalfLife.Values,2);mean(P5.HalfLife.Values),std(P5.HalfLife.Values),size(P5.HalfLife.Values,2);mean(P6.HalfLife.Values),std(P6.HalfLife.Values),size(P6.HalfLife.Values,2);mean(P7.HalfLife.Values),std(P7.HalfLife.Values),size(P7.HalfLife.Values,2);mean(P10.HalfLife.Values),std(P10.HalfLife.Values),size(P10.HalfLife.Values,2)];
hlz=[mean(P1.HalfLife.Zval),std(P1.HalfLife.Zval),size(P1.HalfLife.Zval,2);mean(P2.HalfLife.Zval),std(P2.HalfLife.Zval),size(P2.HalfLife.Zval,2);mean(P3.HalfLife.Zval),std(P3.HalfLife.Zval),size(P3.HalfLife.Zval,2);mean(P4.HalfLife.Zval),std(P4.HalfLife.Zval),size(P4.HalfLife.Zval,2);mean(P5.HalfLife.Zval),std(P5.HalfLife.Zval),size(P5.HalfLife.Zval,2);mean(P6.HalfLife.Zval),std(P6.HalfLife.Zval),size(P6.HalfLife.Zval,2);mean(P7.HalfLife.Zval),std(P7.HalfLife.Zval),size(P7.HalfLife.Zval,2);mean(P10.HalfLife.Zval),std(P10.HalfLife.Zval),size(P10.HalfLife.Zval,2)];

Span=struct('Values',a,'Zval',az);
RateConstant=struct('Values',b,'Zval',bz);
HalfLife=struct('Values',hl,'Zval',hlz);
%% Now make figures
xlabels={'P1','P2','P3','P4','P5','P6','P7','P10'};
figure('name','Evaluating the quality of fits to bootstraped values')
%Span
subplot(3,2,1)
mnl_BarGraphs(a(:,1),a(:,2),'Span Values',xlabels)
subplot(3,2,2)
mnl_BarGraphs(az(:,1),az(:,2),'Span Values Zscores',xlabels)
%Rate Constant
subplot(3,2,3)
mnl_BarGraphs(b(:,1),b(:,2),'Rate Constant Values',xlabels)
subplot(3,2,4)
mnl_BarGraphs(bz(:,1),bz(:,2),'Rate Constant Values Zscores',xlabels)
%Half Life
subplot(3,2,5)
mnl_BarGraphs(hl(:,1),hl(:,2),'Half Life Values',xlabels)
subplot(3,2,6)
mnl_BarGraphs(hlz(:,1),hlz(:,2),'Half Life Values Zscores',xlabels)
end