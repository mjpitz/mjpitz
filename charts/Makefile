docs:
	@echo "==> documenting $(TARGET)"
	@helm-docs -c $(TARGET) --dry-run | prettier --parser markdown > $(TARGET)/README.md

lint:
	@echo "==> linting $(TARGET)"
	@ct lint --config ct.yaml --charts $(TARGET)