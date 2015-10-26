#!/bin/sh
GIT=`git log --pretty=format:'%h' -n 1`

cd src

# Generate html
php index.php > temp.html
# Generate pdf using US Letter head
../wkhtmltopdf -s Letter -d 320 -B 0 -L 0 -R 0 -T 0 temp.html \
  temp.pdf
# cleanup old html
rm temp.html
# embed fonts
gs -o ../resume_${GIT}.pdf -sDEVICE=pdfwrite -dEmbedAllFonts=true \
  -sFONTPATH="./fonts" temp.pdf
# clean up old pdf
rm  temp.pdf

cd ..

# reset soft link
rm resume.pdf
ln -s resume_${GIT}.pdf resume.pdf

