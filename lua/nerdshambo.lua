lunajson = require 'lunajson'

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function loadLogic(path)
  local contents = ""
  local logic = {}
  local file = io.open( path, "r" )

  if file then
    -- read all contents of file into a string
    local contents = file:read( "*a" )
    logic = lunajson.decode(contents)
    io.close( file )
    return logic
  end
  return nil
end

function playGame(logic)

  local weapons = {}
  local n = 0

  print("=== Weapons ===")
  for k, x in pairs(logic) do
    n = n+1
    weapons[n] = k
    print(k .. ": " .. logic[k]['name'])
  end

  io.write( "Please choose your weapon> " )
  local choice = io.read()

  if logic[choice] then
    local chosen = logic[choice]
    local computer = weapons[ math.random(#weapons) ]
    local computerWeapon = logic[computer]

    print("\nYou: " .. chosen['name'])
    print("Computer: " .. computerWeapon['name'] .. "\n")

    if chosen['beats'][computer] then
      print("===============")
      print("=== YOU WIN ===")
      print(
        chosen['name'] ..
        " " ..
        chosen['beats'][computer] ..
        " " ..
        computerWeapon['name']
      )
      print("===============\n")
    elseif computerWeapon['beats'][choice] then
      print("================")
      print("=== YOU LOSE ===")
      print(
        computerWeapon['name'] ..
        " " ..
        computerWeapon['beats'][choice] ..
        " " ..
        chosen['name']
      )
      print("================\n")
    else
      print("============")
      print("=== DRAW ===")
      print("============\n")
    end

  end
end

logic_file = arg[1]

logic = loadLogic(logic_file)

if logic then

  while true do
    playGame(logic)
    sleep(1)
  end

end
