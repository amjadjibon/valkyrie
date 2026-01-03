package cmd

import vk "../../../valkyrie"
import "core:fmt"

// Build the greet command
make_greet_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("greet", "Greet someone by name")
	vk.command_add_flag(cmd, vk.flag_string("name", "n", "Name to greet", "World"))
	vk.command_add_flag(cmd, vk.flag_int("count", "c", "Number of times to greet", 1))
	vk.command_add_flag(cmd, vk.flag_bool("uppercase", "u", "Print in uppercase"))
	vk.command_set_handler(cmd, greet_handler)
	return cmd
}

greet_handler :: proc(ctx: ^vk.Context) -> bool {
	name := vk.get_flag_string(ctx, "name")
	count := vk.get_flag_int(ctx, "count")
	uppercase := vk.get_flag_bool(ctx, "uppercase")

	if count < 0 {
		fmt.eprintln("Error: count must be a positive number")
		return false
	}

	if count > 100 {
		fmt.eprintln("Error: count cannot exceed 100")
		return false
	}

	if uppercase {
		greeting := fmt.aprintf("Hello, %s!", name)
		defer delete(greeting)

		greeting_upper := make([]u8, len(greeting))
		defer delete(greeting_upper)
		for i := 0; i < len(greeting); i += 1 {
			c := greeting[i]
			if c >= 'a' && c <= 'z' {
				greeting_upper[i] = c - 32
			} else {
				greeting_upper[i] = c
			}
		}

		for _ in 0 ..< count {
			fmt.println(string(greeting_upper))
		}
	} else {
		for _ in 0 ..< count {
			fmt.printfln("Hello, %s!", name)
		}
	}

	return true
}
