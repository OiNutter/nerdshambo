const readline = require("readline")

function loadLogic(path) {
  return require(path)
}

function playGame(logic) {
  const weapons = Object.keys(logic),
        rl = readline.createInterface({
          input: process.stdin,
          output: process.stdout
        })

  console.log("=== WEAPONS ===")
  weapons.forEach((w) => {
    console.log(`${w}: ${logic[w]['name']}`)
  })

  let choice
  rl.question("Please choose your weapon >", (w) => {
    choice = w
    rl.close()
  })

  rl.on('close', () => {

    if (weapons.includes(choice)) {

      const chosen = logic[choice],
            randIndex = Math.floor(Math.random() * weapons.length),
            computer = weapons[randIndex],
            computerWeapon = logic[computer]

      console.log(`\nYou: ${chosen['name']}`)
      console.log(`Computer: ${computerWeapon['name']}\n`)

      if (computer in chosen['beats']) {
        console.log('===============')
        console.log('=== YOU WIN ===')
        console.log(
          `${chosen['name']} ${chosen['beats'][computer]} ${computerWeapon['name']}`
        )
        console.log('===============\n')
      } else if (choice in computerWeapon['beats']) {
        console.log('================')
        console.log('=== YOU LOSE ===')
        console.log(
          `${computerWeapon['name']} ${computerWeapon['beats'][choice]} ${chosen['name']}`
        )
        console.log('================\n')
      } else {
        console.log("============")
        console.log("=== DRAW ===")
        console.log("============\n")
      }

      setTimeout(() => {
        playGame(logic)
      }, 1000)

    } else {
      console.log("Please enter a valid weapon!")
    }

  })

}

const logic_file = process.argv[2]

const logic = loadLogic(logic_file)

playGame(logic)
