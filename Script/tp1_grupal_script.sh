#!/bin/bash
parametro=$1
if [[ $parametro == "-d" && -d "$HOME/EPNro1" ]]; then
  rm -r "$HOME/EPNro1/"*
  pkill -f "$HOME/EPNro1/consolidar.sh"
fi

opcion=0
while [ $opcion -ne 6 ]
do
  echo "---MENU---"
  echo "1) Crear entorno"
  echo "2) Correr proceso"
  echo "3) Listado de alumnos por padron"
  echo "4) Top 10 notas"
  echo "5) Soliciar numero nuevo de padròn"
  echo "6) Salir"
  echo -n "Ingrese una opcion: "
read opcion

if [[ $opcion -gt 6 || $opcion -le  0 ]]; then
  echo "Ingresa un valor del 1 al 6"
fi

case $opcion in
  1)
    echo "Creando carpetas..."
    mkdir -p "$HOME/EPNro1"
    mkdir -p "$HOME/EPNro1/entrada" "$HOME/EPNro1/salida" "$HOME/EPNro1/procesado"
    touch "$HOME/EPNro1/salida/$FILENAME.txt"
    ;;
  2)
    if [ -d "$HOME/EPNro1" ]; then
      touch "$HOME/EPNro1/consolidar.sh"
      echo "
       #!/bin/bash
       cat $HOME/EPNro1/entrada/* >> $HOME/EPNro1/salida/$FILENAME.txt
       mv $HOME/EPNro1/entrada/* $HOME/EPNro1/procesado
      ">$HOME/EPNro1/consolidar.sh
      bash "$HOME/EPNro1/consolidar.sh" &
    fi
    ;;
  3)
    echo "Alumnos ordenados por padron: "
    if [[ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]]; then
      #Ordeno $FILENAME numericamente por padron
      sort -n "$HOME/EPNro1/salida/$FILENAME.txt"
    else
      echo "El archivo $FILENAME no existe."
    fi
    ;;
  4)
    if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
      echo "Top 10 notas: "
      #Ordeno en base a la columna 4, numericamente, descendentemente y muestro solo las primeras 10 lineas.
      sort -k 5 -n -r "$HOME/EPNro1/salida/$FILENAME.txt" | head -n 10
    else
      echo "No existe el archivo $FILENAME"
    fi
    ;;
  5)
    if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
      echo -n "Ingrese numero de padron: "
      read padron
      grep $padron "$HOME/EPNro1/salida/$FILENAME.txt" || echo "No se encontro $padron"
    else
      echo "No existe el archivo $FILENAME"
    fi
    ;;
esac

done
