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

moverPELOTA(){
    VARIABLE=`echo $(($RANDOM % 2))`
    tput cup $PELOTAY $PELOTAX
    tput ech ${#PELOTA}
    VARIABLE=0
    case "$VARIABLE" in
    0)  
        PELOTAX=$(( $PELOTAX - 1 ))
        PELOTAY=$(( $PELOTAY - 1 ))
        ;;
    1)   
        PELOTAY=$(( $PELOTAY - 1 ))
        ;;
    2)   
        PELOTAX=$(( $PELOTAX + 1 ))
        PELOTAY=$(( $PELOTAY - 1 ))
        ;;
   esac
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
        moverPELOTA
		read -s -n 1 -t 0.2 key
        
    case "$key" in
    a|A)  
        tput cup $RAQUETAY $RAQUETAX
        tput ech ${#RAQUETA} #borrar cierto numero de caracteres
        auxNum=$(( $RAQUETAX -  $NUMRECORRER ))
        if (( auxNum >= 0)); then
            RAQUETAX=$auxNum
        fi
        dibujarRAQUETA $RAQUETAY $RAQUETAX
      ;;
    d|D)   
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
