# stop_signal_task

Visual stop signal task. Stop signal delays are adjusted with a staircase procedure.

Setup:
Runs on MATLAB using Psychtoolbox.
If an external keypad or mouse is used for the button presses, it must be plugged in prior to starting.
File to run the task is stop1.m

Instructions for the subject:
When you see left or right arrows, press the left or right buttons (1 or 0), respectively. In some trials, a stop signal will appear. Immediately halt any button presses, until the next arrow appears. You should prioritize speed over accuracy, as the task will adjust the difficultly based on your performance.

Sample instructions for running the task using an external keypad
1.	Run stop1.m
2.	In the menu pop-up, click Initialize
    •	Use standard mode: ENTER
    •	What subject number: ENTER
    •	Enter IRB number: ENTER
    •	Enter gender: ENTER
    •	Enter age: ENTER
    •	Enter handedness: ENTER
    •	Name of experimenter: ENTER
    •	What language: ENTER
    •	Use default keys: n
    •	Do you want to use the mouse? ENTER
    •	Do you want to use the keypad? n
    •	Please press any key on the keypad (press any key)
    •	Press key for left response… 1
    •	Press key for right response… 0
3.	Run stop1.m again
4.  In the pop-up menu, click Run and the task will begin
5.	There are 4 “mini sessions” per block, and you should run 2-3 blocks. Each time a mini session ends, you need to press the space bar to advance. Each time a block ends, you need to press the space bar 3 times to advance.

Exiting the task
•	Press and hold escape
•	If you want to go back and run the task again, it will pick up where it left off
•	To run the task from the beginning, you need to re-initialize first

Troubleshooting
•	Make sure the task directory is on the top of the MATLAB path list.
•	If the keypad isn’t registering, exit MATLAB and put the computer to sleep. Make sure the keypad is plugged in when you wake up the computer and restart MATLAB.

