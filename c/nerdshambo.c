// Standard Libs
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

// Local Libs
#include <cjson/cJSON.h>

//Prototypes
cJSON *load_logic(char path[]);
void play_game(cJSON *logic);

int main(int argc, char *argv[]) {

  // Check path to logic file has been supplied
  if (argc < 2) {
    printf("Please supply a config file.\n");
    return 1;
  }

  long n = strlen(argv[1]);
  char *logic_file = argv[1];

  // Load json logic file
  cJSON *logic = load_logic(logic_file);

  if (logic) {
    play_game(logic);
  } else {
    printf("Logic file could not be found!\n");
    return 2;
  }
}

cJSON *load_logic(char path[]) {
  char * buffer = 0;
  long length;
  FILE * f = fopen (path, "rb");

  // Read entire file contents into buffer
  if (f) {
    fseek (f, 0, SEEK_END);
    length = ftell (f);
    fseek (f, 0, SEEK_SET);
    buffer = malloc (length);
    if (buffer) {
      fread (buffer, 1, length, f);
    }
    fclose (f);
  }

  // If we have a buffer then parse it
  if (buffer) {
    cJSON *json = cJSON_Parse(buffer);
    return json;
  }

  return NULL;
}

void play_game(cJSON *logic) {

  // Initialise random number generator
  time_t t;
  srand((unsigned) time(&t));

  // Repeat until user quits program with CTRL+C
  while (1) {

    // Print out weapons list
    printf("=== Weapons ===\n");

    const cJSON *weapon = NULL;
    int n = cJSON_GetArraySize(logic);
    char* weapons[n];
    int i = 0;

    cJSON_ArrayForEach(weapon, logic) {
      char *key = weapon->string;
      cJSON *name = cJSON_GetObjectItemCaseSensitive(weapon, "name");
      printf("%s: %s\n", key, cJSON_GetStringValue(name));
      weapons[i] = key;
      i++;
    }

    // Get input from user
    printf("\nPlease choose your weapon > ");
    char *choice;
    scanf("%s", choice);

    // Find matching weapon entry
    cJSON *chosen = cJSON_GetObjectItemCaseSensitive(logic, choice);

    // Check weapon exists
    if (chosen) {
        char *chosenName = cJSON_GetStringValue(cJSON_GetObjectItemCaseSensitive(chosen, "name"));
        printf("\nYou: %s\n", chosenName);

        // Make random choice for computer
        int r = rand() % n;
        char *computer = weapons[r];
        cJSON *computerWeapon = cJSON_GetObjectItemCaseSensitive(logic, computer);
        char *computerName = cJSON_GetStringValue(cJSON_GetObjectItemCaseSensitive(computerWeapon, "name"));
        printf("Computer: %s\n\n", computerName);

        // Check who wins
        cJSON *playerBeats = cJSON_GetObjectItemCaseSensitive(chosen, "beats");
        cJSON *playerBeatsComputer = cJSON_GetObjectItemCaseSensitive(playerBeats, computer);
        cJSON *computerBeats = cJSON_GetObjectItemCaseSensitive(computerWeapon, "beats");
        cJSON *computerBeatsPlayer = cJSON_GetObjectItemCaseSensitive(computerBeats, choice);

        if (playerBeatsComputer) {
          printf("===============\n");
          printf("=== YOU WIN ===\n");
          printf("%s %s %s\n", chosenName, cJSON_GetStringValue(playerBeatsComputer),computerName);
          printf("===============\n\n");
        } else if (computerBeatsPlayer) {
          printf("================\n");
          printf("=== YOU LOSE ===\n");
          printf("%s %s %s\n", computerName, cJSON_GetStringValue(computerBeatsPlayer),chosenName);
          printf("================\n\n");
        } else {
          printf("============\n");
          printf("=== DRAW ===\n");
          printf("============\n\n");
        }
    } else {
      printf("Please choose a valid weapon!\n\n");
    }

    sleep(1);
  }

}
