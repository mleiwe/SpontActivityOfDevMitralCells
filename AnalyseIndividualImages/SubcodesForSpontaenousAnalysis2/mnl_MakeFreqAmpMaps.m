function []=mnl_MakeFreqAmpMaps(Data,ROIs,ROI_Spikes)
mnz=size(Data);
mImage=mnz(1);
nImage=mnz(2);
nROIs=size(ROIs,2);
cmap=colormap(jet(256));
cmap(1,:,:)=0;
AmpImage=zeros(mImage,nImage);
FreqImage=zeros(mImage,nImage);
%Allocate Scores
for i=1:nROIs
    for i2=1:mImage
        for i3=1:nImage
            if  ROIs(i).BW(i2,i3)==1
                AmpImage(i2,i3)=(mean(ROI_Spikes(i).Peaks(:))-1000)/10; %into dfof
                FreqImage(i2,i3)=mean(ROI_Spikes(i).Frequency*60); %Into Events per minute
            end
        end
    end
end
figure('Name','AmplitudeDistribution')
imagesc(AmpImage)
set(gca, 'CLim', [0,100]);
mnl_ScaleBar(1.988,100,'northeast','100 \mum');
colorbar
figure('Name','FrequencyDistribution')
imagesc(FreqImage)
set(gca, 'CLim', [0,8]);
mnl_ScaleBar(1.988,100,'northeast','100 \mum');
colorbar
end