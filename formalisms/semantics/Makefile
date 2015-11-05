all: kalkin-semantics.pdf

kalkin-semantics.pdf: kalkin-semantics.tex defs.tex
	pdflatex kalkin-semantics.tex

.PHONY: clean
clean:
	rm -f builddate.tex kalkin-semantics.aux kalkin-semantics.log kalkin-semantics.pdf
