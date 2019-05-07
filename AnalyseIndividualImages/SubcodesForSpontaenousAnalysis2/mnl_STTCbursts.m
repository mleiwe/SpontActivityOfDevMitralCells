function [STTC]=mnl_STTCbursts(ROIs,Spikes,spf,scale,dT)
% Function to calculate the STTC (Spike Time Tiling Coefficient)and check
% the correlation with the distance between glomeruli. Based on the paper
% from Cutts and Eglen (2014) - http://www.jneurosci.org/content/34/43/14288.long
%
% Inputs
% ROIs - Data Regarding the Location of Glomeruli
% Spikes - Binarised Temporal Location of the Spikes (rows-glomueruli,
% columns-timepoints)
% spf - frame rate
% scale - scale of image
% dT - time window to count as synchronous activity (in seconds)
%
% Outputs
% STTC - n*2 matrix, column one is STTC and column two is the distance
% between the glomeruli
%
% Created by Marcus Leiwe at CDB RIKEN Nov 2014

sz=size(Spikes);
nROIs=sz(1);
nFrames=sz(2);
%STTC=zeros(((sz(1)-1)/2)*sz(1),2);  %Creates a STTC matrix of zeros to fill
deltaT=round((dT/spf)/2); % Calculates time window in number of frames

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
        %Check to see any overlap
        WinStart=i3-deltaT;
        WinEnd=i3+(deltaT*2)-1; %deltaT*2 to avoid overlap on the following burst
        %% Calculate the start
        if i3==1
            tempStart=ASpkLocs(i3)-deltaT;
            if tempStart<=0
                tempStart=1;
            end
        elseif ASpkLocs(i3)-ASpkLocs(i3-1)>(deltaT*2)+1
            tempStart=ASpkLocs(i3)-deltaT;
        elseif ASpkLocs(i3)-ASpkLocs(i3-1)<=(deltaT*2)+1
            i4=i3-1; %Create a while loop to find the true end of the burst
            while i4>0
                if ASpkLocs(i4)-ASpkLocs(i4-1)>(deltaT*2)+1
                    tempStart=ASpkLocs(i4)-deltaT;
                    i4=0;
                elseif ASpkLocs(i4)-ASpkLocs(i4-1)<=(deltaT*2)+1
                    i4=i4-1;
                end
            end
        end
        %% Calculate the end
        if i3>=sz2(2) %if the spike location is the last one
            tempEnd=ASpkLocs(i3)+deltaT;
            if tempEnd>nFrames
                tempEnd=nFrames;
            end
            i3=i3+1;
        elseif ASpkLocs(i3+1)-ASpkLocs(i3)>(deltaT*2)+1 %if the gap to the next one is big enough
            tempEnd=ASpkLocs(i3)+deltaT;
            if tempEnd>nFrames
                tempEnd=nFrames;
            end
            i3=i3+1;
        elseif ASpkLocs(i3+1)-ASpkLocs(i3)<=(deltaT*2)+1 % if the gap is smaller
            i4=i3+1; %move to the next spike
            while i4<sz(2) %sz(2)-nFrames is a thresh value to count
                if i4>=sz2(2) %if i4 is the last one
                    tempEnd=ASpkLocs(i4)+deltaT;
                    if tempEnd>nFrames
                        tempEnd=nFrames;
                    end
                    i3=i3+nFrames;
                    i4=nFrames+1;
                    
                elseif ASpkLocs(i4+1)-ASpkLocs(i4)>(deltaT*2)+1
                    tempEnd=ASpkLocs(i4)+deltaT;
                    if tempEnd>nFrames
                        tempEnd=nFrames;
                    end
                    i3=i4+1;
                    i4=nFrames;
                elseif ASpkLocs(i4+1)-ASpkLocs(i4)<=(deltaT*2)+1
                    i4=i4+1;
                end
            end
        end
        %% Now Record the Window and work out tA
        Awin(n,:)=[tempStart tempEnd];
        n=n+1;
    end
    sz1=size(Awin);
    sumA=0;
    for t=1:sz1(1)
        x=Awin(t,2)-Awin(t,1);
        sumA=sumA+x;
    end
    tA=sumA/nFrames;
    
    %% Check To see if windowing works
    %mnl_CheckWindows(i,Spikes,Awin)
    
    %% Now do the same for B(calculate tB)
    for i2=(i+1):nROIs
        Bwin=[];
        BSpkLocs=[];
        m=1;
        BSpkLocs=find(Spikes(i2,:));
        sz2=size(BSpkLocs);
        i3=1;
        while i3<=sz2(2)
            %Check to see any overlap
            WinStart=i3-deltaT;
            WinEnd=i3+(deltaT*2)-1; %deltaT*2 to avoid overlap on the following burst
            %% Calculate the start
            if i3==1
                tempStart=BSpkLocs(i3)-deltaT;
                if tempStart<=0
                    tempStart=1;
                end
            elseif BSpkLocs(i3)-BSpkLocs(i3-1)>(deltaT*2)+1
                tempStart=BSpkLocs(i3)-deltaT;
            elseif BSpkLocs(i3)-BSpkLocs(i3-1)<=(deltaT*2)+1 %if the previous spike is closer than the threshold
                i4=i3-1; %Create a while loop to find the true end of the burst
                while i4>0
                    if i4-1<=0
                        tempStart=BSpkLocs(1)-deltaT;
                        if tempStart<=0
                            tempStart=1;
                        end
                        i4=0;
                    elseif BSpkLocs(i4)-BSpkLocs(i4-1)>(deltaT*2)+1
                        tempStart=BSpkLocs(i4)-deltaT;
                        i4=0;
                    elseif BSpkLocs(i4)-BSpkLocs(i4-1)<=(deltaT*2)+1
                        i4=i4-1;
                    end
                end
            end
            %% Calculate the end
            if i3>=sz2(2) % If it is the last one
                tempEnd=BSpkLocs(i3)+deltaT;
                if tempEnd>nFrames
                    tempEnd=nFrames;
                end
                i3=i3+1;
            elseif BSpkLocs(i3+1)-BSpkLocs(i3)>(deltaT*2)+1 %If the next one is far enough away
                tempEnd=BSpkLocs(i3)+deltaT;
                if tempEnd>nFrames
                    tempEnd=nFrames;
                end
                i3=i3+1;
            elseif BSpkLocs(i3+1)-BSpkLocs(i3)<=(deltaT*2)+1 %If the gap is smaller
                i4=i3+1; %Move to the next spike
                while i4<sz(2)%sz(2)-nFrames here is used as a overly high number
                    if i4>=sz2(2) %if i4 is bigger or equal to the number of spike
                        tempEnd=BSpkLocs(i4)+deltaT; 
                        if tempEnd>nFrames
                            tempEnd=nFrames;
                        end
                        i4=nFrames+1;
                        i3=i3+n;
                    elseif BSpkLocs(i4+1)-BSpkLocs(i4)>(deltaT*2)+1
                        tempEnd=BSpkLocs(i4)+deltaT;
                        if tempEnd>nFrames
                            tempEnd=nFrames;
                        end
                        i3=i4+1;
                        i4=nFrames;
                    elseif BSpkLocs(i4+1)-BSpkLocs(i4)<=(deltaT*2)+1
                        i4=i4+1;
                    end
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
        %mnl_CheckWindows(i2,Spikes,Bwin)
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
            if  i==1  && i2==2 &&i3==19
                chk=1;
            end
            tempA=sum(Spikes(i,Bwin(i3,1):Bwin(i3,2)));
            spkA=spkA+tempA;
        end
        totA=sum(Spikes(i,:));
        pA=spkA/totA;
        
        %% Now we can work out STTC
        Avals=(pA-tB)/(1-(pA*tB));
        Bvals=(pB-tA)/(1-(pB*tA));
        STTC(o,1)=0.5*(Avals+Bvals);
        
        
        %% Distance between A and B
        [geomA,~,~]=polygeom(ROIs(i).xi,ROIs(i).yi);
        [geomB,~,~]=polygeom(ROIs(i2).xi,ROIs(i2).yi);
        posA=[geomA(2) geomA(3)];
        posB=[geomB(2) geomB(3)];
        distX=(posB(1)-posA(1))^2;
        distY=(posB(2)-posA(2))^2;
        distXY=(distX+distY)^0.5;
        
        STTC(o,2)=distXY*scale;
        o=o+1;
        Bwin=[];
    end
end
%% Plot the Correlation curve
bin=round((o-1)/20);
[Vall_bin,Vall_sem_bin,Vall_std_bin] = mnl_BinInputs(STTC(:,2),STTC(:,1),bin);
figure,
plot(STTC(:,2),STTC(:,1),'.k')
hold on
errorbar(Vall_bin(:,1),Vall_bin(:,2),Vall_std_bin(:,2),'.-r')
xlabel('Distance (um)')
ylabel('STTC')
end

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