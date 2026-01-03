package cmd

import vk "../../../valkyrie"
import "core:fmt"

// Build the server command with subcommands
make_server_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("server", "Server management commands")
	vk.command_add_alias(cmd, "srv")

	// Add subcommands
	vk.command_add_subcommand(cmd, make_server_info_cmd())
	vk.command_add_subcommand(cmd, make_server_start_cmd())

	return cmd
}

// --- Info subcommand ---

make_server_info_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("info", "Show server information")
	vk.command_set_handler(cmd, server_info_handler)
	return cmd
}

server_info_handler :: proc(ctx: ^vk.Context) -> bool {
	fmt.println("Server Information:")
	fmt.println("  Status: Running")
	fmt.println("  Port: 8080")
	fmt.println("  Version: 1.0.0")
	return true
}

// --- Start subcommand ---

make_server_start_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("start", "Start the server")
	vk.command_add_flag(cmd, vk.flag_int("port", "p", "Port to listen on", 8080))
	vk.command_add_flag(cmd, vk.flag_bool("daemon", "d", "Run as daemon"))
	vk.command_set_handler(cmd, server_start_handler)
	return cmd
}

server_start_handler :: proc(ctx: ^vk.Context) -> bool {
	port := vk.get_flag_int(ctx, "port")
	daemon := vk.get_flag_bool(ctx, "daemon")

	if port < 1024 {
		fmt.eprintln("Error: port must be 1024 or higher")
		return false
	}

	if port > 65535 {
		fmt.eprintln("Error: port must be 65535 or lower")
		return false
	}

	fmt.printfln("Starting server on port %d", port)
	if daemon {
		fmt.println("Running in daemon mode")
	}
	fmt.println("Server started successfully!")

	return true
}
