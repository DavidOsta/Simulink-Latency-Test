# Latency Experiment
Matlab script for testing latency between two simulink models communicating to each other via UDP protocol.

 Script was tested only on windows machines, for the following versions:
  * R2013B
  * R2014B
  * R2015B

Documentation and tests are not finished.

## How to use it
Run main script **main_GUI.m**

You can select following parameters:
  * Ip address - ip address of remote machine
  * Ports - by default use **combination A**, if you encounter problems with
    board installation try B, C
  * Station
  * Matlab version

<p align="center">
![gui](/figs/gui.png?raw=true "GUI")
</p>

For the first time it is necessary to install UDP boards
  1. Select your station and version
  2. Click on **Check Ports** button
  3. In loaded simulink model test all **I/O Packet** block
     * Open block
     * If you get prompt to install, install it
     * Click on **Board Setup** > and click on **Test** (do not change anything else)
     * If any board test fails then restart your PC and try it again
     * If that did not help then try to use different ports **combination B,C** and test it again

Otherwise just select parameters and click on **Run**


## What might go wrong
* It seems that some PCs do not like simulink real time kernel especially PCs with windows 10. Problem might be in drivers

## Output should look like this

![output](/figs/output.png?raw=true "Output")

 * you can also plot old simulation results, stored in the folder **measured_data**,
    by function: **plot_data('filename')**
