MAIN := imp
TEST_FILES := $(wildcard tests/*.imp *.imp)

.PHONY: $(MAIN) test clean

$(MAIN):
	dune build ./main.exe
	cp -f _build/default/main.exe $(MAIN)
	chmod u+w $(MAIN)

.SILENT: test
test: $(MAIN) $(TEST_FILES)
	for F in $(TEST_FILES); do \
		if ./imp -verify $$F > /dev/null 2>&1; then \
			printf "[\033[32m   OK   \033[0m] %s\n" "$$F"; \
		else \
			printf "[\033[41;30m Failed \033[0m] \033[91m%s\033[0m\n" "$$F"; \
		fi; \
	done

clean:
	dune clean
	rm -f $(MAIN)
