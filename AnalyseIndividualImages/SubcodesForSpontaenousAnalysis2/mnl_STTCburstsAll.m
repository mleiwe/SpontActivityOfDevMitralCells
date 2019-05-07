function [STTC,colourSTTC,STTC_RGB,dT]=mnl_STTCburstsAll(ROIs,Spikes,spf,scale,dT,data,workspace)
% Function to calculate the STTC (Spike Time Tiling Coefficient)and check
% the correlation with the distance between glomeruli. Same as
% mnl_STTCbursts but builds up a redundancy by comparing each glomeruli
% twice. 
%
% Inputs
% ROIs - Data Regarding the Location of Glomeruli
% Spikes - Binarised Temporal Location of the Spikes (rows-glomueruli,
% columns-timepoints)
% spf - frame rate
% scale - scale of image
% dT - time window to count as synchronous activity (in seconds)
% data - the raw data
%
% Outputs
% STTC - n*2 matrix, column one is STTC and column two is the distance
% between the glomeruli
%
% Created by Marcus Leiwe at CDB RIKEN Nov 2014

sz=size(Spikes);
nROIs=sz(1);
nFrames=sz(2);
STTC=zeros(((sz(1)-1)/2)*sz(1),2);  %Creates a STTC matrix of zeros to fill
colourSTTC=zeros(nROIs,nROIs);
SdeltaT=round(dT(1)/spf);
EdeltaT=round(dT(2)/spf);

o=1; %STTC counter
for i=1:nROIs
    %% Calculate the Window for A(i)
    Awin=[];
    ASpkLocs=[];
    n=1;
    ASpkLocs=find(Spikes(i,:));
    sz2=size(ASpkLocs);
    i3=1;
    while i3<=sz2(2)
        %% Calculate the start
        if i3==1
            tempStart=ASpkLocs(i3)+SdeltaT;
            if tempStart<=0
                tempStart=1;
            end
        elseif ASpkLocs(i3-1)+EdeltaT<ASpkLocs(i3)+SdeltaT
            tempStart=ASpkLocs(i3)+SdeltaT;
        elseif ASpkLocs(i3-1)+EdeltaT>=ASpkLocs(i3)+SdeltaT
            i4=i3-1; %Create a while loop to find the true end of the burst
            while i4>0
                if i4==1
                    tempStart=ASpkLocs(i4)+SdeltaT;
                    i4=0;
                elseif ASpkLocs(i4-1)+EdeltaT<ASpkLocs(i4)+SdeltaT
                    tempStart=ASpkLocs(i4)+SdeltaT;
                    i4=0;
                elseif ASpkLocs(i4-1)+EdeltaT>ASpkLocs(i4)+SdeltaT
                    i4=i4-1;
                end
            end
        end
        %% Calculate the end
        if i3<=sz2(2) %if the spike location is the last one  or lower
            %Is there another spike?
            if i3==sz2(2)%If i3 is the last spike
                tempEnd=ASpkLocs(i3)+EdeltaT;
                if tempEnd>nFrames
                    tempEnd=nFrames;
                end
                i3=i3+1;
            elseif ASpkLocs(i3)+EdeltaT<ASpkLocs(i3+1)+SdeltaT %if the gap to the next one is big enough
                tempEnd=ASpkLocs(i3)+EdeltaT;
                if tempEnd>nFrames
                    tempEnd=nFrames;
                end
                i3=i3+1;
            elseif ASpkLocs(i3)+EdeltaT>=ASpkLocs(i3+1)+SdeltaT % if the gap is smaller
                i4=i3+1; %move to the next spike
                while i4<sz(2) %sz(2)-nFrames is a threshold value to count
                    if i4>=sz2(2) %if i4 is the last one
                        tempEnd=ASpkLocs(i4)+EdeltaT;
                        if tempEnd>nFrames
                            tempEnd=nFrames;
                        end
                        i3=i3+nFrames;
                        i4=nFrames+1;
                    elseif  ASpkLocs(i4)+EdeltaT<ASpkLocs(i4+1)+SdeltaT
                        tempEnd=ASpkLocs(i4)+EdeltaT;
                        if tempEnd>nFrames
                            tempEnd=nFrames;
                        end
                        i3=i4+1;
                        i4=nFrames;
                    elseif ASpkLocs(i4)+EdeltaT>=ASpkLocs(i4+1)+SdeltaT
                        i4=i4+1;
                    end
                end
            else
                tempEnd=ASpkLocs(i3)+EdeltaT;
            end
        end        
        Awin(n,:)=[tempStart tempEnd];
        n=n+1;
    end
    %% Now Record the Window and work out tA
    sz1=size(Awin);
    sumA=0;
    for t=1:sz1(1)
        x=Awin(t,2)-Awin(t,1);
        sumA=sumA+x;
    end
    tA=sumA/nFrames;
    
    %% Now do the same for B(calculate tB)
    for i2=1:nROIs
        Bwin=[];
        BSpkLocs=[];
        m=1;
        BSpkLocs=find(Spikes(i2,:));
        sz2=size(BSpkLocs);
        i5=1;
        while i5<=sz2(2)
            %% Calculate the start
            if i5==1
                tempStart=BSpkLocs(i5)+SdeltaT;
                if tempStart<=0
                    tempStart=1;
                end
            elseif BSpkLocs(i5-1)+EdeltaT<BSpkLocs(i5)+SdeltaT
                tempStart=BSpkLocs(i5)+SdeltaT;
            elseif BSpkLocs(i5-1)+EdeltaT>=BSpkLocs(i5)+SdeltaT %if the previous spike is closer than the threshold
                i6=i5-1; %Create a while loop to find the true start of the burst
                while i6>0
                    if i6-1<=0 %If i6 is the first one
                        tempStart=BSpkLocs(1)+SdeltaT;
                        if tempStart<=0
                            tempStart=1;
                        end
                        i6=0;
                    elseif BSpkLocs(i6-1)+EdeltaT<BSpkLocs(i6)+SdeltaT%if the gap is big enough
                        tempStart=BSpkLocs(i6)+SdeltaT;
                        i6=0;
                    elseif BSpkLocs(i6-1)+EdeltaT>=BSpkLocs(i6)+SdeltaT % If it isnt big enough
                        i6=i6-1;
                    end
                end
            end
            %% Calculate the end
            if i5<=sz2(2) %if the spike location is the last one  or lower
                %Is there another spike?
                if i5==sz2(2)%If i5 is the last spike
                    tempEnd=BSpkLocs(i5)+EdeltaT;
                    if tempEnd>nFrames
                        tempEnd=nFrames;
                    end
                    i5=i5+1;
                elseif BSpkLocs(i5)+EdeltaT<BSpkLocs(i5+1)+SdeltaT %if the gap to the next one is big enough
                    tempEnd=BSpkLocs(i5)+EdeltaT;
                    if tempEnd>nFrames
                        tempEnd=nFrames;
                    end
                    i5=i5+1;
                elseif BSpkLocs(i5)+EdeltaT>=BSpkLocs(i5+1)+SdeltaT % if the gap is smaller
                    i6=i5+1; %move to the next spike
                    while i6<sz(2) %sz(2)-nFrames is a threshold value to count
                        if i6>=sz2(2) %if i6 is the last one
                            tempEnd=BSpkLocs(i6)+EdeltaT;
                            if tempEnd>nFrames
                                tempEnd=nFrames;
                            end
                            i5=i5+nFrames;
                            i6=nFrames+1;
                        elseif BSpkLocs(i6)+EdeltaT<BSpkLocs(i6+1)+SdeltaT
                            tempEnd=BSpkLocs(i6)+EdeltaT;
                            if tempEnd>nFrames
                                tempEnd=nFrames;
                            end
                            i5=i6+1;
                            i6=nFrames;
                        elseif BSpkLocs(i6)+EdeltaT>=BSpkLocs(i6+1)+SdeltaT
                            i6=i6+1;
                        end
                    end
                else
                    tempEnd=BSpkLocs(i5)+deltaT;
                end
            end
            %% Now Record the Window and work out tA
            Bwin(m,:)=[tempStart tempEnd];
            m=m+1;
        end
        sz1=size(Bwin);
        sumB=0;
        for t=1:sz1(1)
            x=Bwin(t,2)-Bwin(t,1);
            sumB=sumB+x;
        end
        tB=sumB/nFrames;
        %% Calculate pA and pB
        % For B spikes within the A time windows
        sz1=size(Awin);
        spkB=0;
        for i3=1:sz1(1)
            tempB=sum(Spikes(i2,Awin(i3,1):Awin(i3,2)));
            spkB=spkB+tempB;
        end
        totB=sum(Spikes(i2,:));
        pB=spkB/totB;
        
        % For A spikes within the B time windows
        sz2=size(Bwin);
        spkA=0;
        for i3=1:sz2(1)
            tempA=sum(Spikes(i,Bwin(i3,1):Bwin(i3,2)));
            spkA=spkA+tempA;
        end
        totA=sum(Spikes(i,:));
        pA=spkA/totA;
        
        %% Now we can work out STTC
        Avals=(pA-tB)/(1-(pA*tB));
        Bvals=(pB-tA)/(1-(pB*tA));
        score=0.5*(Avals+Bvals);
        if isnan(score)==0
            STTC(o,1)=score;
            colourSTTC(i,i2)=score;
        else
            STTC(o,1)=0;
            colourSTTC(i,i2)=0;
        end
        %% Distance between A and B
        [centAx,centAy,~,~]=mnl_FindGlomCentre(ROIs(i).xi,ROIs(i).yi);
        [centBx,centBy,~,~]=mnl_FindGlomCentre(ROIs(i2).xi,ROIs(i2).yi);
        posA=[centAx centAy];
        posB=[centBx centBy];
        distX=(posB(1)-posA(1));
        distY=(posB(2)-posA(2));
        distXY=((distX^2)+(distY^2))^0.5;
        STTC(o,2)=distXY*scale;
        o=o+1;
    end
end
%% Plot the Correlation curve
%Remove Correlations between same Glom
sz=size(STTC);
counter=1;
for i=1:sz(1)
    if STTC(i,2)~=0
        newSTTC(counter,:)=STTC(i,:);
        counter=counter+1;
    end
end    

bin=round((counter-1)/20); %Specifies bins at every 5th perccentile
[Vall_bin,Vall_sem_bin,Vall_std_bin] = mnl_BinInputs(newSTTC(:,2),newSTTC(:,1),bin);
figure,
plot(newSTTC(:,2),newSTTC(:,1),'.k')
hold on
errorbar(Vall_bin(:,1),Vall_bin(:,2),Vall_std_bin(:,2),'.-r')
mnl_ExponentialFit(newSTTC(:,2),newSTTC(:,1),'b');
xlabel('Distance (um)')
ylabel('STTC')
savefig('STTC')

%% Heat Map
%Part One as a Correlation Matrix
figure,
imagesc(colourSTTC)
%Part 2 as a Map of Glomeruli Locations
[STTC_RGB]=mnl_ROImaps(ROIs,colourSTTC,data,colourSTTC);
%% Write to Excel File
Distance=STTC(:,2);
STTCscore=STTC(:,1);
T=table(Distance,STTCscore);

filename = sprintf('%s%s',workspace,'.xlsx');
writetable(T,filename,'Sheet','STTC Scores');
end
%% Nested Functions
function []=mnl_CheckWindows(i,Spikes,Awin)
figure,
plot(Spikes(i,:))
hold on
sz3=size(Awin);
cmap=colormap(jet(sz3(1)));
for i5=1:sz3(1)
    x=Awin(i5,:);
    plot(x,[-0.01*i5 -0.01*i5],'-','LineWidth',5,'Color',cmap(i5,:,:))
end
ylim([-1 1])
end
function [STTC_RGB]=mnl_ROImaps(ROIs,values,data,colourSTTC)
mnz=size(data);
mImage=mnz(2);
nImage=mnz(1);
nROIs=size(ROIs,2);
%Create the Colour map
STTC_RGB=zeros(nImage, mImage, nROIs);
for i=1:nROIs
    for i2=1:nROIs
        sz=size(ROIs(i2).BW);
        for x=1:sz(1)
            for y=1:sz(2)
                if ROIs(i2).BW(x,y)==1
                    if colourSTTC(i,i2)>=0 && colourSTTC(i,i2)<=1
                    STTC_RGB(x,y,i)=colourSTTC(i,i2);
                    elseif colourSTTC(i,i2)<0
                        STTC_RGB(x,y,i)=0;
                    elseif colourSTTC(i,i2)>=1
                        STTC_RGB(x,y,i)=1;
                    end
                end
            end
        end
    end
end

cmap_STTC=colormap(jet(100));
cmap_STTC(1,:)=zeros(1,3);
STTC_RGB=(STTC_RGB)*100;
figure,
for b=1:nROIs
    subplot(ceil((nROIs+1)/5),5,b)
    image(STTC_RGB(:,:,b))
    axis off
end
colormap(cmap_STTC)
lateral_colourbar=reshape(cmap_STTC,1,100,3);
image(lateral_colourbar);
set(gca,'YTickLabel',[]);
set(gca,'XTick',[0 20 40 60 80 100]);
set(gca,'XTickLabel',[0 0.20 0.40 0.60 0.80 1.00]);
xlabel('STTC Score')
savefig('STTC Maps')
end
function [Span,RateConstant]=mnl_ExponentialFit(x,y,colour)
%fits a curve of the following function...a*exp(b*x)
%Inputs
%x=x values
%y=y values
%colour=string based colour code
%
%Outputs
%Span=a in the function fit
%RateConstant=b in the function fit


%f=fit(x,y,'exp1'); %exp1 fits a curve of the following function...a*exp(b*x)NB Have not factored in a constant
%coeffvals=coeffvalues(f); %coeffvals(1)=a,coeffvals(2)=b
%Span=coeffvals(1);
%RateConstant=coeffvals(2);
[k,yInf,y0,~]=fitExponential(x,y);
Span=yInf+(y0-yInf);
RateConstant=k;
MaxX=max(x);
FitX=(0:1:MaxX)';
%FitY=Span*exp(RateConstant*FitX);
FitY=yInf+(y0-yInf)*exp(-k*(FitX-FitX(1)));
plot(FitX,FitY,colour,'LineWidth',2)
end
