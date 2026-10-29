.PHONY: imp test clean

imp:
	dune build main.exe
	cp _build/default/main.exe imp
	chmod u+w imp

test:
	dune runtest

clean:
	dune clean
	rm -f imp
