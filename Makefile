.PHONY: build-example run-example clean

build-example:
	mkdir -p build
	odin build examples/mycli/main.odin -file -out:build/mycli

run-example: build-example
	./build/mycli

clean:
	rm -rf build
