function mnl_CollateAllSpontData(Age)
%% Collates all data for an age group
prompt='Please input the age of the mice in numbers only';
NumAge=input(prompt,'s');
[Wkspaces]=uipickfiles;
sz=size(Wkspaces);
fn=Age;
fn2=sprintf('%s%s',Age,'_all');
for i=1:sz(2)
    tempI=i;
    load(Wkspaces{1,i});
    i=tempI;
    %% Basic Information
    AgeGroup(i).BasicInfo.FileName=Wkspaces{1,i};
    AgeGroup(i).BasicInfo.Age=NumAge;
    chk=exist('IndicatorType','var');
    if chk==1
        AgeGroup(i).BasicInfo.IndicatorType=IndicatorType;
    else
        prompttext=sprintf('%s%s','Please Input the type of Indicator used in...',Wkspaces{1,i});
        prompt=prompttext;
        str=input(prompt,'s');
        AgeGroup(i).BasicInfo.IndicatorType=str;
    end
    %AgeGroup(i).BasicInfo.Data=Data;
    %Animal ID
    AgeGroup(i).BasicInfo.Scale=scale;
    AgeGroup(i).BasicInfo.FrameRate=spf;
    AgeGroup(i).BasicInfo.MovieLength=Tend;
    %% Glomerular Data
    AgeGroup(i).GlomerularData.ROIs=ROIs;
    AgeGroup(i).GlomerularData.ROI_Spikes=ROI_Spikes;
    AgeGroup(i).GlomerularData.fROIs=fROIs;
    AgeGroup(i).GlomerularData.fROI_Spikes=fROI_Spikes;
    AgeGroup(i).GlomerularData.Spikes=Spikes;
    AgeGroup(i).GlomerularData.fSpikes=fSpikes;
    AgeGroup(i).GlomerularData.SpikeThreshold=SpikeThreshold;
    AgeGroup(i).GlomerularData.dfof=dfof;
    %AgeGroup(i).GlomerularData.dfof_cor=dfof_cor;
    %% Burst Data
    AgeGroup(i).BurstData.ColBursts=ColBursts;
    AgeGroup(i).BurstData.ColBinBursts=ColBinBursts;
    AgeGroup(i).BurstData.HEthresh=HEthresh;
    %% STTC Data
    AgeGroup(i).STTC.SimpleSTTC.STTC=STTC;
    AgeGroup(i).STTC.SimpleSTTC.colourSTTC=colourSTTC;
    AgeGroup(i).STTC.SimpleSTTC.STTC_RGB=STTC_RGB;
    AgeGroup(i).STTC.SimpleSTTC.deltaT=dT;
    
    AgeGroup(i).STTC.Bootstrapped.BootstrapNumber=BootstrapNumber;
    AgeGroup(i).STTC.Bootstrapped.BootstrapSTTC=BootstrapSTTC;
    AgeGroup(i).STTC.Bootstrapped.STTCfits.RateConstantStats=RateConstantStats;
    AgeGroup(i).STTC.Bootstrapped.STTCfits.SpanStats=SpanStats;
    AgeGroup(i).STTC.Bootstrapped.STTCfits.HalfLifeStats=HalfLifeStats;    
    %AgeGroup(i).STTC.STTC_Bursts_TemporalComponents=STTC_Bursts_TemporalComponents;
end
str = [fn2,' = AgeGroup;'];
eval(str);
save(fn,fn2,'-v7.3')