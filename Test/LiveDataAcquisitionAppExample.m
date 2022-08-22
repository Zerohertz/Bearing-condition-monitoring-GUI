%% Create an App for Live Data Acquisition
% This example shows how to create an app which acquires data from a DAQ
% device or sound card, displays a live data view, and logs data to a MAT-file.
%
% This example app shows how to implement these operations:
%
% * Discover available DAQ devices and select which device to use.
% * Configure device acquisition parameters.
% * Display a live plot in the app UI during acquisition.
% * Save acquired data to a MAT-file by writing to an intermediate binary file
% during acquisition.
%
% By default, the app will open in design mode in App Designer. To run the
% app click *Run* or execute the app from the command line:
% 
%   LiveDataAcquisition
% 
% <<../live_data_acquisition_screenshot.png>>
% 

% Copyright 2019-2020 The MathWorks, Inc.

%% Requirements
% This example app requires:
% 
% * MATLAB(R) R2020a or later.
% * Data Acquisition Toolbox(TM).
% * Corresponding hardware support package for your device vendor.
% * A supported DAQ device or sound card. For example, any National
% Instruments or Measurement Computing device that supports analog input
% |Voltage| or |IEPE| measurements and background acquisition.
%
% 

