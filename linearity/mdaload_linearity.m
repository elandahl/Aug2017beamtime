% mdaload_example.m
% DAW 8/3/16

% This is an example file of how to use mdaload.m to extract data from .mda
% files generated by EPICS scans.
clear all
more off
  

filename='NIN_Soo3_0041.mda';

% use mdaload to extract the information from the binary file
xx=mdaload(filename)


% extract various data from the struct

% time at which the scan began
t=getfield(getfield(xx,'scan'),'time');
% number of points in the completed scan
npoints=getfield(getfield(xx,'scan'),'last_point');

% get an array of the positioner values (there is only one for this scan)
pos=getfield(getfield(xx,'scan'),'positioners_data');
% get the name (i.e., the PV) of the positioner
positioner_name=getfield(getfield(getfield(xx,'scan'),'positioners'),'name');
% get the description (i.e., the common name) of the positioner
positioner_desc=getfield(getfield(getfield(xx,'scan'),'positioners'),'description');

% get an array of detector values (30 for this scan)
dets=getfield(getfield(xx,'scan'),'detectors_data');
% here we are interested in the data of detectors 7 and 23, a scaler
% channel and the storage ring current
%  "name" (i.e., the PV) of detector 7
detectorA_name=getfield(getfield(getfield(xx,'scan'),'detectors',{1}),'name');
% name and units for detector 23
detectorB_desc=getfield(getfield(getfield(xx,'scan'),'detectors',{5}),'description');
detectorB_units=getfield(getfield(getfield(xx,'scan'),'detectors',{5}),'unit');

% the undulator energy is stored as an "extra PV"
%energy=getfield(getfield(getfield(xx,'extra'),'pvs',{27}),'values');


% now plot the results

figure(1);clf;
hh=plotyy(pos,dets(:,1),pos,dets(:,5));
xlabel(positioner_name)
ylabel(detectorA_name)
ylabel(hh(2),strcat(detectorB_desc,' (',detectorB_units,')'))
%title(strcat({'Measurement with undulator at '},num2str(energy),' keV'))

%% Plot individual APD traces

[numpts numdets] = size(dets);


for i = 1:numpts
  apd(:,i) = xx.scan.sub_scans(i).detectors_data;
  figure(2);clf;hold on;
  plot(apd(:,i))
  title(['APD Trace number ' num2str(i)])
  xlabel('Scope time base')
  ylabel('V')
  hold off;
  pause(0.2)
end

  

