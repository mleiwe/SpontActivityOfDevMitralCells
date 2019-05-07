function [fROIs,fROI_Spikes,fSpikes]=mnl_RemoveSilentGlom(ROIs,ROI_Spikes,T);

sz=size(ROI_Spikes);
counter=1;
for i=1:sz(2)
    NoPeaks=isempty(ROI_Spikes(i).Peaks);
    if NoPeaks==0
        fROIs(counter).x=ROIs(i).x;
        fROIs(counter).y=ROIs(i).y;
        fROIs(counter).BW=ROIs(i).BW;
        fROIs(counter).xi=ROIs(i).xi;
        fROIs(counter).yi=ROIs(i).yi;
        
        fROI_Spikes(counter).Peaks=ROI_Spikes(i).Peaks;
        fROI_Spikes(counter).PeakLoc=ROI_Spikes(i).PeakLoc;
        fROI_Spikes(counter).Onset=ROI_Spikes(i).Onset;
        fROI_Spikes(counter).Offset=ROI_Spikes(i).Offset;
        fROI_Spikes(counter).Duration=ROI_Spikes(i).Duration;
        fROI_Spikes(counter).Frequency=ROI_Spikes(i).Frequency;
        fROI_Spikes(counter).AdaptiveThresh=ROI_Spikes(i).AdaptiveThresh;
        fROI_Spikes(counter).Baseline=ROI_Spikes(i).Baseline;
        
        counter=counter+1;
    end
end

sz=size(fROI_Spikes);
sz2=size(T);
fSpikes=zeros(sz(2),sz2(2));
for i=1:sz(2) %for each ROI
    for j=1:sz2(2) %for each timepoint
        sz3=size(fROI_Spikes(i).PeakLoc); %for each spike
        for k=1:sz3(2)
            if fROI_Spikes(i).PeakLoc(k)==j
                fSpikes(i,j)=1;
            end
        end
    end
end
