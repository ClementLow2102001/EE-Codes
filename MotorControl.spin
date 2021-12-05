{
  PROJECT: EE-6 Practical 1
  PLATFORM: Parallax Project USB Board
  REVISION: 3
  AUTHOR: Clement Low
  DATE: 041121
  LOG:
        041121  Added StopMotor value and Init function
        141121  Added function for all directional movement
        211121  Added functions to utilise cognew when calling
                movement functions
        281121  Modified Start funtion & Added Movement Function
}

CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        '_ConClkFreq = ((_clkmode - xtal1) >> 6 ) * _xinfreq
        '_Ms_001 = _ConClkFreq / 1_000

        'Motor pin allocation
         motor1 = 10
         motor2 = 11
         motor3 = 12
         motor4 = 13

         'Motor stop value +400/-400 for MAX/MIN speeds respectively
         motorStop = 1480
         motorMax = 1580
VAR
  'long forwardStack[64], backwardStack[64], leftStack[64], rightStack[64], stopStack[64]
  'long cogForwardID, cogBackwardID, cogLeftID, cogRightID, cogStopID
  long cogNumID, cogStack[64]
  long _Ms_001

OBJ
  'Term   : "FullDuplexSerial.spin"
  Motors : "Servo8Fast_vZ2.spin"

PUB Start(MSVal, x)

  _Ms_001 := MSVal
  'Activate cog for movement as passed thro parameter
  cogNumID := cognew(Movement(x), @cogStack)

PUB Movement(x)| i
  Init
  i := 100
  repeat
    case long[x]
      1:
        Forward(i)
      2:
        Backward(i)
      3:
        TurnLeft(i)
      4:
        TurnRight(i)
      5:
        StopAllMotors
   Pause(100)

PUB Init
  'Initilise all 4 motors
  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(3000)

PUB StopCore

  if cogNumID
    cogstop (cogNumID~)

PUB StopAllMotors 'Stops all movement
  Set(motor1, motorStop)
  Set(motor2, motorStop)
  Set(motor3, motorStop)
  Set(motor4, motorStop)
  'StopCore

PUB Set(Pin, speed)
    Motors.Set(Pin, speed)

PUB Forward(i)

    Set(motor1, motorStop + i)
    Set(motor2, motorStop + i)
    Set(motor3, motorStop + i)
    Set(motor4, motorStop + i)
    'Pause(100)

  'Increases speed at 5% duty cycle
  'repeat i from 200 to 0 step 10
  '  Set(motor1, motorStop + i)
  '  Set(motor2, motorStop + i)
  '  Set(motor3, motorStop + i)
  '  Set(motor4, motorStop + i)
  '  Pause(100)

PUB Backward(i)

    Set(motor1, motorStop - i)
    Set(motor2, motorStop - i)
    Set(motor3, motorStop - i)
    Set(motor4, motorStop - i)
    'Pause(100)

  'Increases speed at 5% duty cycle
  'repeat i from 200 to 0 step 10
  '  Set(motor1, motorStop - i)
  '  Set(motor2, motorStop - i)
  '  Set(motor3, motorStop - i)
  '  Set(motor4, motorStop - i)
  '  Pause(100)

PUB TurnLeft(i)
    'Increases speed at 5% duty cycle
    'repeat i from 0 to 200 step 10
      Set(motor1, motorStop - i)
      Set(motor2, motorStop + i)
      Set(motor3, motorStop + i)
      Set(motor4, motorStop - i)
      'Pause(75)
    'Decreases speed at 5% duty cycle
    'repeat i from 200 to 0 step 10
      {Set(motor1, motorMax - i)
      Set(motor2, motorMax + i)
      Set(motor3, motorMax + i)
      Set(motor4, motorMax - i)
      Pause(75)
      }
PUB TurnRight(i)
    'Increases speed at 5% duty cycle
    'repeat i from 0 to 200 step 10
      Set(motor1, motorStop + i)
      Set(motor2, motorStop - i)
      Set(motor3, motorStop - i)
      Set(motor4, motorStop + i)
      'Pause(75)
    'Decreases speed at 5% duty cycle
    'repeat i from 200 to 0 step 10
    {  Set(motor1, motorStop + 100)
      Set(motor2, motorStop - 100)
      Set(motor3, motorStop - 100)
      Set(motor4, motorStop + 100)
      'Pause(75)
     }
PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms#>0)
    waitcnt(t+=_MS_001)
return