.PHONY: pi test test-requirements clean

pi:
	dune build ./main.exe
	cp -f _build/default/main.exe pi
	chmod u+w pi

# Run the tests that each definition of equality should pass. Programs named
# good* should be accepted, and programs named bad* should be rejected with
# a type error (exit status 1).
#
#   alpha:   tests/requirements
#   beta:    tests/requirements, tests/beta
#   eta:     tests/requirements, tests/beta, tests/eta
#
# The programs in tests/requirements check the requirements on any definition
# of equality, so every definition has to pass them: `make test-requirements`
# runs just those.

define run_tests
	@for f in $(2); do \
	  [ -e "$$f" ] || continue; \
	  case $$(basename $$f) in \
	    good*) if ./pi --equal=$(1) "$$f" > /dev/null 2>&1; then echo "OK:     [$(1)] $$f"; \
	           else echo "FAILED: [$(1)] $$f (should be accepted)"; fi ;; \
	    bad*)  ./pi --equal=$(1) "$$f" > /dev/null 2>&1; \
	           if [ $$? -eq 1 ]; then echo "OK:     [$(1)] $$f"; \
	           else echo "FAILED: [$(1)] $$f (should be rejected with a type error)"; fi ;; \
	  esac; \
	done
endef

test: pi
	$(call run_tests,alpha,tests/requirements/*.pi)
	$(call run_tests,beta,tests/requirements/*.pi tests/beta/*.pi)
	$(call run_tests,eta,tests/requirements/*.pi tests/beta/*.pi tests/eta/*.pi)

test-requirements: pi
	$(call run_tests,alpha,tests/requirements/*.pi)
	$(call run_tests,beta,tests/requirements/*.pi)
	$(call run_tests,eta,tests/requirements/*.pi)

clean:
	dune clean
	rm -f pi
