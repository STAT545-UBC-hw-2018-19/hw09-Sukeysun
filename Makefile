all: ./output-files/report.html ./output-files/analysis.html

clean:
	
	rm -rf ./data/
	rm -rf ./pictures/
	rm -rf ./output-files/
	

## for words.txt

./data/words.txt:
	mkdir -p ./data/
	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "./data/words.txt", quiet = TRUE)'

./data/histogram.tsv: ./r/histogram.r ./data/words.txt
	Rscript $<

./pictures/histogram.png: ./data/histogram.tsv
	mkdir -p ./pictures/
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

./output-files/report.html: ./rmd/report.rmd ./data/histogram.tsv ./pictures/histogram.png
	mkdir -p ./output-files/
	Rscript -e 'library(rmarkdown); render("$<", output_dir = "./output-files/")'
	
#./data/words.txt: /usr/share/dict/words
#	cp $< $@


## for gapminder.tsv


# download gapminder

./data/gapminder.csv: ./r/gapminder_download.r
	mkdir -p ./data/
	Rscript $<


./data/gapminder_words.csv: ./r/gapminder_words.r ./data/gapminder.csv ./data/words.txt
	mkdir -p ./data/
	Rscript $<

./pictures/analysis.png: ./r/analysis.r ./data/gapminder_words.csv
	mkdir -p ./pictures/
	Rscript $<
	rm Rplots.pdf

./output-files/analysis.html: ./rmd/analysis.rmd ./pictures/analysis.png
	mkdir -p ./output-files/
	Rscript -e 'library(rmarkdown); render("$<", output_dir = "./output-files/")'

## Visualize the makefile structure
makefile.png: ./python/makefile2dot.py Makefile
	python $< <$(word 2, $^) |dot -Tpng > ./pictures/$@