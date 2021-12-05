{
  PROJECT: SensorControl
  PLATFORM: Parallax Project USB Board
  REVISION: 2
  AUTHOR: Clement Low
  DATE: 141121
  LOG:
        141121 Add UltraSensor & ToFSensor
        211121 Add Cognew functions and made program
               a sub-program for MyLiteKit
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        '_ConClkFreq = ((_clkmode - xtal1) >> 6 ) * _xinfreq
        '_Ms_001 = _ConClkFreq / 1_000

         'Ultra 1 pin allocation
        Ultra1SCL = 6
        Ultra1SDA = 7
        'Ultra 2 pin allocation
        Ultra2SCL = 8
        Ultra2SDA = 9
        'ToF1 pin allocation - Bus 1
        tof1SCL = 0
        tof1SDA = 1
        tof1RST = 14
        'ToF2 pin aloocation - Bus 2
        tof2SCL = 2
        tof2SDA = 3
        tof2RST = 15
        'ToF address
        tofAdd = $29

VAR
  long _Ms_001
  long cog1ID
  long cogStack[128]
OBJ
  'Term   : "FullDuplexSerial.spin"
  Ultra  : "EE-7_Ultra_v2.spin"
  ToF[2] : "EE-7_ToF.spin"

PUB Start(MSVal,ToF1, ToF2, Ultra1, Ultra2)

  _Ms_001 := MSVal
  cog1ID := cognew(sensor(ToF1, ToF2, Ultra1, Ultra2), @cogStack)

  return

PUB Stop
  if cog1ID
    cogstop(cog1ID~)

PUB sensor(ToF1, ToF2, Ultra1, Ultra2)
  'Init sensors
  Init
  'Read values from all 4 sensors
  repeat
    long[Ultra1] :=  Ultra.readSensor(0)
    long[Ultra2] :=  Ultra.readSensor(1)
    long[ToF1]   :=  ToF[0].GetSingleRange(tofAdd)
    long[ToF2]   :=  ToF[1].GetSingleRange(tofAdd)
    Pause(50)


PUB Init
  'Init both ToF and UltraSonic Sensor
  Ultra.Init(Ultra1SCL, Ultra1SDA, 0)
  Ultra.Init(Ultra2SCL, Ultra2SDA, 1)


  ToF[0].Init(tof1SCL, tof1SDA, tof1RST)
  ToF[0].ChipReset(1)
  Pause(1000)
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  ToF[0].FreshReset(tofAdd)

  ToF[1].Init(tof2SCL, tof2SDA, tof2RST)
  ToF[1].ChipReset(1)
  Pause(1000)
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  ToF[1].FreshReset(tofAdd)

  return
PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms#>0)
    waitcnt(t+=_MS_001)
return