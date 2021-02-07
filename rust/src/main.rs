use std::io;
use std::io::Write;
use std::env;
use std::error::Error;
use std::path::Path;
use std::fs::File;
use std::io::BufReader;
use std::collections::HashMap;
use std::{thread, time};

use serde::{Deserialize, Serialize};
use rand::seq::SliceRandom;

#[derive(Debug, Deserialize, Serialize)]
struct Weapon {
    name: String,
    beats: HashMap<String, String>
}

impl Weapon {
    fn can_beat(&self, weapon: &str) -> bool {
        return self.beats.contains_key(weapon);
    }

    fn get_method(&self, weapon: &str) -> String {
        if self.beats.contains_key(weapon) {
            return self.beats.get(weapon).unwrap().to_string();
        } else {
            return "".to_string();
        }
    }
}

fn load_logic<P: AsRef<Path>>(path: P) -> Result<HashMap<String, Weapon>, Box<dyn Error>> {
    let file = File::open(path)?;
    let reader = BufReader::new(file);
    let obj: HashMap<String, Weapon> = serde_json::from_reader(reader).unwrap();
    Ok(obj)
}

fn play_game(logic: &HashMap<String, Weapon>) {

    let weapons:Vec<String> = logic.keys()
        .map(|k|k.clone())
        .collect();

    println!("=== Weapons ===");
    for key in &weapons {

        println!("{}: {}", key, logic.get(key).unwrap().name);
    }

    // Print command prompt and get command
    print!("Please choose your weapon > ");
    io::stdout().flush().expect("Couldn't flush stdout");

    let mut input = String::new(); // Take user input (to be parsed as clap args)
    io::stdin().read_line(&mut input).expect("Error reading input.");
    input = input.trim().to_string();

    if !logic.contains_key(&input) {
        println!("Please choose a valid weapon!");
    } else {

        let chosen:&Weapon = logic.get(&input).unwrap();

        let computer = weapons.clone().choose(&mut rand::thread_rng()).unwrap().clone();
        let computer_weapon:&Weapon = logic.get(&computer).unwrap();

        println!("You: {}", chosen.name);
        println!("Computer: {}\n", computer_weapon.name);

        if chosen.can_beat(&computer) {
            println!("===============");
            println!("=== YOU WIN ===");
            println!(
                "{} {} {}",
                chosen.name,
                chosen.get_method(&computer),
                computer_weapon.name
            );
            println!("===============");
        } else if computer_weapon.can_beat(&input) {
            println!("================");
            println!("=== YOU LOSE ===");
            println!(
                "{} {} {}",
                computer_weapon.name,
                computer_weapon.get_method(&input),
                chosen.name
            );
            println!("================");
        } else {
            println!("============");
            println!("=== DRAW ===");
            println!("============");
        }

        println!("\n\n");
    }
}

fn main(){

    let args: Vec<String> = env::args().collect();
    let logic_file = &args[1];
    let logic:HashMap<String, Weapon> = load_logic(logic_file).unwrap();

    loop {
        play_game(&logic);

        thread::sleep(time::Duration::from_secs(1));
    }

}
