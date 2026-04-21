# https://git-scm.com/
# Tested with 2.9.2
# This will add git information to the build.
gitv=`git log --pretty=format:'%h' -n 1`

lua=luajit

SRCS=${wildcard versions/*.json}

all: aaa

aaa:
	${lua} make_html.lua versions/aaa.json > aaa_${gitv}.html

clean:
	rm aaa_${gitv}.html
	rm indie_${gitv}.html
	rm webdev_${gitv}.html
	rm oversized_${gitv}.html
	rm ${temppdf}
	rm aaa_${outpdf}
	rm indie_${outpdf}
	rm webdev_${outpdf}
	rm oversized_${outpdf}
	rm aaa_${outimage}
	rm indie_${outimage}
	rm webdev_${outimage}
	rm oversized_${outimage}
