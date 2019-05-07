function [HeventFreq,LeventFreq,HeventAmp,HeventAmp_Std,LeventAmp,LeventAmp_Std,HLRatio]=mnl_IndividualGroupHLevents(ColBursts,thresh)

thresh=5;
sz=[1 1];
Time=zeros(sz(2),1);
ActiveEventFreq=zeros(sz(2),1);
HeventFreq=zeros(sz(2),1);
LeventFreq=zeros(sz(2),1);
HLRatio=zeros(sz(2),1);
n=1;
h=1;
l=1;

Time=Tend; %Extract the imaging session length (in seconds)
sz1=size(ColBursts.NormSumSpikes);
count=0;
Hcount=0;
Lcount=0;
for i2=1:sz1(2)
    if ColBursts.NormSumSpikes(i2)~=0
        ActiveEvents(n)=ColBursts.NormSumSpikes(i2); %Extract the  Active  Events
        n=n+1;
        count=count+1;
        if ColBursts.NormSumSpikes(i2)> thresh
            Hevents(h)=ColBursts.NormSumSpikes(i2); %Extract H events
            h=h+1;
            Hcount=Hcount+1;
        elseif ColBursts.NormSumSpikes(i2)<=thresh
            Levents(l)=ColBursts.NormSumSpikes(i2);  %Extract L events
            l=l+1;
            Lcount=Lcount+1;
        end
    end
end
if Hcount==0
    Hcount=1;
end
if Lcount==0
    Lcount=1;
end
ActiveEventFreq=(count-1)/Time; %The overall frequency of active events
HeventFreq=(Hcount-1)/Time; %The overall frequency of H events
LeventFreq=(Lcount-1)/Time; %The overall frequency of L events
HLRatio=(Hcount-1)/(Lcount-1); %The H to  L  ratio
HeventAmp=mean(Hevents);
HeventAmp_Std=std(Hevents);
LeventAmp=mean(Levents);
LeventAmp_Std=std(Levents);