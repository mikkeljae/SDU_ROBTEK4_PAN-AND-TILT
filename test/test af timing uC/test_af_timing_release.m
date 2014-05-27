
%test1 = csvread('tcope_9.csv',2,0)
%subplot(3,1,1)
%plot(test1(:,1),test1(:,4))


%test2 = csvread('scope_3.csv',2,0)
%subplot(3,1,2)
%plot(test2(:,1),test2(:,4))


test3 = csvread('scope_5.csv',2,0);
%subplot(3,1,3)

subplot(2,1,1)
plot(test3(:,1),test3(:,4))

subplot(2,1,2)


% Numerical differentiation, add a zero to match lengths
% The result is inversed to make use of MINPEAKHEIGHT possible.
test3_diff = -[0; diff(test3(:,4))];

% Find peaks of the signal - true at falling edge.
[pks,locs] = findpeaks(test3_diff,'MINPEAKHEIGHT',2);

% Time to plot
time = test3(:,1);
time(locs);

% Plot difference
plot(time,test3_diff)

subplot(2,1,1)
plot(test3(:,1),test3(:,4),time(locs),pks,'rv','MarkerFaceColor','r')


% Plot time difference between peaks. 

plot(diff(time(locs)))

%% Test af taskens afvigelse
figure(1);
format Long
scope3 = csvread('scope_3.csv',2,0);
scope4 = csvread('scope_4.csv',2,0);

time = scope3(:,1);
control_task1 = scope3(:,4);
control_task2 = scope4(:,4);


subplot(2,1,1)
plot(time,control_task1,time,control_task2);
axis([-0.1 0.1 0 4]);
xlabel('T [sek]');
ylabel('Volt');
title('Signalet går lavt når control-task er aktiv');


subplot(2,1,2)

scope3_diff = -[0; diff(scope3(:,4))];
scope4_diff = -[0; diff(scope4(:,4))];

[pks3,locs3] = findpeaks(scope3_diff,'MINPEAKHEIGHT',1);
[pks4,locs4] = findpeaks(scope4_diff,'MINPEAKHEIGHT',1);

%pks4 = [0; pks4]
%locs4 = [0; locs4]

time3 = 0:1:118
time4 = 0:1:117



plot(time3,diff(time(locs3)),time4,diff(time(locs4)))

all_pks = [pks3; pks4];
all_locs = [diff(time(locs3)); diff(time(locs4))];


max_value = max(all_locs)
min_value = min(all_locs)
median_value = median(all_locs)
mean_value = mean(all_locs)

max_afvigelse = 1/600 - max_value
min_afvigelse = 1/600 - min_value
median_afvigelse = 1/600 - median_value
mean_afvigelse = 1/600 - mean_value

max_afvigelse_percent = (max_afvigelse / max_value) * 100
min_afvigelse_percent = (min_afvigelse / min_value) * 100
median_afvigelse_percent = (median_afvigelse / median_value) * 100
mean_afvigelse_percent = (mean_afvigelse / mean_value) * 100

%% Test af afviklingstid for Control-task, 
%  regulatoren samt koordinattransformation.
figure(3);
format Long
scope12 = csvread('scope_12.csv',2,0);

time22 = scope12(:,1);

ctrl_task = scope12(:,2);
coor_trans = scope12(:,3);
controller = scope12(:,4);

plot(time22,ctrl_task,time22,coor_trans,time22,controller)


ctrl_task_diff = diff(ctrl_task);
coor_trans_diff = diff(coor_trans);
controller_diff = diff(controller);


[ctrl_task_start_pks, ctrl_task_start_locs] = findpeaks(-ctrl_task_diff,'MINPEAKHEIGHT',1);
[ctrl_task_stop_pks, ctrl_task_stop_locs] = findpeaks(ctrl_task_diff,'MINPEAKHEIGHT',1);

ctrl_task_stop_locs(1,:) = [];
ctrl_task_start_locs(60,:) = [];

% Measure task running time:
ctrl_task_runtime = time22(ctrl_task_stop_locs) - time22(ctrl_task_start_locs);

% Analyze data: 

ctrl_task_max = max(ctrl_task_runtime)
ctrl_task_min = min(ctrl_task_runtime)
ctrl_task_median = median(ctrl_task_runtime)
ctrl_task_mean = mean(ctrl_task_runtime)


% Measure time between each task execution.
ctrl_task_start_time = diff(time22(ctrl_task_start_locs));

ctrl_task_start_max = max(ctrl_task_start_time)
ctrl_task_start_min = min(ctrl_task_start_time)
ctrl_task_start_median = median(ctrl_task_start_time)
ctrl_task_start_mean = mean(ctrl_task_start_time)

ctrl_task_start_max_dev = (1/600) - max(ctrl_task_start_time)
ctrl_task_start_min_dev = (1/600) - min(ctrl_task_start_time)
ctrl_task_start_median_dev = (1/600) - median(ctrl_task_start_time)
ctrl_task_start_mean_dev = (1/600) - mean(ctrl_task_start_time)



% Coordinate transform data:

[coor_trans_start_pks, coor_trans_start_locs] = findpeaks(-coor_trans_diff,'MINPEAKHEIGHT',1);
[coor_trans_stop_pks, coor_trans_stop_locs] = findpeaks(coor_trans_diff,'MINPEAKHEIGHT',1);
% Fit arrays. 
coor_trans_stop_locs(1,:) = [];
coor_trans_start_locs(60,:) = [];

% Measure running time: 
coor_trans_runtime = time22(coor_trans_stop_locs) - time22(coor_trans_start_locs);



coor_trans_runtime_max = max(coor_trans_runtime)
coor_trans_runtime_min = min(coor_trans_runtime)
coor_trans_runtime_median = median(coor_trans_runtime)
coor_trans_runtime_mean = mean(coor_trans_runtime)

% Controller runtime data: 

[controller_start_pks, controller_start_locs] = findpeaks(-controller_diff,'MINPEAKHEIGHT',2);
[controller_stop_pks, controller_stop_locs] = findpeaks(controller_diff,'MINPEAKHEIGHT',2);

controller_start_locs(61,:) = [];

controller_runtime = time22(controller_stop_locs) - time22(controller_start_locs);

controller_runtime_max = max(controller_runtime)
controller_runtime_min = min(controller_runtime)
controller_runtime_median = median(controller_runtime)
controller_runtime_mean = mean(controller_runtime)



%% Test af SPI timing 
figure(2);


% Load data. Brugt data med høj tidsopløsning
format Long
scope3 = csvread('scope_3.csv',2,0);
scope5 = csvread('scope_5.csv',2,0);

time = scope5(:,1);
time2 = scope3(:,1);

spi_read = scope5(:,2);
spi_read2 = scope3(:,2);

spi_write = scope5(:,3);
spi_write2 = scope3(:,3);




plot(time,spi_read,time,spi_write)
axis([-0.005 0.005 1 4])

spi_read_diff = diff(spi_read);
spi_read2_diff = diff(spi_read2);
spi_write_diff = diff(spi_write);
spi_write2_diff = diff(spi_write2);

plot(diff(spi_read2))

[read_start_pks read_start_locs] = findpeaks(-spi_read_diff,'MINPEAKHEIGHT',1);
[read_stop_pks read_stop_locs] = findpeaks(spi_read_diff,'MINPEAKHEIGHT',1);

[read2_start_pks read2_start_locs] = findpeaks(-spi_read2_diff,'MINPEAKHEIGHT',1);
[read2_stop_pks read2_stop_locs] = findpeaks(spi_read2_diff,'MINPEAKHEIGHT',1);

[write_start_pks write_start_locs] = findpeaks(-spi_write_diff,'MINPEAKHEIGHT',0.723);
[write_stop_pks write_stop_locs] = findpeaks(spi_write_diff,'MINPEAKHEIGHT',0.723);


read_time = time(read_stop_locs) - time(read_start_locs)
write_time = time(write_stop_locs) - time(write_start_locs)

combined = [read_time; write_time]

test_r21 = time2(read2_stop_locs);
test_r22 = time2(read2_start_locs);

test_r21(1,:) = []



test2_max = max(combined)
test2_min = min(combined)
test2_average = mean(combined)
test2_min = median(combined)

plot(read_time)

figure;
plot(test_r21 - test_r22)


