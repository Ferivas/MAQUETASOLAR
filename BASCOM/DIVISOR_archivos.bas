'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*  SD_Archivos.bas                                                        *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*                                                                             *
'*  Variables, Subrutinas y Funciones                                          *
'* WATCHING SOLUCIONES TECNOLOGICAS                                            *
'* 25.06.2015                                                                  *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

$nocompile


'*******************************************************************************
'Declaracion de subrutinas
'*******************************************************************************
Declare Sub Inivar()
Declare Sub Procser()
Declare Sub Ledsaludo()
Declare Sub Getteclado()
Declare Sub Barrido()
Declare Sub Leepuerto()
Declare Sub Leepuertotmp()
Declare Sub Getkey()
Declare Sub Beep()
Declare Sub Beeperr()
Declare Sub Beepok()
Declare Sub Nuevonumled()
Declare Sub Antnumled()


'*******************************************************************************
'Declaracion de variables
'*******************************************************************************
Dim Tmpb As Byte , Tmpb2 As Byte , J As Byte
Dim K As Byte
Dim Tmpw As Word , Tmpw2 As Word

Dim Cmdtmp As String * 6
Dim Atsnd As String * 200
Dim Cmderr As Byte
Dim Tmpstr8 As String * 16
Dim Tmpstr52 As String * 52

Dim Color(3) As Byte
Dim Numpix As Byte
Dim Newpix As Bit

'TECLADO
'Dim Cntr As Byte
Dim Newkey As Bit
Dim Keytemp As Byte , Cntr As Byte
Dim Keydata As Byte
Dim Datokey As Byte , Keys As Byte
Dim Keyval As Byte

Dim Numr As Word , Numrant As Word
Dim ___rseed As Word
Dim Ptrseed As Byte
Dim Ptrseedeep As Eram Byte


'Variables TIMER0
Dim T0c As Byte
Dim Num_ventana As Byte
Dim Estado As Long
Dim Estado_led As Byte
Dim Iluminar As Bit
Dim T00 As Byte
Dim Newsec As Byte
dim cntrseg as byte

'Variables SERIAL0
Dim Ser_ini As Bit , Sernew As Bit
Dim Numpar As Byte
Dim Cmdsplit(34) As String * 20
Dim Serdata As String * 200 , Serrx As Byte , Serproc As String * 200



'*******************************************************************************
'* END public part                                                             *
'*******************************************************************************


Goto Loaded_arch

'*******************************************************************************
' INTERRUPCIONES
'*******************************************************************************

'*******************************************************************************
' Subrutina interrupcion de puerto serial 1
'*******************************************************************************
At_ser1:
   Serrx = Udr

   Select Case Serrx
      Case "$":
         Ser_ini = 1
         Serdata = ""

      Case 13:
         If Ser_ini = 1 Then
            Ser_ini = 0
            Serdata = Serdata + Chr(0)
            Serproc = Serdata
            Sernew = 1
            'Enable Timer0
         End If

      Case Is > 31
         If Ser_ini = 1 Then
            Serdata = Serdata + Chr(serrx)
         End If

   End Select

Return


Return

'*******************************************************************************



'*******************************************************************************
' TIMER0
'*******************************************************************************
Int_timer0:
   Timer0 = &H64           '100.1603hZ
   Incr T0c
   T0c = T0c Mod 8
   If T0c = 0 Then
      Num_ventana = Num_ventana Mod 32
      Estado = Lookup(estado_led , Tabla_estado)
      Iluminar = Estado.num_ventana
      Toggle Iluminar
      Led1 = Iluminar
      Incr Num_ventana
   End If

Return





'*******************************************************************************
' SUBRUTINAS
'*******************************************************************************

'*******************************************************************************
' Inicialización de variables
'*******************************************************************************
Sub Inivar()
   Reset Led1
   Print #1 , "************ DRIVER AUDIO ************"
   Print #1 , Version(1)
   Print #1 , Version(2)
   Print #1 , Version(3)
   Estado_led = 1
   Estado_led = 1
   Ptrseed = Ptrseedeep
   Incr Ptrseed
   Ptrseed = Ptrseed Mod Numseed
   Ptrseedeep = Ptrseed
   Tmpw = Lookup(ptrseed , Tblseed)
   ___rseed = Tmpw
   Print #1 , "Ptrseed=" ; Ptrseed
   Print #1 , "rSEED=" ; ___rseed
   Numr = Rnd(1000)
   Print #1 , "Nuevo núnero>" ; Numr
   Tmpstr52 = Str(numr) + "  "
   Lcdat 1 , 1 , Tmpstr52
End Sub

Sub Ledsaludo()
   For J = 0 To Numleds_menossuno
      R = 0
      G = 200
      B = 0
      Rb_setcolor J , Color(1)
      Waitms 100
      'Print #1 , R ; "," ; G ; "," ; B ; " >T=" ; Tmpw
      Rb_send
   Next
   For J = 0 To Numleds_menossuno
      R = 200
      G = 0
      B = 0
      Rb_setcolor J , Color(1)
      Waitms 100
      'Print #1 , R ; "," ; G ; "," ; B ; " >T=" ; Tmpw
      Rb_send
   Next
   For J = 0 To Numleds_menossuno
      R = 0
      G = 00
      B = 200
      Rb_setcolor J , Color(1)
      Waitms 100
      'Print #1 , R ; "," ; G ; "," ; B ; " >T=" ; Tmpw
      Rb_send
   Next
   Waitms 500
   For J = 0 To Numleds_menossuno
      R = 0
      G = 0
      B = 0
      Rb_setcolor J , Color(1)
      Waitms 100
      'Print #1 , R ; "," ; G ; "," ; B ; " >T=" ; Tmpw
      Rb_send
   Next
'   Rb_fill Color
'   Rb_clearcolors
'   Rb_send

End Sub

Sub Nuevonumled()
   For J = 0 To Numleds_menossuno
      R = 200
      G = 100
      B = 0
      Rb_setcolor J , Color(1)
      Waitms 30
      'Print #1 , R ; "," ; G ; "," ; B ; " >T=" ; Tmpw
      Rb_send
   Next
   Wait 1
   Rb_clearcolors
   Rb_send
End Sub

Sub Antnumled()
   For J = Numleds_menossuno To 0 Step -1
      R = 200
      G = 100
      B = 0
      Rb_setcolor J , Color(1)
      Waitms 30
      'Print #1 , R ; "," ; G ; "," ; B ; " >T=" ; Tmpw
      Rb_send
   Next
   Wait 1
   Rb_clearcolors
   Rb_send
End Sub



Sub Getteclado()
   Datokey = Lookup(cntr , Tbl_col)
   Call Barrido()
   Waitus 20
   Call Leepuerto()
   If Keydata <> &H07 Then
      Waitms 10
      Call Leepuertotmp()
      If Keydata = Keytemp Then
         Set Newkey
         Keyval = Cntr
         'Print #1 , "Kdata=" ; Hex(keydata) ; ",Cntr=" ; Cntr
      End If
   End If
   Incr Cntr
   Cntr = Cntr Mod 4
End Sub


Sub Getkey()
   Select Case Keydata
      Case 3:
         Select Case Keyval
            Case 1:
               Keys = 1
            Case 0:
               Keys = 2
            Case 3:
               Keys = 11
            Case 2:
               Keys = 12
         End Select
      Case 5:
         Select Case Keyval
            Case 1:
               Keys = 5
            Case 0:
               Keys = 6
            Case 3:
               Keys = 3                                     '3
            Case 2:
               Keys = 4                                     '4
         End Select
      Case 6:
         Select Case Keyval
            Case 1:
               Keys = 9
            Case 0:
               Keys = 10
            Case 3:
               Keys = 7
            Case 2:
               Keys = 8
         End Select
      Case 5:
         Select Case Keyval
            Case 1:
               Keys = 5
            Case 0:
               Keys = 6
            Case 3:
               Keys = 3                                     '3
            Case 2:
               Keys = 4                                     '4
         End Select
   End Select
End Sub

Sub Barrido()
'   Datokey = Datokey Xor &HFF
   Portb.0 = Datokey.0
   Portb.1 = Datokey.1
   Portb.2 = Datokey.2
   Portb.3 = Datokey.3

End Sub

Sub Leepuerto()
      Keydata = 0
      Keydata.0 = Pind.4
      Keydata.1 = Pind.5
      Keydata.2 = Pind.6
End Sub

Sub Leepuertotmp()
      Keytemp = 0
      Keytemp.0 = Pind.4
      Keytemp.1 = Pind.5
      Keytemp.2 = Pind.6
End Sub

Sub Beep()
    Sound Buzzer , 600 , 280
    Set Buzzer
End Sub

Sub Beepok()
    Sound Buzzer , 500 , 320
    Set Buzzer
    Waitms 200
    Sound Buzzer , 500 , 320
    Set Buzzer

End Sub

Sub Beeperr()
    Sound Buzzer , 1000 , 850
    Set Buzzer
End Sub


'*******************************************************************************
' Procesamiento de comandos
'*******************************************************************************
Sub Procser()
   Print #1 , "$" ; Serproc
   Tmpstr52 = Mid(serproc , 1 , 6)
   Numpar = Split(serproc , Cmdsplit(1) , ",")
   If Numpar > 0 Then
      For Tmpb = 1 To Numpar
         Print #1 , Tmpb ; ":" ; Cmdsplit(tmpb)
      Next
   End If

   If Len(cmdsplit(1)) = 6 Then
      Cmdtmp = Cmdsplit(1)
      Cmdtmp = Ucase(cmdtmp)
      Cmderr = 255
      Select Case Cmdtmp
         Case "LEEVFW"
            Cmderr = 0
            Atsnd = "Version FW: Fecha <"
            Tmpstr52 = Version(1)
            Atsnd = Atsnd + Tmpstr52 + ">, Archivo <"
            Tmpstr52 = Version(3)
            Atsnd = Atsnd + Tmpstr52 + ">"


         Case "SETLED"
            If Numpar = 2 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb < 17 Then
                  Cmderr = 0
                  Atsnd = "Se configura setled a " + Str(tmpb)
                  Estado_led = Tmpb
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "SETPIX"
            If Numpar = 5 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb < Numleds_masuno Then
                  Cmderr = 0
                  Numpix = Tmpb
                  R = Val(cmdsplit(3))
                  G = Val(cmdsplit(4))
                  B = Val(cmdsplit(5))
                  'Rval = R : Gval = G : Bval = B
                  Atsnd = "Se config pix " + Str(numpix) + " a R=" + Str(r) + ", G=" + Str(g) + ", B=" + Str(b)
                  Set Newpix
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEEPIX"
            If Numpar = 2 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb < Numleds_masuno Then
                  Cmderr = 0
                  Color(1) = Rb_getcolor(tmpb)
                  Atsnd = "R=" + Str(color(1)) + ", G=" + Str(color(2)) + ", B=" + Str(color(3))
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "SETRNG"
            If Numpar = 6 Then
               Cmderr = 0
               Tmpb = Val(cmdsplit(2))
               Tmpb2 = Val(cmdsplit(3))
               R = Val(cmdsplit(4))
               G = Val(cmdsplit(5))
               B = Val(cmdsplit(6))
               If Tmpb < Tmpb2 Then
                 For K = Tmpb To Tmpb2
                    Rb_setcolor K , Color(1)
                 Next
               Else
                 For K = Tmpb2 To Tmpb
                    Rb_setcolor K , Color(1)
                 Next
               End If
               Rb_send
               Atsnd = "Se conf Rango " + Str(tmpb) + " a R=" + Str(r) + ", G=" + Str(g) + ", B=" + Str(b)
            Else
               Cmderr = 4
            End If

         Case "SETFIL"
            If Numpar = 4 Then
               Cmderr = 0
               R = Val(cmdsplit(2))
               G = Val(cmdsplit(3))
               B = Val(cmdsplit(4))
               Atsnd = "Tira llenada con " + "R=" + Str(r) + ", G=" + Str(g) + ", B=" + Str(b)
               Rb_fill Color
            Else
               Cmderr = 4
            End If

         Case "CLRFIL"
            Cmderr = 0
            Atsnd = "Apaga leds"
            Rb_clearstripe

         Case "CLRCOL"
            Cmderr = 0
            Atsnd = "cLEAR cOLORS"
            Rb_clearcolors
            Rb_send

         Case "SETBUZ"
            If Numpar = 3 Then
               Cmderr = 0
               Tmpw = Val(cmdsplit(2))
               Tmpw2 = Val(cmdsplit(3))
               Atsnd = "Test Buzzer D=" + Str(tmpw) + ", P=" + Str(tmpw2)
               Sound Buzzer , Tmpw , Tmpw2

            Else
               Cmderr = 4
            End If

         Case Else
            Cmderr = 1

      End Select

   Else
        Cmderr = 2
   End If

   If Cmderr > 0 Then
      Atsnd = Lookupstr(cmderr , Tbl_err)
   End If

   Print #1 , Atsnd

End Sub



'*******************************************************************************
'TABLA DE DATOS
'*******************************************************************************

Tbl_err:
Data "OK"                                                   '0
Data "Comando no reconocido"                                '1
Data "Longitud comando no valida"                           '2
Data "Numero de usuario no valido"                          '3
Data "Numero de parametros invalido"                        '4
Data "Error longitud parametro 1"                           '5
Data "Error longitud parametro 2"                           '6
Data "Parametro no valido"                                  '7
Data "ERROR8"                                               '8
Data "ERROR SD. Intente de nuevo"                           '9

Tabla_estado:
Data &B00000000000000000000000000000000&                    'Estado 0
Data &B00000000000000000000000000000011&                    'Estado 1
Data &B00000000000000000000000000110011&                    'Estado 2
Data &B00000000000000000000001100110011&                    'Estado 3
Data &B00000000000000000011001100110011&                    'Estado 4
Data &B00000000000000110011001100110011&                    'Estado 5
Data &B00000000000011001100000000110011&                    'Estado 6
Data &B00001111111111110000111111111111&                    'Estado 7
Data &B01010101010101010101010101010101&                    'Estado 8
Data &B00110011001100110011001100110011&                    'Estado 9
Data &B01110111011101110111011101110111&                    'Estado 10
Data &B11111111111111000000000000001100&                    'Estado 11
Data &B11111111111111000000000011001100&                    'Estado 12
Data &B11111111111111000000110011001100&                    'Estado 13
Data &B11111111111111001100110011001100&                    'Estado 14
Data &B11111111111111000000000000001100&                    'Estado 15
Data &B11111111111111111111111111110000&                    'Estado 16

Tbl_col:
Data &B11111110                                             '1 X0
Data &B11111101                                             '2 X1
Data &B11111011                                             '3 X2
Data &B11110111                                             '4 X3

Tblseed:
Data 755%
Data 794%
Data 381%
Data 580%
Data 495%
Data 750%
Data 305%
Data 288%
Data 931%
Data 762%
Data 133%
Data 284%
Data 111%
Data 934%
Data 945%
Data 328%
Data 826%
data 539%
Data 664%
Data 172%
Data 639%
Data 310%
Data 81%


$include "Font16x16.font"

Loaded_arch: