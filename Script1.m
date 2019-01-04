%% ELEC_344 Laboratory 1: Contact Pressure Sensors
clc
clear

%%
%%Part 1: Sensor Response and Hysteresis
weight = [1:16]; % oz

%A) Weight versus Vout
Vout402up = [0.49 1.07 1.47 2.61 2.89 3.00 3.15 3.22 3.24 3.38 3.47 3.50 3.51 3.59 3.65 3.69]; %Volts
VoutA201up = [0.07 0.18 0.30 0.49 0.62 0.72 0.86 0.81 0.90 1.02 1.10 1.20 1.24 1.33 1.32 1.52]; %Volts
Vout402dwn = [0.00 2.14 2.15 2.64 3.04 3.00 3.15 3.11 3.21 3.45 3.49 3.53 3.58 3.63 3.66 3.70];
VoutA201dwn = [0.11 0.09 0.28 0.42 0.56 0.65 0.69 0.88 1.04 1.09 1.16 1.26 1.33 1.38 1.47 1.51];
 
%Plot both sensors Vout VS Weight
figure(1)                          
plot(weight,Vout402up,weight,VoutA201up)
xlabel('Weight(oz)');
ylabel('Output Voltage(v)');
title('Output Voltages with Varied Weights');
legend({'FSR 402','Flexiforce A201'},'Location','northwest');

%Calculate the force applied to each sensor 
Mass = weight*0.02835; %kg
Force = Mass*9.8; %N

%Plot both sensors Vout VS Force
figure(2)
plot(Force,Vout402up,Force,VoutA201up)
xlabel('Force(N)');
ylabel('Output Voltage(v)');
title('Output Voltages vs Force');
legend({'FSR 402','Flexiforce A201'},'Location','northwest');

% Checking if the Flexiforce A201 was linear
p = polyfit(Force,VoutA201up,1);
yfit = polyval(p,Force);                 %Creates the line of best fit

%Calculate the residual 
yresid = VoutA201up - yfit;                       %Compute the residual values as a vector
SSresid = sum(yresid.^2);                       %Computes Square the Residuals and total them
SStotal = (length(VoutA201up)-1)*var(VoutA201up);   %Computes the total sum of squares of VoutA201
rsq = 1-SSresid/SStotal                         %Calculates R^2

figure(3)
plot(Force,VoutA201up,'o')
hold on 
plot(Force,yfit)  
hold off
xlabel('Pressure(N/m^2)');
ylabel('Output Voltage (v)');
title('Testing Linearity of Flexiforce A201');
legend({'Data points','Line of Best Fit'},'Location','northwest');

%%B) Hysteresis

%Calculate the area of force applied to the sensor

radius402 = 0.0066; %radius of the coupling piece for 402 FSR (m)
radiusA201 = 0.00475; %radius of the coupling piece for flexiforce A201 (m)
area402 = pi*radius402.^2;
areaA201 = pi*radiusA201.^2;

pressure402 = Force/area402;
pressureA201 = Force/areaA201;

%plot the hysteresis for FSR 402
figure(4)
ax1 = subplot(2,1,1);
plot(ax1,pressure402,Vout402up,pressure402,Vout402dwn)
xlabel('Pressure(N/m^2)');
ylabel('Output Voltage (v)');
title('Output Voltage versus Pressure for FSR 402');
legend({'Increasing Pressure','Decreasing Pressure'},'Location','northwest');

%plot the hysteresis for Flexiforce A201
figure(4)
ax2 = subplot(2,1,2);
plot(ax2,pressureA201,VoutA201up,pressureA201,VoutA201dwn)
xlabel('Pressure(N/m^2)');
ylabel('Output Voltage (v)');
title('Output Voltage versus Pressure for Flexiforce A201');
legend({'Increasing Pressure','Decreasing Pressure'},'Location','northwest');

%Determine if hysteresis is within specifications
%calculate the average output Voltage for increasing and decreasing weight
%FSR402
diffFSR = ((Vout402up - Vout402dwn)/Vout402up) * 100
diffA201 = ((VoutA201up - VoutA201dwn)/VoutA201up)*100


%%
%Part 2 Repeatability and drift

FSR4 = [2.05 1.81 1.75 1.76 1.58]; %5 sample voltages Sensor FSR 402, 4 oz weight
FSR8 = [3.24 2.98 2.88 3.12 3.00]; %5 sensor voltages Sensor FSR 402, 8 oz weight

Flexiforce4 = [0.44 0.45 0.36 0.41 0.37]; %5 sample voltages for Sensor Flexiforce A201, 4oz weight
Flexiforce8 = [1.00 0.84 0.85 0.92 0.89]; %5 sample voltages Sensor Flexiforce A201, 8oz weight

avgFSR4 = mean(FSR4) %Average output voltage at 4 oz for sensor FSR 402
avgFSR8 = mean(FSR8) %Average output voltage at 8 oz for sensor FSR 402
avgFlexiforce4 = mean(Flexiforce4) %Average output voltage at 4 oz for sensor Flexiforce A201
avgFlexiforce8 = mean(Flexiforce8) %Average output voltage at 4 oz for sensor Flexiforce A201

stdFSR4 = std(FSR4) %Standard Deviation of 4 oz weight for sensor FSR 402
stdFSR8 = std(FSR8) %Standard Deviation of 8 oz weight for sensor FSR 402
stdFlexiforce4 = std(Flexiforce4) %Standard Deviation of 4 oz weight for sensor Flexiforce A201
stdFlexiforce8 = std(Flexiforce8) %Standard Deviation of 8 oz weight for sensor Flexiforce A201

%Calculate average standard deviation for both sensors
AvgstdFSR = (stdFSR4 + stdFSR8)/2
AvgstdFF = (stdFlexiforce4 + stdFlexiforce8)/2