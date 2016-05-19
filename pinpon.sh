#!/bin/bash

CARACTERBORDE="/"
PRIMERFILA=0                              # First row of game area
PRIMERCOLUMNA=0                              # First col of game area
ULTIMACOLUMNA=$( tput cols )                            # Last col of game area
ULTIMAFILA=$( tput lines - 1 ) 
RAQUETA="_____"
RAQUETAX=$(( $ULTIMACOLUMNA / 2 - 3 ))
RAQUETAY=$(( $ULTIMAFILA / 2 + 5 ))

NUMRECORRER=2
dibujarRAQUETA(){
    y=$1
    x=$2
    tput cup $y $x 
    printf %b "$RAQUETA"
}

dibujarbordes() {
   # Draw top
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

typeset -i bandera
	bandera=0
    
clear
tput civis #oculta el cursor
tput bold
dibujarbordes
dibujarRAQUETA $RAQUETAY $RAQUETAX
while [ $bandera == 0 ]
	do
		read -s -n 1 key
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
    x)   bandera=1
            tput cvvis #Oculta el cursor
            stty echo
            tput reset
            
            ;;
   esac
	done
