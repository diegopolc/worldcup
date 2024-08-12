#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEARS ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #GET WINNER ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #IF NOT FOUND
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $INSERT_WINNER_RESULT="INSERT 0 1" ]]
      then
      echo Inserted into Teams, $WINNER
      fi
    fi
    #GET NEW WINNER ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #GET OPPONENT ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
   #IF NOT FOUND
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT="INSERT 0 1" ]]
      then
      echo Inserted into Teams, $OPPONENT
      fi
    fi
    #GET NEW OPPONENT ID
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

   INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEARS, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNERGOALS, $OPPONENTGOALS)")
    if [[ $INSERT_GAME="INSERT 0 1" ]]
    then
      echo Inserted game
    fi
  fi
done