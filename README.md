# inniAccounts Invoice Design Kit

## Getting started
Bundle
wkhtmltopdf
Install fonts

Problem: wkhtmltopdf on 64 bit OS X

## Developing
Run 'guard' from command line

* Install WKHTMLTOPDF https://github.com/pdfkit/pdfkit/wiki/Installing-WKHTMLTOPDF

Chrome LivePage extension is very helpful - 2x monitors


## Fonts
The following fonts are available to use in invoices:
 * [Windows Server system fonts](https://www.microsoft.com/typography/fonts/product.aspx?PID=160)
 * The fonts in lib/fonts, including [Font Awesome](http://fortawesome.github.io/Font-Awesome/icons/) for iconography

These fonts are installed and available on our production servers.

**Important:** You must *install* the fonts in lib/fonts in order for previews to render correctly.
At the moment it is not possible to use external fonts (e.g. web fonts loaded via CSS) due to rendering issues with the PDF engine (wkhtmltopdf).


## Font combinations
Here's a few useful font combos (*heading + body*)
* Lobster + Cabin
* Montserrat + Neuton
* Montserrat + Cardo
* Montserrat + Playfair Display
* Lato + Merriweather
* Oswald + Quattrocento
* Dancing Script + EB Garamond
* Fjalla One + Cantarell
* Quicksand + EB Garamond