# Latency Experiment
Matlab script for testing latency between two simulink models in Prague and
 Boston.

 Scripts were tested only on windows machines.

## How to use it
For the first time it is necessary to do following steps:
BOSTON (Controller) / PRAGUE (Plant):
  1. Open **'main_controller'** / **'main_plant'**
  2. Uncomment **model_name** according to you matlab version
  3. Set the breakpoint before **'simulink warmup' (line 19)**
  4. Run script
  5. Open simulink model (**'controller_20xx.slx'** / **'plant_20xx.slx'**)
  6. For all **'Packet Input'** & **'Packet Output'** blocks:
     * Open block > click on 'Board Setup' > Test (do not change anything else)
     * If any test fails then restart your PC and try it again
     * If it fails again try to use different ports and test it again
  7. Continue or end debugging

Otherwise:
BOSTON (Controller) / PRAGUE (Plant):
  1. Open script **'main_controller.m'** / **'main_plant.m'**
  2. Set ip address of remote PC in **'remote_ip'** parameter
  3. Uncomment **model_name** according to you matlab version
  4. Run the script.

## What might go wrong
* It seems that some PCs do not like simulink real time kernel.
* Sometimes my pc just froze during simulation or worse I got a blue screen error.
* I think that problem is in hardware compatibility
* I tried simulation on two lenovos and two acers and I only had problems with acer PCs

## Output should look like this

<!-- ![Alt text](/relative/path/to/img.jpg?raw=true "Optional Title") -->


![Alt text](output.png?raw=true "Output")


 * you can also plot old simulation results, stored in the folder **measured_data**,
    by function: **process_and_plot_data('filename')**
