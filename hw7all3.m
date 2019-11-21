%Q1

%load data
load('PlottingData.mat')

%Sub plot 1
figure; subplot(2,2,1);plot(EEGTime,PlotEEG)
xlim([742.1230 745.1230])
ylabel('EEGTime (ms)')
xlabel('PlotEEG')

hold on

%Sub plot 2
subplot(2,2,2);plot(EEGTime, PlotEEG2, 'r')
ylim([-1500 1500])
xlim([742.1230 745.1230])
ylabel('EEGTime (ms)')



%Sub plot 3
subplot(2,2,3);plot(EEGTime, PlotEEG3, 'LineWidth',2)
xlim([742.1230 745.1230])
ylabel('PlotEEG3')
xlabel('EEGTime (ms)')

%Sub plot 4
subplot(2,2,4);plot(MEGTime, PlotMEG)
xlabel('MEGTime (ms)')
legend('1','2', '3','4','5')

%Q2
Gaussian = randn(10000,1);
figure; subplot(3,1,1);hist(Gaussian)
ylabel('Gaussian')
hold on

subplot(3,1,2);hist(Gaussian, 101)
ylabel('Gaussian')

b = linspace(-5, 5)
centers = [b];
a = median(Gaussian)

subplot(3,1,3);hist(Gaussian, centers)
ylabel('Gaussian')
xlabel('Centers')
line([0 0], ylim, 'LineWidth', 2, 'Color', 'r');


hold off

%Q3:
figure; scatter(ScatterX, ScatterY)
title('Figure 1')

%Figure properties
%Plot browser > marker * > Property marker edge colour > magenta
%Edit > axis properties > x scale > log
%Edit > axis properties > y scale > log
%Edit > axis properties > x limits -.01 to 10^1 
%Edit > axis properties > y axis > y limits 0 to 0.9