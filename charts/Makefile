help:
	@echo "no help available"

docs:
	helm-docs -c $(TARGET) --dry-run | prettier --parser markdown > $(TARGET)/README.md
