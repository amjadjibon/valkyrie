package cmd

import vk "../../../valkyrie"
import "core:fmt"
import "core:os"
import "core:strings"

// Markdown utilities command
make_md_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("md", "Markdown utilities")
	vk.command_add_alias(cmd, "markdown")

	vk.command_add_subcommand(cmd, make_md_toc_cmd())
	vk.command_add_subcommand(cmd, make_md_links_cmd())

	return cmd
}

// --- TOC subcommand ---

make_md_toc_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("toc", "Generate table of contents from markdown headers")
	vk.command_add_flag(cmd, vk.flag_int("max-depth", "d", "Maximum heading depth", 3))
	vk.command_set_handler(cmd, md_toc_handler)
	return cmd
}

md_toc_handler :: proc(ctx: ^vk.Context) -> bool {
	if len(ctx.args) == 0 {
		fmt.eprintln("Error: please provide a markdown file path")
		return false
	}

	filepath := ctx.args[0]
	max_depth := vk.get_flag_int(ctx, "max-depth")
	verbose := vk.get_flag_bool(ctx, "verbose")

	if verbose {
		fmt.printfln("Generating TOC for: %s (max-depth: %d)", filepath, max_depth)
	}

	// Read file
	data, ok := os.read_entire_file(filepath)
	if !ok {
		fmt.eprintfln("Error: could not read file '%s'", filepath)
		return false
	}
	defer delete(data)

	content := string(data)
	lines := strings.split_lines(content)
	defer delete(lines)

	fmt.println("## Table of Contents\n")

	for line in lines {
		trimmed := strings.trim_left_space(line)

		// Count # at start
		level := 0
		for c in trimmed {
			if c == '#' {
				level += 1
			} else {
				break
			}
		}

		if level > 0 && level <= max_depth {
			// Extract header text
			header_start := level
			for header_start < len(trimmed) && trimmed[header_start] == ' ' {
				header_start += 1
			}
			header_text := trimmed[header_start:]

			// Create slug
			slug := make_slug(header_text)
			defer delete(slug)

			// Print with indentation
			indent := strings.repeat("  ", level - 1)
			defer delete(indent)
			fmt.printfln("%s- [%s](#%s)", indent, header_text, slug)
		}
	}

	return true
}

// Make URL-friendly slug from text
// Note: Caller must delete the returned string
make_slug :: proc(text: string) -> string {
	result := strings.builder_make()
	for c in text {
		if c >= 'a' && c <= 'z' {
			strings.write_rune(&result, c)
		} else if c >= 'A' && c <= 'Z' {
			strings.write_rune(&result, c + 32) // lowercase
		} else if c >= '0' && c <= '9' {
			strings.write_rune(&result, c)
		} else if c == ' ' || c == '-' {
			strings.write_rune(&result, '-')
		}
	}
	return strings.to_string(result)
}

// --- Links subcommand ---

make_md_links_cmd :: proc() -> ^vk.Command {
	cmd := vk.command_create("links", "Extract all links from markdown file")
	vk.command_set_handler(cmd, md_links_handler)
	return cmd
}

md_links_handler :: proc(ctx: ^vk.Context) -> bool {
	if len(ctx.args) == 0 {
		fmt.eprintln("Error: please provide a markdown file path")
		return false
	}

	filepath := ctx.args[0]
	verbose := vk.get_flag_bool(ctx, "verbose")

	if verbose {
		fmt.printfln("Extracting links from: %s", filepath)
	}

	// Read file
	data, ok := os.read_entire_file(filepath)
	if !ok {
		fmt.eprintfln("Error: could not read file '%s'", filepath)
		return false
	}
	defer delete(data)

	content := string(data)
	link_count := 0

	// Simple link extraction: look for [text](url) pattern
	i := 0
	for i < len(content) {
		if content[i] == '[' {
			// Find matching ]
			j := i + 1
			for j < len(content) && content[j] != ']' {
				j += 1
			}

			// Check for (url)
			if j + 1 < len(content) && content[j + 1] == '(' {
				// Find closing )
				k := j + 2
				for k < len(content) && content[k] != ')' {
					k += 1
				}

				if k < len(content) {
					link_text := content[i + 1:j]
					link_url := content[j + 2:k]

					if len(link_url) > 0 {
						fmt.printfln("[%s](%s)", link_text, link_url)
						link_count += 1
					}

					i = k + 1
					continue
				}
			}
		}
		i += 1
	}

	if verbose {
		fmt.printfln("\nTotal: %d links found", link_count)
	}

	return true
}
