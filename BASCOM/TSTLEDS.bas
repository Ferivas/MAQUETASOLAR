'Main.bas
'
'                 WATCHING Soluciones Tecnológicas
'                    Fernando Vásquez - 25.06.15
'
' Programa para almacenar los datos que se reciben por el puerto serial a una
' memoria SD
'


$regfile = "m328Pdef.dat"                                   ' used micro
$crystal = 16000000                                         ' used xtal
$baud = 9600                                                ' baud rate we want
$hwstack = 40
$swstack = 40
$framesize = 40

$projecttime = 16
$version 0 , 0 , 21



'Declaracion de constantes
'CONST
Const Numleds = 10
Const Numleds_masuno = Numleds + 1
Const Numleds_menossuno = Numleds - 1
R Alias Color(_base) : G Alias Color(_base + 1) : B Alias Color(_base + 2)



'Configuracion de entradas/salidas
Led1 Alias Portd.3                                          'LED ROJO
Config Led1 = Output


'Configuración de Interrupciones
'TIMER0
Config Timer0 = Timer , Prescale = 1024                     'Ints a 100Hz si Timer0=184
On Timer0 Int_timer0
Enable Timer0
Start Timer0

' Puerto serial 1
Open "com1:" For Binary As #1
On Urxc At_ser1
Enable Urxc


Config Rainbow = 1 , Rb0_len = Numleds , Rb0_port = Portb , Rb0_pin = 2
'                                                   ^ connected to pin 0
'                                       ^------------ connected to portB
'                         ^-------------------------- 8 leds on stripe
'              ^------------------------------------- 1 channel

Enable Interrupts


'*******************************************************************************
'* Archivos incluidos
'*******************************************************************************
$include "TSTLEDS_archivos.bas"



'Programa principal

Call Inivar()

Rb_selectchannel 0                                          ' select first channel

Call Ledsaludo()

R = 0 : G = 0 : B = 0                                       ' define a color
Rb_setcolor 0 , Color(1)                                    ' update leds
Rb_send


Do

   If Sernew = 1 Then                                       'DATOS SERIAL 1
      Reset Sernew
      Print #1 , "SER1=" ; Serproc
      Call Procser()
   End If

   If Newpix = 1 Then
      Reset Newpix
      Print #1 , "Newpix"
      Rb_clearcolors
      Rb_setcolor Numpix , Color(1)
      Rb_send
   End If
Loop