deps:
	@echo "==> installing dependencies $(TARGET)"
	@helm dep up $(TARGET)

docs:
	@echo "==> documenting $(TARGET)"
	@helm-docs -c $(TARGET) --dry-run | prettier --parser markdown > $(TARGET)/README.md

lint:
	@echo "==> linting $(TARGET)"
	@ct lint --config ct.yaml --charts $(TARGET)

snapshot:
	@find ./$(TARGET)/examples -name '*.yaml' | grep -v '.snapshot.' | \
		xargs -I{} bash -c 'echo "$$(dirname {})/$$(basename {} .yaml)"' | \
		xargs -I{} bash -c "echo '=== snapshotting {}.yaml' && helm template $(TARGET) ./$(TARGET) -f {}.yaml > {}.snapshot.yaml"

schema:
	@jsonnet ./$(TARGET)/schema/schema.jsonnet > ./$(TARGET)/values.schema.json
