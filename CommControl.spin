{
  PROJECT: CommControl
  PLATFORM: Parallax Project USB Board
  REVISION: 1
  AUTHOR: Clement Low
  DATE: 211121
  LOG:
        211121  Added basic functions
}



CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        '_ConClkFreq = ((_clkmode - xtal1) >> 6 ) * _xinfreq
        '_Ms_001 = _ConClkFreq / 1_000

        commRxPin   = 20
        commTxPin   = 21
        commBaud    = 9600

        commStart   = $7A
        commForward = $01
        commReverse = $02
        commLeft    = $03
        commRight   = $04
        commStopAll = $AA


VAR

  long _Ms_001
  long cogCommID, rxValue
  long cogStack[128]

OBJ
  Comm      : "FullDuplexSerial.spin"

PUB Start(MSVal, CommValue)

  _Ms_001 := MSVal
  cogCommID := cognew(Rx(CommValue), @cogStack)

PUB Rx(CommValue) 'rxValue
  'Start Terminal Comms
  Comm.Start(commRxPin, commTxPin, 0, commBaud)
  Pause(3000)
  'Checking for a input
  repeat
    rxValue := Comm.RxCheck
    if rxValue == commStart   'Means to start the car
      repeat
       rxValue := Comm.Rxcheck 'Movement to be made
        case rxValue
          commforward:
           long [CommValue] := 1
          commReverse:
           long [CommValue] := 2
          commLeft:
           long [CommValue] := 3
          commRight:
           long [CommValue] := 4
          commStopAll:
           long [CommValue] := 5

  return

PUB Stop

  cogstop(cogCommId)

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms#>0)
    waitcnt(t+=_MS_001)
return

DAT