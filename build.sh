#!/bin/sh
# Use US Letter head.
php source.php > source.html
wkhtmltopdf -s Letter source.html resume.pdf
rm source.html
