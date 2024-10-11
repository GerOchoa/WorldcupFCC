#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Limpiar tablas para iniciar en cero
$PSQL "TRUNCATE TABLE games, teams;"

# Insert equipos unicos
cat games.csv | tail -n +2 | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
    # Insertar equipos en tabla en caso de no existir
    for team in "$winner" "$opponent"; do
        $PSQL "INSERT INTO teams (name) VALUES ('$team') ON CONFLICT (name) DO NOTHING;"
    done
done

# Insertar partidos
cat games.csv | tail -n +2 | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")

    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);"
done