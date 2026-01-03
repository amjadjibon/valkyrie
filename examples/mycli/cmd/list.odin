package cmd

import vk "../../../valkyrie"
import "core:fmt"
import "core:strings"

// Build the list command
make_list_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("list", "List items")
	vk.command_add_alias(cmd, "ls")
	vk.command_add_flag(cmd, vk.flag_string("filter", "f", "Filter items by substring"))
	vk.command_set_handler(cmd, list_handler)
	return cmd
}

list_handler :: proc(ctx: ^vk.Context) -> bool {
	verbose := vk.get_flag_bool(ctx, "verbose") // Inherited from root
	filter := vk.get_flag_string(ctx, "filter")

	items := []string{"apple", "banana", "cherry", "date", "elderberry"}

	fmt.println("Items:")
	found_count := 0
	for item in items {
		if filter != "" && !strings.contains(item, filter) {
			continue
		}

		found_count += 1
		if verbose {
			fmt.printfln("  - %s (length: %d)", item, len(item))
		} else {
			fmt.printfln("  - %s", item)
		}
	}

	if filter != "" && found_count == 0 {
		fmt.eprintfln("Error: no items found matching filter '%s'", filter)
		return false
	}

	return true
}
