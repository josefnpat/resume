# http://wkhtmltopdf.org/
# Tested with version 0.12.3
# This tool converts html to pdf and png
topdf=wkhtmltopdf -s Letter -d 320 -B 0 -L 0 -R 0 -T 0
toimage=wkhtmltoimage

# https://git-scm.com/
# Tested with 2.9.2
# This will add git information to the build.
gitv=`git log --pretty=format:'%h' -n 1`

# http://www.ghostscript.com/
# Tested with 9.19
# This adds the fonts to the pdf. You can check with the `pdffonts` tool to verify.
ghostscript=gs

temppdf=temp.pdf

outpdf=resume_${gitv}.pdf
outimage=resume_${gitv}.png

SRCS=${wildcard versions/*.json}

all: aaa indie webdev

aaa:
	php index.php versions/aaa.json > aaa_${gitv}.html
	${toimage} aaa_${gitv}.html aaa_${outimage}
	${topdf} aaa_${gitv}.html ${temppdf}
	${ghostscript} -o aaa_${outpdf} -sDEVICE=pdfwrite -dEmbedAllFonts=true -sFONTPATH="./fonts" ${temppdf}

indie:
	php index.php versions/indie.json > indie_${gitv}.html
	${toimage} indie_${gitv}.html indie_${outimage}
	${topdf} indie_${gitv}.html ${temppdf}
	${ghostscript} -o indie_${outpdf} -sDEVICE=pdfwrite -dEmbedAllFonts=true -sFONTPATH="./fonts" ${temppdf}

webdev:
	php index.php versions/webdev.json > webdev_${gitv}.html
	${toimage} webdev_${gitv}.html webdev_${outimage}
	${topdf} webdev_${gitv}.html ${temppdf}
	${ghostscript} -o webdev_${outpdf} -sDEVICE=pdfwrite -dEmbedAllFonts=true -sFONTPATH="./fonts" ${temppdf}

clean:
	rm aaa_${gitv}.html
	rm indie_${gitv}.html
	rm webdev_${gitv}.html
	rm ${temppdf}
	rm aaa_${outpdf}
	rm indie_${outpdf}
	rm webdev_${outpdf}
	rm aaa_${outimage}
	rm indie_${outimage}
	rm webdev_${outimage}
