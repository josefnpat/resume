This is Josef Patoprsty's Open Source Résumé.

This résumé builds itself:

* Data stored in JSON format (`~/src/resume.json`)
* Dynamically rendered in PHP (`~/src/index.php`)
* Styled in CSS (`~/src/style.css`)
* Rendered to PDF (wkhtmltopdf 0.11.0)

Dependencies
============

To download and properly prepare wkhtmltopdf, run `./dep_<os>_<architecture>.sh`

* wkhtmltopdf 0.11.0 (for precision, attempt to use this version) [link](http://code.google.com/p/wkhtmltopdf/downloads/list)
* PHP 5.3.5-1ubuntu7.7 (PHP4 untested, but shouldn't be a problem) [link](http://php.net/)
* Open Sans font (see `~/fonts/OpenSans-Regular.ttf`) [link](http://www.google.com/webfonts/specimen/Open+Sans)
* git (for commit info) [link](http://git-scm.com/)

Building
========

Run `./build.sh`
