defmodule Nerdshambo do

  def load_logic(path) do
    with {:ok, file_content} <- File.read(path) do
      Poison.decode(file_content)
    end
  end

  def play_game(logic) do
    weapons = logic |> Map.keys

    IO.puts "=== Weapons ==="

    for k <- weapons, do: IO.puts "#{k}: #{logic[k]["name"]}"

    choice = IO.gets("Please choose your weapon >") |> String.trim

    if choice in weapons do

      chosen = logic[choice]
      computer = weapons |> Enum.random
      computer_weapon = logic[computer]

      IO.puts("\nYou: #{chosen["name"]}")
      IO.puts("Computer: #{computer_weapon["name"]}\n")

      cond do
        Map.has_key?(chosen["beats"], computer) ->
          IO.puts("===============")
          IO.puts("=== YOU WIN ===")
          IO.puts("#{chosen["name"]} #{chosen["beats"][computer]} #{computer_weapon["name"]}")
          IO.puts("===============\n")
        Map.has_key?(computer_weapon["beats"], choice) ->
          IO.puts("================")
          IO.puts("=== YOU LOSE ===")
          IO.puts("#{computer_weapon["name"]} #{computer_weapon["beats"][choice]} #{chosen["name"]}")
          IO.puts("================\n")
        true ->
          IO.puts("============")
          IO.puts("=== DRAW ===")
          IO.puts("============\n")
      end

    else
      IO.puts("Please choose a valid weapon!")
    end
    :timer.sleep(1000)
    play_game(logic)
  end

  def main(args) do
    options = [
      switches: [file: :string],
      aliases: [f: :file]
    ]
    {opts,_,_}= OptionParser.parse(args, options)

    logic_file = opts[:file]

    with {:ok, logic} <- load_logic(logic_file) do

      play_game(logic)

    end

  end
end
