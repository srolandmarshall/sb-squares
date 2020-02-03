require 'csv'
require 'pry'

def scores

  puts "Who is the AFC contender?"
  afc_name = gets.strip

  puts "Who is the NFC contender?"
  nfc_name = gets.strip
  nums = Array.new([*0..9])
  return {afc: nums.shuffle, afc_name: afc_name, nfc: nums.shuffle, nfc_name: nfc_name}
end

def players
  players_list = []
  puts "How Many Players?"
  num_players = gets.strip
  num_players = num_players.to_i
  count = 1
  num_players.times do |player|
    puts "Enter name for player "+count.to_s+": "
    player_name = gets.strip
    puts "How many squares?"
    player_sqs = gets.strip.to_i
    count+=1
    players_list << {name: player_name, sqs: player_sqs}
  end
  return players_list
end

def players_check(players_list)
  players_list_accurate = false
  while (!players_list_accurate)
    total_sqs = 0
    players_list.each do |player|
      total_sqs+=player[:sqs]
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

def print_csv(squares_array, teams)
  top_row = teams[:afc]
  top_row.unshift(teams[:afc_name]+" to the Right\n"+teams[:nfc_name]+" listed down")
  CSV.open('squares.csv','w') do |csv|
    csv << top_row
    count = 0
    squares_array.each do |list|
      csv << list.unshift(teams[:nfc][count])
      count+=1
    end
  end
end

def squares
  teams = scores
  players_list = players
  players_list = players_check(players_list)
  squares_list = []
  players_list.each do |player|
    player[:sqs].times do |sq|
      squares_list << player[:name]
    end
  end
  squares_list.shuffle!
  squares_array = squares_list.each_slice(10).to_a
  print_csv(squares_array, teams)
end



squares
