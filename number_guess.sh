#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

AVAIL_USERNAME=$($PSQL "SELECT USERNAME FROM users WHERE username='$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT MIN(num_of_guesses) FROM users INNER JOIN games USING(user_id) WHERE username='$USERNAME'")

if [[ -z $AVAIL_USERNAME ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# get random number
RANDOM_NUM=$((1 + $RANDOM % 1000))
GUESS_COUNT=1
echo "Guess the secret number between 1 and 1000:"

# check if input matches with random number
while read NUMBER
do
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $NUMBER -eq $RANDOM_NUM ]]
    then
      break;
    else
      if [[ $NUMBER -gt $RANDOM_NUM ]]
      then
        echo -n "It's lower than that, guess again:"
      elif [[ $NUMBER -lt $RANDOM_NUM ]]
      then
        echo -n "It's higher than that, guess again:"
      fi
    fi
  fi
  GUESS_COUNT=$(( $GUESS_COUNT + 1))
done

if [[ $GUESS_COUNT == 1 ]]
then
  echo "You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NUM. Nice job!"
else
  echo "You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NUM. Nice job!"
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
INSERT_GAME=$($PSQL "INSERT INTO games(num_of_guesses, user_id) VALUES($GUESS_COUNT, $USER_ID)")
