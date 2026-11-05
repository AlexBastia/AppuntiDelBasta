.PHONY: poly test clean

poly:
	dune build ./main.exe
	cp -f _build/default/main.exe poly
	chmod u+w poly

# Run every test: programs named good* should be accepted, and programs
# named bad* should be rejected with a type error.
test: poly
	@for f in tests/*/good*.f tests/*/good*.hm; do \
	  [ -e "$$f" ] || continue; \
	  if ./poly "$$f" > /dev/null 2>&1; then echo "OK:     $$f"; \
	  else echo "FAILED: $$f (should be accepted)"; fi; \
	done
	@for f in tests/*/bad*.f tests/*/bad*.hm; do \
	  [ -e "$$f" ] || continue; \
	  if ./poly "$$f" > /dev/null 2>&1; then echo "FAILED: $$f (should be rejected)"; \
	  else echo "OK:     $$f"; fi; \
	done

clean:
	dune clean
	rm -f poly
