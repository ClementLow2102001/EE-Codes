{
  PROJECT: MyLiteKit
  PLATFORM: Parallax Project USB Board
  REVISION: 2
  AUTHOR: Clement Low
  DATE: 141121
  LOG:
        141121  Added Main for movement with sensors
        211121  Added CommControl.spin
        281121  Modified CommControl case
}


CON
        _clkmode = xtal1 + pll16x                             'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6 ) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

VAR

  long ToF1, ToF2, Ultra1, Ultra2
  long motorValue
  long CommValue

OBJ

  Term   : "FullDuplexSerial.spin"
  Sen    : "SensorControl.spin"
  Mot    : "MotorControl.spin"
  Comm   : "CommControl.spin"

PUB Main

  'Term.Start(31, 30, 0, 115200)
  'Pause(500)

  Comm.Start(_Ms_001, @CommValue)                            'Start Comm Terminal
  Mot.Start(_Ms_001, @motorValue)                            'Start motor Init
  Sen.Start(_Ms_001, @ToF1, @ToF2, @Ultra1, @Ultra2)         'Start reading sensor values
  Pause(3000)

                                                             'Pause to make sure sensor value is passed thro
  repeat
    case CommValue                                           'Motor movement based on instruction
      1:
        if Ultra1 > 300 AND ToF1 < 250                       'Check surrounding before moving
          motorValue := 1
          'Term.Str(String(13, "Forward"))
        elseif Ultra1 < 300 OR ToF1 > 250                    'Stop movement when near object of cliff
          motorValue := 5
      2:
        if Ultra2 > 300 AND ToF2 < 250
          motorValue := 2
          'Term.Str(String(13, "Backward"))
        elseif Ultra2 < 300 OR ToF2 > 250
          motorValue := 5
      3:
          motorValue := 3
          'Term.Str(String(13, "Left"))
      4:
          motorValue := 4
          'Term.Str(String(13, "Right"))
      5:
          motorValue := 5
          'Term.Str(String(13, "Stop"))
   Pause(20)

  {repeat
    Term.Str(String(13, "Ultra1: "))
    Term.Dec(Ultra1)
    Term.Str(String(13, "Ultra2: "))
    Term.Dec(Ultra2)
    Term.Str(String(13, "ToF1  : "))
    Term.Dec(ToF1)
    Term.Str(String(13, "ToF2  : "))
    Term.Dec(ToF2)
    Pause(150)
    Term.Tx(0)
   }

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms#>0)
    waitcnt(t+=_MS_001)
return