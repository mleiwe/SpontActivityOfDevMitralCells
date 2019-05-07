function [SpanStats,RateConstantStats,HalfLifeStats,BootstrapSTTC,BootstrapNumber]=mnl_BootstrapSTTC(STTC,n,workspace)
% Bootstrapping of STTC data to see if it really is different to a random n
% number of shuffles of glomeruli locations.
% Created by Marcus Leiwe, CDB Riken, NOV 2014
BootstrapNumber=n;
sz=size(STTC);

%% Remove Correlations between same Glom for the true STTC
sz=size(STTC);
counter=1;
for i=1:sz(1)
    if STTC(i,2)~=0
        newSTTC(counter,:)=STTC(i,:);
        counter=counter+1;
    end
end    

STTC=newSTTC;
sz=size(STTC);
%% Make a structured matrix for each Bootstrap
for i=1:n
    tempSTTCscores=STTC(:,1);
    tempDistances=STTC(:,2);
    % Now randomise the distances
    DistPos=randperm(sz(1));
    for i2=1:sz(1)
        NewTempDistance(i2,:)=tempDistances(DistPos(i2));
    end
    % Now make the structured array
    BootstrapSTTC(i).STTC=[tempSTTCscores NewTempDistance];
end

%% Concatenate it into one bootstrapSTTC matrix
sz1=size(BootstrapSTTC);
ConcatBootstrapSTTC=[];
for i=1:sz1(1)
    ConcatBootstrapSTTC=[ConcatBootstrapSTTC;BootstrapSTTC(i).STTC];
end    
%% Check if I made too many bootstraps with a non-distance dependent bootstrap
sz=size(STTC);
sz1=size(ConcatBootstrapSTTC);

Xbar=mean(STTC(:,1));

PopMean=mean(ConcatBootstrapSTTC(:,1));
PopStd=std(ConcatBootstrapSTTC(:,1));
PopSem=PopStd/sqrt(sz1(1));

[h,p,ci,zval]=ztest(Xbar,PopMean,PopStd);
%h=accept or reject null hypothesis (0=Accept the null hypothesis)
%p=p value
%ci=confidence interval
%zval=z score

if h==1
    disp('True Mean=')
    disp(Xbar)
    disp('Bootstrapped Mean=')
    disp(PopMean)    
    disp('Population Standard Deviation=')
    disp(PopStd)
    error(['There is a significant difference between the bootstrap and the actual data.'...
        'Restart the program with a lower bootstrap number.']);
end
%% Visualise the Differences
MaxDist=max(STTC(:,2));
bin=round(MaxDist/20);
[Vall_bin,Vall_sem_bin,Vall_std_bin] = mnl_BinInputs(STTC(:,2),STTC(:,1),bin);

MaxDist=max(ConcatBootstrapSTTC(:,2));
bin=round(MaxDist/20);
[Vall_bin_BS,Vall_sem_bin_BS,Vall_std_bin_BS] = mnl_BinInputs(ConcatBootstrapSTTC(:,2),ConcatBootstrapSTTC(:,1),bin);

% Now make the plots
figure,
scatter_patches(STTC(:,2),STTC(:,1),2,'r','FaceAlpha',0.3,'EdgeAlpha',0.3);
hold on
scatter_patches(ConcatBootstrapSTTC(:,2),ConcatBootstrapSTTC(:,1),2,'k','FaceAlpha',0.3,'EdgeAlpha',0.3);
[rSpan,rRateConstant]=mnl_ExponentialFit(STTC(:,2),STTC(:,1),'r');
[bSpan,bRateConstant]=mnl_ExponentialFit(ConcatBootstrapSTTC(:,2),ConcatBootstrapSTTC(:,1),'k');
%errorbar(Vall_bin_BS(:,1),Vall_bin_BS(:,2),Vall_std_bin_BS(:,2),'.-k')
%errorbar(Vall_bin(:,1),Vall_bin(:,2),Vall_std_bin(:,2),'.-r')
xlabel('Distance (um)')
ylabel('STTC')
savefig('STTC_bootstrap')

%% Stats with decay curves
figure,
title('Fitted decay curves')
% Calculate it for each bootstrap
sz1=size(BootstrapSTTC,2);%number of bootstraps
for i=1:sz1
    hold on
    [tSpan,tRateConstant]=mnl_ExponentialFit(BootstrapSTTC(i).STTC(:,2),BootstrapSTTC(i).STTC(:,1),'k');
    B_Span(i)=tSpan;
    B_RateConstant(i)=tRateConstant;
    
    %Draw the Fitted Curve
    FitX=(0:1:MaxDist)';
    if tRateConstant==0 || tRateConstant==-0
        FitY=tSpan*exp(1*FitX);
    else
        FitY=tSpan*exp(tRateConstant*FitX);
    end
    plot(FitX,FitY,'k')
    hold on
end

scatter_patches(STTC(:,2),STTC(:,1),2,'r','FaceAlpha',0.3,'EdgeAlpha',0.3);
%f=fit(STTC(:,2),STTC(:,1),'exp1'); %exp1 fits a curve of the following function...a*exp(b*x)NB Have not factored in a constant
%coeffvals=coeffvalues(f); %coeffvals(1)=a,coeffvals(2)=b
%Span=coeffvals(1);
%RateConstant=coeffvals(2);
%FitX=(0:1:MaxDist)';
%FitY=Span*exp(RateConstant*FitX);
%plot(FitX,FitY,'r','LineWidth',2)
[k,yInf,y0,~]=fitExponential(STTC(:,2),STTC(:,1));
Span=yInf+(y0-yInf);
RateConstant=k;
MaxX=max(STTC(:,2));
FitX=(0:1:MaxX)';
FitY=yInf+(y0-yInf)*exp(-k*(FitX-FitX(1)));
plot(FitX,FitY,'r','LineWidth',2)
% Now Stats for Span
[h,p,ci,zval]=ztest(Span,mean(B_Span),std(B_Span));
SpanStats.Span=Span;
SpanStats.h=h;
SpanStats.p=p;
SpanStats.ci=ci;
SpanStats.zval=zval;
SpanStats.PopMean=mean(B_Span);
SpanStats.PopStd=std(B_Span);
% Now Stats for Rate Constants
[h,p,ci,zval]=ztest(RateConstant,mean(B_RateConstant),std(B_RateConstant));
RateConstantStats.RateConstant=RateConstant;
RateConstantStats.h=h;
RateConstantStats.p=p;
RateConstantStats.ci=ci;
RateConstantStats.zval=zval;
RateConstantStats.PopMean=mean(B_RateConstant);
RateConstantStats.PopStd=std(B_RateConstant);

%% Calculate Half-life
% Real Half Life
x0=(log(0.5/Span))/RateConstant;
x1=(log(0.25/Span))/RateConstant;
HalfLife=x1-x0;

% Bootstap values
for i=1:n
    x0=(log(0.5/B_Span(i)))/B_RateConstant(i);
    x1=(log(0.25/B_Span(i)))/B_RateConstant(i);
    B_HalfLife(i)=x1-x0;
end
[h,p,ci,zval]=ztest(HalfLife,mean(B_HalfLife),std(B_HalfLife));
HalfLifeStats.HalfLife=HalfLife;
HalfLifeStats.h=h;
HalfLifeStats.p=p;
HalfLifeStats.ci=ci;
HalfLifeStats.zval=zval;
HalfLifeStats.PopMean=mean(B_HalfLife);
HalfLifeStats.PopStd=std(B_HalfLife);

%% Write a bootstrap to the table
Identity={'Real';'Bootstrap'};

SpanMean=[Span;mean(B_Span)];
SpanN=[1;n];
SpanStd=[0;std(B_Span)];

RateMean=[RateConstant;mean(B_RateConstant)];
RateN=[1;n];
RateStd=[0;std(B_RateConstant)];

HalfLifeMean=[HalfLife;HalfLifeStats.PopMean];
HalfLifeN=[1;n];
HalfLifeStd=[0;HalfLifeStats.PopStd];

T=table(Identity,SpanMean,SpanN,SpanStd,RateMean,RateN,RateStd,HalfLifeMean,HalfLifeN,HalfLifeStd);
fn=sprintf('%s%s',workspace,'.xlsx');
writetable(T,fn,'Sheet','STTC Curve Fits');

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