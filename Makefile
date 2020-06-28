# Formatting and Linting

.PHONY: lint
lint:
	swiftlint lint

.PHONY: autocorrect
autocorrect:
	swiftlint autocorrect

.PHONY: format
format:
	swiftformat . 
