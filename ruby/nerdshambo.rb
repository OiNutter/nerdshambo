require 'json'

logic_file = ARGV[0]

def load_logic(path)

  file = File.read(path)
  return JSON.parse(file)
end

def play_game(logic)

  weapons = logic.keys()
  puts "=== Weapons ==="
  for key in weapons
    puts "%s: %s" % [key, logic[key]['name']]
  end

  puts "Please choose your weapon >"
  choice = STDIN.gets.chomp.strip

  if weapons.include?(choice) then
    chosen = logic[choice]
    computer = weapons.sample
    computer_weapon = logic[computer]

    puts "You: %s" % chosen['name']
    puts "Computer: %s\n\n" % computer_weapon['name']

    if chosen['beats'].include?(computer) then
      puts "==============="
      puts "=== YOU WIN ==="
      puts "%s %s %s" % [
        chosen['name'],
        chosen['beats'][computer],
        computer_weapon['name']
      ]
      puts "===============\n\n"
    elsif computer_weapon['beats'].include?(choice) then
      puts "================"
      puts "=== YOU LOSE ==="
      puts "%s %s %s" % [
        computer_weapon['name'],
        computer_weapon['beats'][choice],
        chosen['name']
      ]
      puts "================\n"
    else
      puts "============"
      puts "=== DRAW ==="
      puts "============\n\n"
    end

  else
    puts "Please select a valid weapon!"
  end

end

if File.exists?(logic_file) then
  logic = load_logic(logic_file)

  while true
    play_game(logic)
    sleep(1)
  end

else
  puts("Couldn't find logic file")
end
