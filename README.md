# Valkyrie

A clean, type-safe CLI framework for Odin that makes building command-line applications simple and intuitive.

![Demo](demo.gif)

## Features

- **Type-safe flag parsing** - Support for bool, string, int, and float flags
- **Nested subcommands** - Build complex CLI hierarchies
- **Automatic help generation** - Help text generated from command metadata
- **Short and long flags** - Both `-f` and `--flag` syntax supported
- **Required and optional flags** - Enforce required parameters
- **Default values** - Sensible defaults for all flag types
- **Memory safe** - Proper cleanup with allocator support

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/valkyrie.git

# Or add it as a submodule to your project
git submodule add https://github.com/yourusername/valkyrie.git
```

Then import it in your Odin project:

```odin
import vk "path/to/valkyrie"
```

## Quick Start

Here's a simple example to get you started:

```odin
package main

import vk "path/to/valkyrie"
import "core:fmt"
import "core:os"

greet_handler :: proc(ctx: ^vk.Context) -> bool {
    name := vk.get_flag_string(ctx, "name")
    fmt.printfln("Hello, %s!", name)
    return true
}

main :: proc() {
    // Create the application
    app := vk.app_create(
        "myapp",
        "1.0.0",
        "A simple CLI application",
        context.temp_allocator,
    )

    // Create a command
    greet_cmd := vk.command_create("greet", "Greet someone by name")
    vk.command_add_flag(greet_cmd, vk.flag_string("name", "n", "Name to greet", "World"))
    vk.command_set_handler(greet_cmd, greet_handler)
    vk.command_add_subcommand(app.root, greet_cmd)

    // Run the application
    exit_code := vk.app_run(app)

    // Cleanup
    free_all(context.temp_allocator)
    os.exit(exit_code)
}
```

## Usage

### Creating an Application

```odin
app := vk.app_create(
    "myapp",           // Application name
    "1.0.0",           // Version
    "App description", // Description
    context.temp_allocator,
)
```

### Creating Commands

```odin
cmd := vk.command_create("command", "Command description")
vk.command_set_handler(cmd, my_handler)
vk.command_add_subcommand(app.root, cmd)
```

### Adding Flags

Valkyrie supports four flag types:

```odin
// Boolean flag
vk.command_add_flag(cmd, vk.flag_bool("verbose", "v", "Enable verbose output"))

// String flag
vk.command_add_flag(cmd, vk.flag_string("name", "n", "Your name", "default"))

// Integer flag
vk.command_add_flag(cmd, vk.flag_int("port", "p", "Port number", 8080))

// Float flag
vk.command_add_flag(cmd, vk.flag_float("ratio", "r", "Ratio value", 1.0))

// Required flag
vk.command_add_flag(cmd, vk.flag_string("config", "c", "Config file", required=true))
```

### Writing Command Handlers

```odin
my_handler :: proc(ctx: ^vk.Context) -> bool {
    // Get flag values
    name := vk.get_flag_string(ctx, "name")
    count := vk.get_flag_int(ctx, "count")
    verbose := vk.get_flag_bool(ctx, "verbose")
    ratio := vk.get_flag_float(ctx, "ratio")

    // Access positional arguments
    for arg in ctx.args {
        fmt.println(arg)
    }

    // Return true for success, false for error
    return true
}
```

### Nested Subcommands

Create hierarchical command structures:

```odin
// Create parent command
server_cmd := vk.command_create("server", "Server management")

// Create subcommands
start_cmd := vk.command_create("start", "Start the server")
vk.command_add_flag(start_cmd, vk.flag_int("port", "p", "Port", 8080))
vk.command_set_handler(start_cmd, start_handler)

stop_cmd := vk.command_create("stop", "Stop the server")
vk.command_set_handler(stop_cmd, stop_handler)

// Add subcommands to parent
vk.command_add_subcommand(server_cmd, start_cmd)
vk.command_add_subcommand(server_cmd, stop_cmd)

// Add to root
vk.command_add_subcommand(app.root, server_cmd)
```

Usage:
```bash
./myapp server start --port 3000
./myapp server stop
```

## Examples

A complete example application is provided in `examples/mycli/`. Build and run it:

```bash
# Build the example
make build-example

# Run with various commands
./build/mycli greet --name Alice --count 3
./build/mycli math add --a 5 --b 10
./build/mycli list --filter berry --verbose
./build/mycli server start --port 3000 --daemon
```

### Example Commands

The example application demonstrates:

- **greet** - Simple command with string, int, and bool flags
- **math** - Parent command with subcommands
  - **add** - Add two integers (required flags)
  - **multiply** - Multiply two floats (required flags)
- **list** - List filtering with optional flags
- **server** - Server management with subcommands
  - **info** - Display server information
  - **start** - Start server with configuration

## Flag Syntax

Valkyrie supports multiple flag syntax styles:

```bash
# Long flags
--flag value
--flag=value

# Short flags
-f value
-f=value

# Boolean flags
--verbose         # Sets to true
--verbose=true
--verbose=false

# Built-in flags
--help, -h        # Show help
--version, -v     # Show version
```

## API Reference

### Application Functions

- `app_create(name, version, description, allocator) -> ^App`
- `app_destroy(app)`
- `app_run(app, args) -> int`

### Command Functions

- `command_create(name, description, handler, allocator) -> ^Command`
- `command_destroy(cmd)`
- `command_add_flag(cmd, flag)`
- `command_add_subcommand(parent, child)`
- `command_set_handler(cmd, handler)`

### Flag Helpers

- `flag_bool(name, short, description, default) -> Flag`
- `flag_string(name, short, description, default, required) -> Flag`
- `flag_int(name, short, description, default, required) -> Flag`
- `flag_float(name, short, description, default, required) -> Flag`

### Context Helpers

- `get_flag_bool(ctx, name) -> bool`
- `get_flag_string(ctx, name) -> string`
- `get_flag_int(ctx, name) -> int`
- `get_flag_float(ctx, name) -> f64`

### Context Structure

```odin
Context :: struct {
    args:      []string,               // Positional arguments
    flags:     map[string]Flag_Value,  // Parsed flag values
    parent:    ^Command,               // Parent command
    allocator: mem.Allocator,          // Allocator to use
}
```

## Building

```bash
# Build the example
make build-example

# Run the example
make run-example

# Clean build artifacts
make clean
```

## Design Philosophy

Valkyrie is designed with these principles in mind:

1. **Type Safety** - Leverage Odin's type system for safer CLI parsing
2. **Simplicity** - Clean, intuitive API that's easy to learn
3. **Explicitness** - No magic, clear control flow
4. **Memory Safety** - Proper allocator support and cleanup
5. **Composability** - Build complex CLIs from simple building blocks

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

Built with [Odin](https://odin-lang.org/), a fast, concise, readable, pragmatic and open-source programming language.
