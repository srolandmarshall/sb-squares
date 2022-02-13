require 'csv'
require 'roo'
require 'pry'

def scores
  puts 'Who is the AFC contender?'
  afc_name = gets.strip

  puts 'Who is the NFC contender?'
  nfc_name = gets.strip
  { afc: afc_name, nfc: nfc_name }
end

def players
  players_list = []
  puts 'How Many Players?'
  num_players = gets.strip.to_i
  num_players.times do |index|
    puts "Enter name for player #{index + 1}:"
    player_name = gets.strip
    puts 'How many squares?'
    player_sqs = gets.strip.to_i
    index += 1
    players_list << { name: player_name, sqs: player_sqs }
  end
  players_list
end

def players_check(players_list)
  players_list_accurate = false
  until players_list_accurate
    total_sqs = 0
    players_list.each do |player|
      total_sqs += player[:sqs]
    end
    if total_sqs != 100
      puts "You don't have enough squares, do your math again"
      players_list = players
    else
      players_list_accurate = true
      return players_list
    end
  end
end

# returns a hash of players and their squares
def import_csv(path)
  players_list = {}
  puts "Importing #{path}..."
  sheet = CSV.read(path, headers: true)
  sheet.each do |row|
    players_list[row['name']] = row['sqs'].to_i
  end
end

def print_csv(squares_array, teams)
  puts 'Printing Squares...'
  top_row = []
  nums = Array.new([*0..9])
  top_row << "Across: #{teams[:afc]}\nDown: #{teams[:nfc]}"
  top_row += nums
  CSV.open('squares.csv', 'w') do |csv|
    csv << top_row
    count = 0
    squares_array.each do |list|
      csv << list.unshift(nums[count])
      count += 1
    end
  end
end

def squares
  teams = scores
  done = false
  until done
    puts 'Manual Entry or CSV? (type M or CSV)'
    input = gets.strip
    case input.upcase
    when 'M'
      @players_list = players
      players_list = players_check(players_list)
      done = true
    when 'CSV'
      @players_list = import_csv('./players.csv')
      done = true
    else
      puts 'Type either M or CSV'
    end
  end
  squares_list = []
  @players_list.each do |player|
    squares_list += Array.new(player['sqs'].to_i, player['name'])
  end
  squares_list.shuffle!
  squares_array = squares_list.each_slice(10).to_a
  print_csv(squares_array, teams)
end

squares
