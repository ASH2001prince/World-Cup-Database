#!/bin/bash


if [[ $1 == "test" ]]
then
PSQL="psql -h localhost -U postgres -d worldcup -p 5432 --no-align --tuples-only -c"
else
PSQL="psql -h localhost -U postgres -d worldcup -p 5432 --no-align --tuples-only -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.




echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do   

# ************** THE FIRST PART ****************************


        # Insert teams table data

    # Deleting the first line by taking the first value from the first line
    if [[ $WINNER != "winner" ]]
        then
        
            # get team_id from winner by naming the var as "TEAM1_NAME"
            TEAM1_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        # if not found
            if [[ -z $TEAM1_NAME ]]
                then 
                    # insert team
                    INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

                # Display the result
                if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
                    then 
                    echo INSERT TEAM $WINNER
                fi

            fi
    fi


# ******************* THE SECOND PART ***********************


    # Get opponent team name
    if [[ $OPPONENT != "opponent" ]]
        then 

            # get the team from the opponent column 
            TEAM2_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

            # if it's not found
            if [[ -z $TEAM2_NAME ]]
                then 
                    # Insert the team from the opponent
                    INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            fi

            # Display the result
            if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
                then 
                    echo INSERT TEAM $OPPONENT
            fi
        
fi

# ************************ THE THIRD PART ****************************

    # INSERT games table data

    # Excluding the names row
    if [[ $YEAR != "year" ]]
        then

            # Getting the team_id from the winner column
            WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
            # Getting the team_id from the opponent column 
            OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")


 
            # Insert the games table 
            INSERT_GAME_TABLE=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

            if [[ $INSERT_GAME_TABLE == "INSERT 0 1" ]]
                then 
                    echo "INSERT GAME $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
            fi 

    fi

done

# WHAT A GREAT PROJECT ******