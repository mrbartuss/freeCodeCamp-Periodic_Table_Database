#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]];
then
  echo "Please provide an element as an argument."
  exit
fi

INPUT=$1

# if input is string
if [[ ! $INPUT =~ ^[0-9]+$ ]];
then
  ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';") | sed 's/ //g')
else
#if input is number
  ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT;") | sed 's/ //g')
fi

# if the argument input doesn't exist as an atomic_number, symbol, or name in the database
if [[ -z $ATOMIC_NUMBER ]];
then
  echo "I could not find that element in the database."
else
  NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER") | sed 's/ //g')
  SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER") | sed 's/ //g')
  TYPE=$(echo $($PSQL "SELECT type FROM types JOIN properties USING(type_id) JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER") | sed 's/ //g')
  MASS=$(echo $($PSQL "SELECT atomic_mass FROM properties JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER") | sed 's/ //g')
  MELTING_POINT=$(echo $($PSQL "SELECT melting_point_celsius FROM properties JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER") | sed 's/ //g')
  BOILING_POINT=$(echo $($PSQL "SELECT boiling_point_celsius FROM properties JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER") | sed 's/ //g')

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
