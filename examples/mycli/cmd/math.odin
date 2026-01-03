package cmd

import vk "../../../valkyrie"
import "core:fmt"

// Build the math command with subcommands
make_math_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("math", "Mathematical operations")

	// Add subcommand
	vk.command_add_subcommand(cmd, make_add_cmd())
	vk.command_add_subcommand(cmd, make_multiply_cmd())

	return cmd
}

// --- Add subcommand ---

make_add_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("add", "Add two numbers")
	vk.command_add_flag(cmd, vk.flag_int("a", "", "First number", required = true))
	vk.command_add_flag(cmd, vk.flag_int("b", "", "Second number", required = true))
	vk.command_set_handler(cmd, add_handler)
	return cmd
}

add_handler :: proc(ctx: ^vk.Context) -> bool {
	a := vk.get_flag_int(ctx, "a")
	b := vk.get_flag_int(ctx, "b")
	fmt.printfln("%d + %d = %d", a, b, a + b)
	return true
}

// --- Multiply subcommand ---

make_multiply_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("multiply", "Multiply two numbers")
	vk.command_add_flag(cmd, vk.flag_float("x", "", "First number", required = true))
	vk.command_add_flag(cmd, vk.flag_float("y", "", "Second number", required = true))
	vk.command_set_handler(cmd, multiply_handler)
	return cmd
}

multiply_handler :: proc(ctx: ^vk.Context) -> bool {
	x := vk.get_flag_float(ctx, "x")
	y := vk.get_flag_float(ctx, "y")
	fmt.printfln("%.2f * %.2f = %.2f", x, y, x * y)
	return true
}
