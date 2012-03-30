#!/bin/sh
# Use US Letter head.
cd src
php index.php > temp.html
wkhtmltopdf -s Letter -d 320 -B 0 -L 0 -R 0 -T 0 temp.html ../resume.pdf
rm temp.html
cd ..

