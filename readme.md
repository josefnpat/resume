This is Josef Patoprsty's Open Source Résumé.

This résumé builds itself:

* Data stored in JSON format (~/src/resume.json)
* Dynamically rendered in PHP (~/src/index.php)
* Styled in CSS (~/src/style.css)
* Rendered to PDF (wkhtmltopdf 0.11.0)

Dependencies
============

* wkhtmltopdf 0.11.0 (for precision, attempt to use this version)
  To download and properly prepare wkhtmltopdf, run your `dep_<os>_<architecture>.sh`
  http://code.google.com/p/wkhtmltopdf/downloads/list
* PHP 5.3.5-1ubuntu7.7 (PHP4 untested, but shouldn't be a problem)
  http://php.net/
* Open Sans font (see ~/fonts/OpenSans-Regular.ttf)
  http://www.google.com/webfonts/specimen/Open+Sans
* git (for commit info)
  http://git-scm.com/
  

Building
========

Run ./build.sh
