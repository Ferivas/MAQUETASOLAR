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
$hwstack = 128
$swstack = 128
$framesize = 128

$projecttime = 52
$version 0 , 0 , 43



'Declaracion de constantes
'CONST
Const Numleds = 10
Const Numseed = 20
Const Numleds_masuno = Numleds + 1
Const Numleds_menossuno = Numleds - 1
R Alias Color(_base) : G Alias Color(_base + 1) : B Alias Color(_base + 2)



'Configuracion de entradas/salidas
Led1 Alias Portd.3                                          'LED ROJO
Config Led1 = Output

Buzzer Alias Portc.3                                        'Buzzer
Config Buzzer = Output
Set Buzzer

'Teclado
Config Portb.0 = Output
Config Portb.1 = Output
Config Portb.2 = Output
Config Portb.3 = Output

Config Pind.4 = Input
Config Pind.5 = Input
Config Pind.6 = Input

Set Portd.4
Set Portd.5
Set Portd.6

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


Config Rainbow = 1 , Rb0_len = Numleds , Rb0_port = Portd , Rb0_pin = 2
'                                                   ^ connected to pin 0
'                                       ^------------ connected to portB
'                         ^-------------------------- 8 leds on stripe
'              ^------------------------------------- 1 channel

Config Twi = 400000
Config Scl = Portc.5                                        ' used i2c pins
Config Sda = Portc.4

I2cinit

$lib "i2c_twi.lbx"
$lib "glcdSSD1306-I2C.lib"

Config Graphlcd = Custom , Cols = 128 , Rows = 64 , Lcdname = "SSD1306"




Enable Interrupts


'*******************************************************************************
'* Archivos incluidos
'*******************************************************************************
$include "DIVISOR_archivos.bas"



'Programa principal
Sound Buzzer , 600 , 280
Set Buzzer
'Programa principal

Cls
Setfont Font16x16
Lcdat 1 , 1 , "HOLA   "

Rb_selectchannel 0                                          ' select first channel

Call Ledsaludo()

Call Inivar()



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

   Call Getteclado()

   If Newkey = 1 Then
      Reset Newkey
      Call Getkey()
      Print #1 , "Vk=" ; Keys
      Call Beep()
'      Tmpstr52 = Str(keys) + "  "
'      Lcdat 1 , 1 , Tmpstr52
      Waitms 50
      If Keys > 0 And Keys < 11 Then
         Tmpw = Numr Mod Keys
         If Tmpw = 0 Then
            Print #1 , Numr ; " div por " ; Keys
            Tmpstr52 = "DIV " + Str(keys) + "  "
            Lcdat 4 , 1 , Tmpstr52
            Tmpstr52 = "   OK   "
            Lcdat 7 , 1 , Tmpstr52
            Numpix = Keys - 1
            Rb_clearcolors
            R = 0 : G = 200 : B = 50
            Rb_setcolor Numpix , Color(1)
            Rb_send
            Call Beepok()
         Else
            Print #1 , Numr ; " NO div por " ; Keys
            Tmpstr52 = "DIV " + Str(keys) + " "
            Lcdat 4 , 1 , Tmpstr52
            Tmpstr52 = " ERROR   "
            Lcdat 7 , 1 , Tmpstr52
            Numpix = Keys - 1
            Rb_clearcolors
            R = 200 : G = 0 : B = 0
            Rb_setcolor Numpix , Color(1)
            Rb_send
            Call Beeperr()
            Rb_clearcolors
            Rb_send
         End If
      End If

      If Keys = 11 Then
         Print #1 , "Anterior"
         Numr = Numrant
         Tmpstr52 = Str(numr) + "  "
         Lcdat 1 , 1 , Tmpstr52
         Rb_clearcolors
         Rb_send
         Call Antnumled()
      End If

      If Keys = 12 Then
         Print #1 , "Nuevo núnero"
         Numrant = Numr
         Cls
         Numr = Rnd(1000)
         Print #1 , "Nr=" ; Numr
         Tmpstr52 = Str(numr) + "  "
         Lcdat 1 , 1 , Tmpstr52
         Rb_clearcolors
         Rb_send
         Call Nuevonumled()
      End If

   End If
Loop