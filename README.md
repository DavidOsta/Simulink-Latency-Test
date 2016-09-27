# Latency Experiment
Matlab script for testing latency between two simulink models in Prague and
 Boston.

 Script was tested only on windows machines, for the versions:
  * 2013B
  * 2014B
  * 2015B

## How to use it
Script has GUI, you can run it buy command **main_GUI** or simply run script  **main_GUI.m**

You can select following parameters:
  * Ip address - ip address of remote machine
  * Ports - by default use **combination A**, if you encounter problems with
    board installation try B, C
  * Station
  * Matlab version
  * Simulation time in seconds (only at your station)

<p align="center">
![Alt text](/figs/gui.png?raw=true "Output")
</p>

For the first time it is necessary to install boards
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
* It seems that some PCs do not like simulink real time kernel.
* Sometimes my pc just froze during simulation or worse I got a blue screen error.
* I think that problem is in hardware compatibility (drivers)
* I tried simulation on two lenovos and two acers and I only had problems with acer PCs

## Output for controller station should look like this

<!-- ![Alt text](/relative/path/to/img.jpg?raw=true "Optional Title") -->
![Alt text](/figs/output.png?raw=true "Output")


 * you can also plot old simulation results, stored in the folder **measured_data**,
    by function: **process_and_plot_data('filename')**
