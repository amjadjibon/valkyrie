package main

import vk "../../valkyrie"
import "cmd"
import "core:fmt"

// Make root command
make_app :: proc() -> ^vk.App {
	app := vk.app_create(
		"mycli",
		"1.0.0",
		"An example CLI application built with Valkyrie",
		context.temp_allocator,
	)

	// Setup root with persistent flags and hooks
	setup_root(app.root)

	// Register commands
	vk.command_add_subcommand(app.root, cmd.make_greet_cmd())
	vk.command_add_subcommand(app.root, cmd.make_math_cmd())
	vk.command_add_subcommand(app.root, cmd.make_list_cmd())
	vk.command_add_subcommand(app.root, cmd.make_server_cmd())

	return app
}

// Setup root command with persistent flags and hooks
setup_root :: proc(root: ^vk.Command) {
	// Persistent flags (inherited by all subcommands)
	vk.command_add_persistent_flag(root, vk.flag_bool("verbose", "v", "Enable verbose output"))

	// Persistent hooks (run for all commands)
	vk.command_set_persistent_pre_run(root, persistent_pre_run)
	vk.command_set_persistent_post_run(root, persistent_post_run)
}

// Runs before every command
persistent_pre_run :: proc(ctx: ^vk.Context) -> bool {
	if vk.get_flag_bool(ctx, "verbose") {
		fmt.println("[DEBUG] Starting command execution...")
	}
	return true
}

// Runs after every command
persistent_post_run :: proc(ctx: ^vk.Context) -> bool {
	if vk.get_flag_bool(ctx, "verbose") {
		fmt.println("[DEBUG] Command execution completed.")
	}
	return true
}
