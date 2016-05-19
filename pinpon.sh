#!/bin/bash

CARACTERBORDE="/"
PRIMERFILA=0                             
PRIMERCOLUMNA=0                              
ULTIMACOLUMNA=$( tput cols )                            
ULTIMAFILA=$( tput lines - 1 ) 
RAQUETA="///////"
RAQUETAX=$(( $ULTIMACOLUMNA / 2 - 3 ))
RAQUETAY=$(( $ULTIMAFILA / 2 + 5 ))
PELOTA="O"
PELOTAX=$(( $RAQUETAX + ${#RAQUETA} / 2 ))
PELOTAY=$(( $RAQUETAY - 1 ))
DIRECCIONPELOTAX=-10
DIRECCIONPELOTAY=-1
NUMRECORRER=2
dibujarRAQUETA(){
    y=$1
    x=$2
    tput cup $y $x 
    printf %b "$RAQUETA"
}

dibujarbordes() {
   # Dibujar borde superior
   tput setf 6
   tput cup 0 0
   x=$PRIMERCOLUMNA
   while [ "$x" -lt "$ULTIMACOLUMNA" ];
   do
      printf %b "$CARACTERBORDE"
      x=$(( $x + 1 ));
   done

   # Draw bottom
   tput cup $ULTIMAFILA $PRIMERCOLUMNA
   x=$PRIMERCOLUMNA
   while [ "$x" -lt  $ULTIMACOLUMNA ];
   do
      printf %b "$CARACTERBORDE"
      x=$(( $x + 1 ));
   done
   tput setf 9
}

toqueBORDE(){
        tput cup $PELOTAY $PELOTAX
        tput ech ${#PELOTA} #borrar cierto numero de caracteres
        auxNum=$(( $RAQUETAX - 1 ))
        if (( auxNum >= 0)); then
            RAQUETAX=$auxNum
        fi
        dibujarRAQUETA $RAQUETAY $RAQUETAX
}
moverPELOTA(){
    tput cup $PELOTAY $0
    #tput ech ${#PELOTA}
    tput el 
    dibujarRAQUETA $RAQUETAY $RAQUETAX
    
    if(( $DIRECCIONPELOTAX == - 10 ));then
         VARIABLE=`echo $(($RANDOM % 2))`
        case "$VARIABLE" in
            0)  DIRECCIONPELOTAX=-1  ;;
            1)  DIRECCIONPELOTAX=1   ;;
        esac
     else
        if(( $PELOTAY == 1 || $PELOTAY == $ULTIMAFILA - 2 ));then
            DIRECCIONPELOTAY=$(( $DIRECCIONPELOTAY * - 1 ))
            VARIABLE=`echo $(($RANDOM % 2))`
            case "$VARIABLE" in
                0)   DIRECCIONPELOTAX=-1   ;;
                1)   DIRECCIONPELOTAX=1;;
            esac
        else
            aux=$(( $PELOTAY + $DIRECCIONPELOTAY ))
            
             if(( $aux == $RAQUETAY )); then
                    if(( $PELOTAX <= $RAQUETAX + 7  && $PELOTAX >= $RAQUETAX - 1 ));then
                    DIRECCIONPELOTAY=$(( $DIRECCIONPELOTAY * - 1 )) #cambiar direccion de Y
                    VARIABLE=`echo $(($RANDOM % 2))`
                    case "$VARIABLE" in
                        0)  
                        DIRECCIONPELOTAX=-1  ;;
                        1)   
                        DIRECCIONPELOTAX=1   ;;
                    esac
                fi
            fi
        fi #fin de if(( $PELOTAY == 1 || $PELOTAY == $ULTIMAFILA - 2 ))
    fi #fin de if(( $DIRECCIONPELOTAX == - 10 ))
   
    
   if(( $PELOTAX == 1 ));then 
        PELOTAX=$(( $ULTIMACOLUMNA - 1 ))
     else
     if(( $PELOTAX >= $ULTIMACOLUMNA ));then
        PELOTAX=1
     fi
   fi
   PELOTAX=$(( $PELOTAX + $DIRECCIONPELOTAX ))
   PELOTAY=$(( $PELOTAY + $DIRECCIONPELOTAY ))
        
   tput cup $PELOTAY $PELOTAX
    printf %b "$PELOTA"
}

typeset -i bandera
	bandera=0
    
clear
tput civis #oculta el cursor
tput bold #Modo negritas
dibujarbordes
dibujarRAQUETA $RAQUETAY $RAQUETAX
tput cup $PELOTAY $PELOTAX
    printf %b "$PELOTA"
#Ejecucion principal o main
while [ $bandera == 0 ]
	do
        moverPELOTA && read -s -n 1 -t 0.3 key
        
    case "$key" in
    a)  
        tput cup $RAQUETAY $RAQUETAX
        tput ech ${#RAQUETA} #borrar cierto numero de caracteres
        auxNum=$(( $RAQUETAX -  $NUMRECORRER ))
        if (( auxNum >= 0)); then
            RAQUETAX=$auxNum
        fi
        dibujarRAQUETA $RAQUETAY $RAQUETAX
      ;;
    d)   
        tput cup $RAQUETAY $RAQUETAX
        tput ech ${#RAQUETA} #borrar cierto numero de caracteres
        auxNum=$(( $RAQUETAX +  $NUMRECORRER ))
        if (( auxNum < $ULTIMACOLUMNA - ${#RAQUETA} )); then
            RAQUETAX=$auxNum
        fi
        dibujarRAQUETA $RAQUETAY $RAQUETAX
        ;;
    x|X)   bandera=1
            tput cvvis #Oculta el cursor
            stty echo
            tput reset
            
      ;;
   esac
   done
