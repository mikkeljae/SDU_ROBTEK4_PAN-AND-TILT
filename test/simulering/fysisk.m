%% Importér tests på PTS
fontsize1 = 14;

Path                        ='path_phi_theta_600hz.csv';
ts=-4:4;
tt=0.557;
tstop=1.18;
sampleperiod=0.001666660;

maxerr=atand(1.32/(2*37));


Eksperiment                 ={'test231.csv','test232.csv',...
	'test233.csv','test234.csv','test235.csv','test236.csv',...
    'test237.csv','test238.csv','test239.csv','test240.csv',...
    'test241.csv','test242.csv','test243.csv','test244.csv',...
    'test245.csv','test246.csv','test247.csv','test248.csv',...
    'test249.csv'};


dead_zone_tilt_max=300;
dead_zone_tilt_min=20;
dead_zone_pan_max=240;
dead_zone_pan_min=20;

integral_saturation_tilt=100;
integral_saturation_pan=100;

Kptilt=240;
Kitilt=85;
Kdtilt=0;

Kppan=100;
Kipan=110;
Kdpan=3.8;

Data_path=csvread(Path,1,0,[1,0,709,1]);

t=0:sampleperiod:sampleperiod*(length(Data_path)-1);
totalticks = 360;

for i=1:length(Eksperiment)
    Data(:,:,i)=csvread(Eksperiment{i},1,0,[1,0,709,5]);
end


%% Pan Error Signal
for i=1:length(Eksperiment)
    errorpan(:,i)=Data_path(:,2)./3-Data(:,2,i)./3;
    for j = 1:size(errorpan,1)
        if errorpan(j,i) < totalticks/(-2)
        	errorpan(j,i) = errorpan(j,i) + totalticks;
        elseif errorpan(j,i) > totalticks/2
        	errorpan(j,i) = errorpan(j,i) - totalticks;
        end
    end
end

minpan=min(min(errorpan));
maxpan=max(max(errorpan));

figure(2);
plot(t,errorpan,'.',[tt tt],[-10 10],'black',[tstop tstop],[-10,10],'black',...
    'MarkerSize',4); grid on;
xlim([0 tstop]);
ylim([minpan-1, maxpan+1]);

%% Tilt Error Signal
for i=1:length(Eksperiment)
    errortilt(:,i)=Data_path(:,1)./3-Data(:,1,i)./3;
    for j = 1:size(errortilt,1)
        if errortilt(j,i) < totalticks/(-2)
        	errortilt(j,i) = errortilt(j,i) + totalticks;
        elseif errortilt(j,i) > totalticks/2
        	errortilt(j,i) = errortilt(j,i) - totalticks;
        end
    end
end

mintilt=min(min(errortilt));
maxtilt=max(max(errortilt));

figure(3);
plot(t,errortilt,'.',[tt tt],[-10 10],'black',[tstop tstop],[-10,10],'black',...
    'MarkerSize',4); grid on;
xlim([0 tstop]);
ylim([mintilt-1, maxtilt+1]);

%% Tracking Error

for j=1:length(Eksperiment)
    for i = 1:size(errorpan,1)
        trackingerrorPhys(i,j) = sqrt(errorpan(i,j).^2 + errortilt(i,j).^2);
    end
end
minTE=min(min(trackingerrorPhys));
maxTE=max(max(trackingerrorPhys));

figure(5);
subplot(2,1,2);
plot(t,trackingerrorPhys,'.',[tt tt],[-10 10],'black',...
    [tstop tstop],[-10 10],'black',...
    [0 tstop],[maxerr maxerr],'black','MarkerSize',4); grid on;
xlim([0 tstop]);
ylim([0, maxTE+0.1]);
% Create title
xlabel('Tid [s]','FontSize',fontsize1);
ylabel('Trackingfejl [grader]','FontSize',fontsize1);
titstr=sprintf('Trackingfejl, Pan & Tilt');
title(titstr,...
    'FontSize',fontsize1);


%% Pan & Tilt Error
figure(5);
subplot(2,1,1);
plot(t,errortilt(:,1),'b.',t,errorpan,'rx',...
    t,errortilt(:,2:length(Eksperiment)),'b.',...
    [tt tt],[-10 10],'black',[tstop tstop],[-10,10],'black',...
    'MarkerSize',4); grid on;
xlim([0 tstop]);
ylim([-5, 1.5]);
legend('Tilt','Pan');
% Create title
xlabel('Tid [s]','FontSize',fontsize1);
ylabel('Fejlsignal [grader]','FontSize',fontsize1);
titstr=sprintf('Fejlsignaler, Pan & Tilt');
title(titstr,...
   'FontSize',fontsize1);

%% Export Pan & Tilt Error signals

% Config:
aspectratioNUM = 14;    %X
aspectratioDEN = 28;     %Y
scalefactor1 = 70;

aspectratioNUM = aspectratioNUM*scalefactor1;    %X
aspectratioDEN = aspectratioDEN*scalefactor1;     %Y

figure(5);
figure5 = figure (5);

%set size. Don't mess.
set(gcf,'PaperPositionMode','auto')
Coord = get(figure5,'Position');
set(figure5,'Position',[0 0 aspectratioNUM aspectratioDEN]);
%Export graphics:
print -depsc2 -loose 'pidPhys2.eps';