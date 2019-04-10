# Login App Example

This App is presenting simple app with logging and getting feed from REST API.

## Purpose

- Learning and improving my code skills
- For recruitment processes
- For new and less experienced developers, who wants to get some code examples

## Functions

1. Logging screen.
- You can log in if you have account or register.
- If any field in login or register will be empty, it will shake
- After successful log in, it will hold token in keychain. That way, if user leave the app, and returns, he will be logged in.
2. Pokemon list screen
- Shows pokemons, which it gets from: Network REST API feed (if connection is available), or Realm data base (if not)

## Next steps

- Create PokemonProvider and LoginManager classes. Main purpose of this adjustment is to abstract the way app is getting data feed. PokemonProvider will decide from where it will get Pokemon Data (from Network or Realm DataBase)

