# Super Squares

## A Quick Ruby Script to Make Squares 

### Only Requires Ruby!

## How to Run
1. `git clone` this repo somewhere
2. `ruby sb-squares/squares.rb`
3. Follow the prompts.
4. Prints out a `squares.csv` that should be openable in any spreadsheet software.


**That's it!**
## Entry Modes
1. CSV
   - Create a CSV in the same format as `players.csv` with two columns: `players` and `sqs`
   - **OR**
   - Create a spreadsheet like so

      | players | sqs |
      --------|------
      | Player 1 | 10 |
      | Player 2 | 10 |
      | Player 3 | 10 |
      | Player 4 | 10 |

   - Export to CSV as `players.csv` in the same folder as the `squares.rb` file and overwrite the test file.


2. Manual Entry
   - Enter Player name then number of squares desired
   - Will automatically stop when total reaches 100
   - Example:
      ```
      Manual Entry or CSV? (type M or CSV)
      > M
      Enter Player Name and Number of Squares
      Total Squares so far: 0
      Player Name:
      > Sam
      Number of Squares:
      > 10
      Total Squares so far: 10
      Player Name:
      > Matt   
      Number of Squares:
      > 10
      Total Squares so far: 20
      ....
      ```

## Miscellaneous & Warnings

- It has error catching along the way, so you shouldn't be able to enter square totals that don't `== 100`. If you want blank squares, just enter a blank space (`" "`) for name and the number of blank squares desired (works the same for CSV and Manual entry).
- Script will overwrite `squares.csv` that's in the same folder as it **without warning**. If you want to make multiple make sure you copy or rename your squares file when it's output. 
- In case you didn't know, `CTRL+C` is how you exit most command line apps.


## Good luck, have fun, see you next February.
