JSONNET_ARGS := -n 2 --max-blank-lines 2 --string-style s --comment-style s
ifneq (,$(shell which jsonnetfmt))
	JSONNET_FMT_CMD := jsonnetfmt
else
	JSONNET_FMT_CMD := jsonnet
	JSONNET_FMT_ARGS := fmt $(JSONNET_ARGS)
endif
JSONNET_FMT := $(JSONNET_FMT_CMD) $(JSONNET_FMT_ARGS)

format:
	@echo "==> formatting $(TARGET)"
	@find $(TARGET) -type f -print | xargs -n 1 -- $(JSONNET_FMT) -i

lint:
	@echo "==> linting $(TARGET)"
	@find $(TARGET) -type f -print | \
		while read f; do \
			$(JSONNET_FMT) "$$f" | diff -u "$$f" -; \
		done

build:
	@echo "==> building $(TARGET)"
	@mkdir -p out/$(TARGET)
	@jsonnet -J vendor -V output=alerts -S $(TARGET)/gen.jsonnet > out/$(TARGET)/prometheus_alerts.yaml
	@jsonnet -J vendor -V output=dashboards -m out/$(TARGET) $(TARGET)/gen.jsonnet 1>/dev/null
	@jsonnet -J vendor -V output=rules -S $(TARGET)/gen.jsonnet > out/$(TARGET)/prometheus_rules.yaml

sync:
	@echo "==> synchronizing $(TARGET)"
	@bash ./common/sync.sh $(TARGET)
