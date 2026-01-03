package main

import vk "../../valkyrie"
import "core:os"

main :: proc() {
	// Create the app
	app := make_app()

	// Run and exit
	os.exit(vk.app_run(app))
}
