function mnl_SpontaneousAnalysis2(ROIs,workspace)

% Steps
% 1) Get deltaF over F to make traces
% 2) Detect Spikes (and produce Raster Plot). And Extract individual
% glomeruli data on firing properties (i.e. frequency, amplitude, mean
% interspike interval)
% 3) Quantify Bursting, and Inter Burst Interval  (i.e. Temporal
% Patterning)
% 4) Try to look at Spacial-Temporal Patterning

% Inputs
% ROIs - Chosen Glomeruli if already done, input as empty ([]) if not done 
% workspace - name of .mat file you want saved

% Outputs
% Outputs are saved as the workspace name
%
% Created by Marcus Leiwe, Kyushu University, 2019

%% Step 1 - Load Preprocessed niftii (usually Pfsmr_xxxxx.nii)
chk=isempty(ROIs);
if chk==1
    display('Select median realigned image')
    [Data,~,Scale,name]=mnl_LoadImage;
    sz=size(Data);
    for  i=1:sz(3)
        tData(:,:,i)=(Data(:,:,i)');
    end
    Data=tData;
    [ROIs]=mnl_ManualSelectGlomeruli2(Data,Scale,name);
    save('ROIs')
end
display('Load Processed Image')
[Data,spf,scale,name]=mnl_LoadImage;
sz=size(Data);
rotData=zeros(sz(2),sz(1),sz(3));
for  i=1:sz(3)
    rotData(:,:,i)=(Data(:,:,i)'); %rotate the data if needed
end
%Data=rotData;
clear i
prompt='Select Indicator Type...GCaMP3 or GCaMP6f';
IndicatorType=input(prompt,'s');
%% Step  2 - Extract information 
[dfof,~,Tend,Tvec]=mnl_ROIread(Data,spf,ROIs,workspace);
T=Tvec;
%% Step 3 - Detect Spikes
SpikeThreshold=3;
[ROI_Spikes]=mnl_FindSpikes5(dfof,10,spf,SpikeThreshold,workspace);
mnl_MakeFreqAmpMaps(Data,ROIs,ROI_Spikes);
% ROI_Spikes is a structured array with the following components...
%   ROI_Spikes.Peaks - amplitude of peaks
%   ROI_Spikes.PeakLoc - location of the peaks in frames
%   ROI_Spikes.Onset - Onset of the Peaks
%   ROI_Spikes.Offset -  Offset of the Peaks
%   ROI_Spikes.Dur - Duration of the Peak

% Now filter out silent glomeruli
[fROIs,fROI_Spikes,fSpikes]=mnl_RemoveSilentGlom(ROIs,ROI_Spikes,T);

%% Step 4 - Quantify Temporal Patterns
HEthresh=5;
BurstTimeBin=1;
[ColBursts,ColBinBursts,Spikes,BurstBin]=mnl_BurstingAnalysis4(ROI_Spikes,T,spf,Tend,BurstTimeBin,workspace);
[HeventFreq,LeventFreq,HeventAmp,HeventAmp_Std,LeventAmp,LeventAmp_Std,HLRatio]=mnl_IndividualGroupHLevents(ColBursts,HEthresh);
%% Step 5 - Spatial Temporal Patterning
[dlag,peaknum,histpeakcor,histpeakcorstack,peakcolumn,BWjet]=SF_pairwisecorrelation(Spikes,Data,ROIs,spf);
[STTC,colourSTTC,STTC_RGB,dT]=mnl_STTCburstsAll(ROIs,Spikes,spf,scale,[-2 2],Data,workspace);
n=100; %How maany times you want to bootstrap it
[SpanStats,RateConstantStats,HalfLifeStats,BootstrapSTTC,BootstrapNumber]=mnl_BootstrapSTTC(STTC,n,workspace);
clear Data % Delete the Image to save space on the file
%% Save Workspace
save(workspace)
close all
end
%% Nested functions
function [dfof,dfof_cor,Tend,Tvec]=mnl_ROIread(data,spf,ROIs,workspace)
% Ammended ROIread1.m from SF, extracts the df over f 
% Inputs
% data - Matrix of Image (In this case Pfsmmr.... '.nii')
% spf - frame rate (in seconds per frame)
% ROIs - ROI information from mnl_ManualSelectGlomeruli
%
% Outputs
% dfof - deltaF over F
% dfof_cor - the corrected version as the AFID data is different (subtract
% 1000 then divide by 10 to get to %dfof values
% Tend - Last Time point
% Tvec - Total time of Image

close all;
% Get data information
mnz=size(data);
mImage=mnz(1);
nImage=mnz(2);
NumberImages=mnz(3);
FrameRate=spf;

% Make a Matrix file consisting of 0 or 1 for each ROI
nROI=size(ROIs,2);                                  %Number of ROIs
BW=zeros(mImage,nImage,nROI);
for i=1:nROI
    BW(:,:,i)=ROIs(i).BW;
end
BWT=sum(BW,3); %Merge the Matrix files

% Compute the average fluorescence intensity for each ROI from the dfof
% file
dfof=zeros(nROI,NumberImages);
filtered_data=double(data); %converts the image to a double if it isn't already
BW=double(BW);
for i=1:nROI
    for j=1:NumberImages
        tempvals=zeros(mImage,nImage);
        tempvals(:,:)=filtered_data(:,:,j).*BW(:,:,i); %Gives the raw values for each pixel
        dfof(i,j)=sum(sum(tempvals))/(sum(sum(BW(:,:,i)))); %Mean fluorescent value for each ROI
    end
end
dfof_cor=(dfof-1000)/10;
Tend=FrameRate*(NumberImages-1);   % Last sample time [sec]
Tvec=FrameRate*(0:NumberImages-1); % List of times

end
function [dlag,peaknum,histpeakcor,histpeakcorstack,peakcolumn,BWjet]=SF_pairwisecorrelation(peak,Data,ROIs,spf);
mnz=size(Data);
mImage=mnz(1);
nImage=mnz(2);
NumberImages=mnz(3);
FrameRate=spf;
nROIs=size(ROIs,2);
%Specify BW
BW=zeros(mImage, nImage, nROIs);
for i=1:nROIs
    BW(:,:,i)=ROIs(i).BW;
end
BWT=sum(BW,3);

% ‘ŠŠÖ‰ð?Í‚Ì‚½‚ß‚Ìƒs?[ƒN‚ÌŠî?€’l‚ð?Ý’è
Twid=2.5; %Number of Seconds for the window
wid=ceil(Twid/FrameRate); %Number of Frames for window
peaknum=zeros(1,size(peak,1)); % peaknum will become the number of peaks in each ROI/glomerulus
for zz=1:size(peak,1)
        peaknum(1,zz)=sum(peak(zz,:)); %zz”Ô–Ú‚ÌROI‚Ìpeak‚Ì?”
end
[C,ind]=max(peaknum);  %Which ROI fires the most
stdpeak=zeros(zz,C);  %stdpeak - time location of each peak
for zz=1:size(peak,1)
    if length(find(peak(zz,:))) <= C
        stdpeak(zz,:) = cat(2,find(peak(zz,:)),zeros(1,C-length(find(peak(zz,:)))));
    end
end

peakcolumn=zeros(size(peak,1),wid*2+1); % peakcolumn 


c=C;
for b=1:size(peak,1)
    for c=1:C
        if stdpeak(b,c)-wid <= 0
            peakcolumn(:,:,b,c)=zeros(size(peak,1),wid*2+1);
        elseif stdpeak(b,c)+wid > size(peak,2)
            peakcolumn(:,:,b,c)=zeros(size(peak,1),wid*2+1);
        else
            peakcolumn(:,:,b,c)=peak(:,stdpeak(b,c)-wid:stdpeak(b,c)+wid); % peakccolumn isolates each window of "10" frames
        end
    end
end

% CŒÂ‚ÌƒEƒCƒ“ƒhƒE‚ð?d‚Ë?‡‚í‚¹
peakcolumnstack=sum(peakcolumn,4);

% ƒqƒXƒgƒOƒ‰ƒ€?ì?¬
histpeakcor=permute(peakcolumnstack,[2 1 3]);
for b=1:size(peak,1)
    histpeakcorstack(:,:,b)=histpeakcor(:,:,b)./peaknum(1,b);    
end
% ?d‚¢‚Æ‚« (‚Ð‚Æ‚Â‚¸‚ÂƒOƒ‰ƒt?¶?¬)
figure;
b=4; %ROI that fires the most
for a=1:size(peak,1)
    subplot(ceil(((size(peak,1)))/5),5,a)
    bar(histpeakcorstack(:,a,b))
    hold on
    y1 = 0:1;
    x1 = wid * ones(size(y1));
    plot(x1, y1,'Color','r','LineStyle',':');
    hold off
    axis([0 wid*2+1 0 1])
    set(gca,'FontSize',5)
end

% ‚Ü‚Æ‚ß‚Ä?o—Í(ŽžŠÔ‚©‚©‚é?j
%     figure;
% for b=1:size(peak,1)
%     for a=1:size(peak,1)
%     subplot(zz,zz,zz*(b-1)+a)
%             bar(histpeakcorstack(:,a,b))
%             hold on
%             y1 = 0:1;
%             x1 = wid+1 * ones(size(y1));
%             plot(x1, y1,'Color','r','LineStyle',':');
%             hold off
%             axis([0,wid*2+1,0,0.065])
%             set(gca,'FontSize',5)
%     end
% end
%%
% ‘ŠŒÝ‘ŠŠÖ‚ÌŒvŽZ
dlag=zeros(nROIs,nROIs^2);
xC_all=zeros(nROIs,nROIs^2);
for b=1:nROIs
    [xC,Tlags] = xcorr(histpeakcor(:,:,b),'coeff');
    [xC_C,xC_ind]=max(xC,[],1);
    dlag(b,:)=xC_ind-(wid*2+1);
    xC_all(b,:)=xC_C;
end

    dlag_mat_mod=reshape(dlag,nROIs,nROIs,nROIs);
    xC_C_mat=reshape(xC_all,nROIs,nROIs,nROIs);
    dlag_mat=dlag_mat_mod;

% ‚»‚ê‚¼‚ê‚ÌROI‚Å‘©‚Ë‚½‚Æ‚«‚Ìƒ‰ƒO‚Æ‘ŠŠÖŒW?”‚Ì?s—ñ?ì?¬
dlag_mat_tot=zeros(nROIs);
xC_C_tot=zeros(nROIs);
for b=1:nROIs
dlag_mat_tot(b,:)=dlag_mat(b,:,b);
xC_C_tot(b,:)=xC_C_mat(b,:,b);
end

%Glomerular heatmap‚Ì?ì?¬ corr based
ROIBWT=sum(BW,3);   
BWjet=zeros(mImage, nImage, 3,nROIs);
Data2=Data; %ŽžŠÔ•½‹Ï‰æ‘œ‚Ì“Ç‚Ý?ž‚Ý
k=0.5; %threshould of xC_C_tot

cmap_xcor=[0 0 1;
            0.2 0.2 1;
            0.4 0.4 1;
            0.6 0.6 1;
            0.8 0.8 1;
            1 1 1;
            1 0.8 0.8;
            1 0.6 0.6;
            1 0.4 0.4;
            1 0.2 0.2;
            1 0 0];
         Latency_RGB=zeros(nROIs,3,b);
        %%
        k=0.5;
for b=1:nROIs    
    for r=1:nROIs 
        if (dlag_mat_tot(b,r) <= -5.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1)
            Latency_RGB(r,:,b) = [1 0 0];
        elseif (-4.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= -3.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [1 0.2 0.2];    
        elseif (-3.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= -2.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [1 0.4 0.4];         
        elseif (-2.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= -1.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [1 0.6 0.6];
        elseif (-1.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= -0.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [1 0.8 0.8];
        elseif (-0.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= 0.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [1 1 1];    
        elseif (0.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= 1.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [0.8 0.8 1];
        elseif (1.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= 2.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [0.6 0.6 1];
        elseif (2.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= 3.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [0.4 0.4 1];
        elseif (3.5 < dlag_mat_tot(b,r)) && (dlag_mat_tot(b,r) <= 4.5) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1) 
            Latency_RGB(r,:,b) = [0.2 0.2 1];
        elseif 4.5 < dlag_mat_tot(b,r) && (xC_C_tot(b,r) >= k) && (xC_C_tot(b,r) <1)
            Latency_RGB(r,:,b) = [0 0 1];
        elseif xC_C_tot(b,r) < k
            Latency_RGB(r,:,b) = [0 0 0];
        elseif (xC_C_tot(b,r) >= 1) && (dlag_mat_tot(b,r)==0)
            Latency_RGB(r,:,b) = [1 1 0];
        end
    end
end

%%

ROIRGB=zeros(nROIs,3,b);  %ŠeROI‚ÌRGB•\‹L‚ÌƒJƒ‰?[
for b=1:nROIs
    for r=1:nROIs
        ROIRGB(r,:,b)=Latency_RGB(r,:,b);        %ˆÊ‘Š‚ð?F‚É”½‰f‚³‚¹‚Ä?A?U•?‚ð”Z’W‚Å•\Œ»‚·‚é
    end
end

for b=1:nROIs
    for r=1:nROIs
        for j=1:3
            BWjet(:,:,j,b)=BWjet(:,:,j,b)+ROIRGB(r,j,b)*BW(:,:,r);
            if BWjet(:,:,j,b)>1
                BWjet(:,:,j,b)=1; % Added in code to make the mask work (test)
            end
        end
    end
end
%% To remove any overlap
[a,loc]=max(BWjet(:));
if a>1
    a2=size(BWjet);
    for  t1=1:a2(1)
        for t2=1:a2(2)
            for t3=1:a2(3)
                for t4=1:a2(4)
                    if BWjet(t1,t2,t3,t4)>1
                        BWjet(t1,t2,t3,t4)=1;
                    end
                end
            end
        end
    end
end

%%
%ˆÊ‘ŠƒJƒ‰?[ƒR?[ƒh‚ð‚Ü‚Æ‚ß‚Ä•\Ž¦
figure
axis tight
for b=1:nROIs
    subplot(ceil((nROIs+1)/5),5,b)
    image(BWjet(:,:,:,b))
    hold all
%    contour(ROIBWT,1,'Color','w','Linewidth',2)
    set(gca,'xticklabel',[])
    axis off;
    hold off
end
subplot(ceil((nROIs+1)/5),5,(nROIs+1))
%colorbar‚Ì?ì?¬
latecorbar=reshape(cmap_xcor,1,11,3);
image(latecorbar);
xlabel('Latency (s)')
xlim([1 11])
set(gca,'XTick',[linspace(1,11,5)])
set(gca,'XTickLabel',{num2str(Twid*-1),num2str(Twid*-0.5),'0',num2str(Twid*0.5),num2str(Twid)})
set(gca,'YTickLabel',{})
hold off
savefig('Glomerular Temporal Relationship')
end