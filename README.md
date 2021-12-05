# Semi-Autonomous Land-Based Locomotive code

**Main:**
MyLiteKit

**SubSystems:**
MotorControl,
SensorControl,
CommControl

**Object Files:**
EE-7_ToF,
EE-7_Ultra_v2,
FullDuplexSerial,
i2cDriver_v2,
Servo8Fast_vZ2

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Description

## Main
**MyLiteKit** is the main code loaded into the platform. As the central point for all the other subsystem, the movements are modified here to achieve semi-autonomous movement.

## Subsystems 
>All subsystems are ran in a different core of the propeller tool

**MotorControl** contains all the movement option of the platform, Forward, Backward, Left and Right. Movement is done when instruction is passsed down from MyLiteKit.

**SensorControl** contains all sensor option available on the platform. Continuous reading and used in Main to ensure movements are stopped when required

**CommControl** contains communication code between remote and the platform. Takes input from remote to execute certain movements. 
