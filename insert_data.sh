#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WIN OPP WG OPPG
do
  if [[ $YEAR != "year" ]]
  then
    #get win_id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    
    if [[ -z $WIN_ID ]]
    then
      INSERT_WIN_RESULT=$($PSQL "INSERT INTO teams (name) values ('$WIN')")
      echo $INSERT_WIN_RESULT

      #get new team_win id
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WIN'")

    fi

    #get opp_id
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    if [[ -z $OPP_ID ]]
    then
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams (name) values ('$OPP')")
      echo $INSERT_OPP_RESULT

      #get new team_opp id
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPP'")
    fi

    #insert data in games table
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WG, $OPPG)")
    echo $INSERT_GAMES_RESULT
    
  fi
done