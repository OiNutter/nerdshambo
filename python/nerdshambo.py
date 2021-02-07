import sys
import os
import json
import time
import random

def load_logic(path):
    with open(path, 'r') as f:
        try:
            return json.load(f)
        except Exception as e:
            print("got %s on json.load()" % e)

def play_game(logic):
    weapons = list(logic.keys())

    print ("=== Weapons ===")
    for key in weapons:
        print("%s: %s" % (key, logic[key]["name"]));

    choice = input("Please choose your weapon >")


    if choice in logic:
        computer = random.choice(weapons)
        chosen = logic[choice]
        computer_weapon = logic[computer]

        print("You: %s" % chosen["name"])
        print("Computer: %s\n" % computer_weapon["name"])

        if computer in chosen["beats"]:
            print("===============");
            print("=== YOU WIN ===");
            print(
                "%s %s %s" % (
                    chosen["name"],
                    chosen["beats"][computer],
                    computer_weapon["name"]
                )
            );
            print("===============\n");
        elif choice in computer_weapon["beats"]:
            print("================");
            print("=== YOU LOST ===");
            print(
                "%s %s %s" % (
                    computer_weapon["name"],
                    computer_weapon["beats"][choice],
                    chosen["name"]
                )
            );
            print("================\n");
        else:
            print("============");
            print("=== DRAW ===");
            print("============\n");
    else:
        print("Please choose a valid weapon!")



logic_file = sys.argv[1]

if os.path.exists(logic_file) and os.path.isfile(logic_file):

    logic = load_logic(logic_file)

    while True:
        play_game(logic)
        time.sleep(1)

else:

    print("LOGIC FILE NOT FOUND!")
