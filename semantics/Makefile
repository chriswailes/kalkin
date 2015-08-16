######################################################################
# Makefile
#
# Makefile for LaTeX projects
######################################################################

PAPERS = kalkin-semantics
SRCS = $(wildcard sections/*.tex) $(wildcard *.sty) $(wildcard *.bib)

GS = gs
#GS = gswin32c

GS_OPTS = -q -dNOPAUSE -dBATCH -sDEVICE=bbox
DVIPS_OPTS = -Ppdf -Pcmz -Pamz -t letter -D 600 -G0
#DVIPS_OPTS = -t letter -z -P pdf
DVIPDFM_OPTS = -p letter
PS2PDF_OPTS = 

.PHONY: html dvi ps pdf all

all: pdf
dvi: ${PAPERS:%=%.dvi}
${PAPERS:%=%.dvi}: ${SRCS} ${FIGURES:%=%.eps}
ps: ${PAPERS:%=%.ps}
pdf: ${PAPERS:%=%.pdf}
${PAPERS:%=%.pdf}: ${SRCS} ${FIGURES:%=%.pdf}
html: ${PAPERS:%=%/index.html}

clean:
	rm -rf ${PAPERS} ${PAPERS:%=%.dvi} ${PAPERS:%=%.ps} ${PAPERS:%=%.pdf} \
		builddate.tex *.aux *.toc *.lof *.lot *.log *.bbl *.blg \
		*.pst.* *.tmp *~ *.out *.thm *.detex

cont:
	while true; do \
		${MAKE} dvi; \
		sleep 2; \
	done

# Generate PDF
%.pdf: %.tex
	# Remove the .aux file because pdflatex wants it different
	rm -f ${<:%.tex=%.aux} ${<:%.tex=%.thm}
	(echo -n "\def\builddate{"; date; echo "}") >builddate.tex
	if pdflatex ${<} </dev/null; then \
		true; \
	else \
		stat=$$?; touch ${<:%.tex=%.pdf}; exit $$stat; \
	fi
	if grep -q "\\citation" ${<:%.tex=%.aux}; then \
		bibtex ${<:%.tex=%}; \
	fi
	while grep -q "Rerun to get" ${<:%.tex=%.log}; do \
		if pdflatex ${<} </dev/null; then \
			true; \
		else \
			stat=$$?; touch ${<:%.tex=%.pdf}; exit $$stat; \
		fi; \
	done

# Generate DVI
#   run once, then re-run until it's happy
#   input redirected from /dev/null is like hitting ^C at first error
%.dvi: %.tex
	(echo -n "\def\builddate{"; date; echo "}") >builddate.tex
	if latex ${<} </dev/null; then \
		true; \
	else \
		stat=$$?; touch ${<:%.tex=%.dvi}; exit $$stat; \
	fi
	if grep -q "\\citation" ${<:%.tex=%.aux}; then \
		bibtex ${<:%.tex=%}; \
	fi
	
	while grep -q "Rerun to get" ${<:%.tex=%.log}; do \
		if latex ${<} </dev/null; then \
			true; \
		else \
			stat=$$?; touch ${<:%.tex=%.dvi}; exit $$stat; \
		fi; \
	done

# Generate PS
%.ps: %.dvi
	dvips ${DVIPS_OPTS} -o ${<:%.dvi=%.ps} $<

# Generate PDF (using dvipdfm)
#%.pdf: %.dvi
#       dvipdfm ${DVIPDFM_OPTS} $<

# Generate PDF (using ps2pdf)
#%.pdf: %.ps
#       ps2pdf ${PS2PDF_OPTS} $<

# Generate HTML
%/index.html: %.dvi
	ifdef USE_HEVEA
		hevea article.hva fancysection.hva -fix -O ${<:%.dvi=%}
	else
		latex2html -noaddress -nowhite ${<:%.dvi=%.tex}
	endif
