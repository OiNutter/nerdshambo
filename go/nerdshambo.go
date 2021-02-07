package main

import (
  "fmt"
  "os"
  "encoding/json"
  "io/ioutil"
  "math/rand"
  "time"
)

type Weapon struct {
  Name  string            `json:"name"`
  Beats map[string]string `json:"beats"`
}

func (w *Weapon) canBeat(opponent string) bool {
  _, ok := w.Beats[opponent]
  return ok
}

func (w *Weapon) getMethod(opponent string) string {
  if method, ok := w.Beats[opponent]; ok {
    return method
  } else {
    return ""
  }
}

func loadLogic(path string) map[string]Weapon {
  // Open our jsonFile
  jsonFile, err := os.Open(path)

  // if we os.Open returns an error then handle it
  if err != nil {
    fmt.Println(err)
  }

  // defer the closing of our jsonFile so that we can parse it later on
  defer jsonFile.Close()

  // read our opened jsonFile as a byte array.
  byteValue, _ := ioutil.ReadAll(jsonFile)

  // we initialize our Users array
  var logic map[string]Weapon

  // we unmarshal our byteArray which contains our
  // jsonFile's content into 'users' which we defined above
  json.Unmarshal(byteValue, &logic)

  return logic
}

func playGame(logic map[string]Weapon) {
  fmt.Println("=== Weapons ===")

  weapons := make([]string, 0, len(logic))
  for k := range logic {
    weapons = append(weapons, k)
    fmt.Println(fmt.Sprintf("%s: %s", k, logic[k].Name))
  }

  var choice string
  fmt.Println("Please choose your weapon >")
  fmt.Scanln(&choice)

  if chosen, ok := logic[choice]; ok {

    index := rand.Intn(len(weapons))
    computer := weapons[index]
    computerWeapon := logic[computer]

    fmt.Println(
      fmt.Sprintf(
        "\nYou: %s",
        chosen.Name,
      ),
    )
    fmt.Println(
      fmt.Sprintf(
        "Computer: %s\n",
        computerWeapon.Name,
      ),
    )

    if chosen.canBeat(computer) {
      fmt.Println("===============")
      fmt.Println("=== YOU WIN ===")
      fmt.Println(
        fmt.Sprintf(
          "%s %s %s",
          chosen.Name,
          chosen.getMethod(computer),
          computerWeapon.Name,
        ),
      )
      fmt.Println("===============\n")
    } else if (computerWeapon.canBeat(choice)) {
      fmt.Println("================")
      fmt.Println("=== YOU LOSE ===")
      fmt.Println(
        fmt.Sprintf(
          "%s %s %s",
          computerWeapon.Name,
          computerWeapon.getMethod(choice),
          chosen.Name,
        ),
      )
      fmt.Println("================\n")
    } else {
      fmt.Println("============")
      fmt.Println("=== DRAW ===")
      fmt.Println("============\n")
    }

  } else {
    fmt.Println("Please choose a valid weapon!")
  }
}

func main() {
  logic_file := os.Args[1]

  logic := loadLogic(logic_file)

  for {
    playGame(logic)
    time.Sleep(time.Second)
  }


}
