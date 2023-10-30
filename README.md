# Elixir CRUD API with Plug and Cowboy

This is a simple Elixir project that provides a CRUD (Create, Read, Update, Delete) API using a Plug router and Cowboy as the HTTP server. It also includes a basic in-memory database using ETS (Erlang Term Storage) wrapped in a GenServer for data storage.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [License](#license)

## Prerequisites

Before you get started, ensure you have the following installed:

- Elixir (>= 1.11.0): [Installation Guide](https://elixir-lang.org/install.html)
- Mix: Elixir's build tool (usually installed with Elixir)
- Git (for cloning this repository)

## Getting Started

1. Install project dependencies:

   ```bash
   mix deps.get
   ```

2. Start the application:

   ```bash
   iex -S mix
   ```

Your Elixir CRUD API will be running on `http://localhost:4001`.

## Project Structure

The project structure is as follows:

```
├── lib/
│   │── JsonLoader.ex            # Module to load json files in the ets table
│   │── Server.Router.ex         # Cowboy server setup with entrypoints
│   │── application.ex           # Project Supervisor
│   │── database.ex              # GenServer for data storage
│   ├── serv_supervisor.ex       # Database supervisor
├── test/
├── mix.exs                   # Project configuration
├── README.md                # This README file
```

## Dependencies

This project relies on the following Elixir dependencies:

- [Plug](https://hex.pm/packages/plug): A specification and conveniences for composable modules between web applications.
- [Cowboy](https://hex.pm/packages/cowboy): A small, fast, and modular HTTP server written in Erlang.
- [Poison](https://hex.pm/packages/poison): A JSON library for Elixir, which is used for encoding and decoding JSON data.

You don't need to install these dependencies separately; Mix will handle it for you when you run `mix deps.get`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Feel free to customize and expand upon this project to suit your needs! If you have any questions or encounter issues, please don't hesitate to reach out.
