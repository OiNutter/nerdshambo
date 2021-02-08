Nerdshambo
==========

![Rock Paper Scissors Lizard Spock](https://i.stack.imgur.com/ltfS9m.png)

Say what?
---------

Nerdshambo is my nickname for Rock, Paper, Scissors, Lizard, Spock, a play on
Roshambo, another name for Rock, Paper Scissors.

This repo is an extension of my inital playing around with [Flutter](https://flutter.dev)
and my decision to build a Nerdshambo game as a mobile app using it. When I
recently decided to have another play with [Rust](https://rust-lang.org) after
a while, I couldn't think what to write to get started (after the usual Hello
World of course). So I decided to write another command line version of the game.
And then I decided to do a lot more...

So the goal now is to curate as many versions of the game in as many different
programming languages. Partly to learn a bit of the languages, partly as a
comparison of how different languages handle some basic tasks but mostly as a
bit of fun.

Can I join in?
--------------

Yup, if you have a language you want to do a version in by all mean's fork
this repo, add it and submit a pull request. Additionally if you want to improve
on the versions I've done then go for it.

The Spec
-------

The basic requirements for the game are simple. With the exception of the
original Flutter version I'm loading the game logic from a json file in the root
of the repo. The path to this file is passed to the script via commandline args
at runtime. The script then parses that into a usable structure, prints out the
list of available choices and asks for your choice. Once you make a choice, it
picks a random choice as the computer's option, then checks the game logic to
see who wins and presents you with information on who won and how.

Simples!

Using the existing `logic.json` file is optional, I just find this a neat way
to store the logic and it let's me reuse it across languages.

Languages/Frameworks So Far
----------------

* [Elixir](https://elixir-lang.org)
* [Flutter/Dart](https://flutter.dev)
* [Go](https://golang.org)
* [Lua](https://lua.org)
* [NodeJS](https://nodejs.org)
* [Python](https://python.org)
* [Rust](https://rust-lang.org)
* [Ruby](https://ruby-lang.org)

Have fun!
