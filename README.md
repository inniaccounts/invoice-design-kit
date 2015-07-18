# inniAccounts Invoice Design Kit

## What is this?
This design kit allows you to create completely personalised invoice layouts to use within [inniAccounts](http://www.inniaccounts.co.uk). Invoice layouts are simply one or more HTML files and an [SCSS](http://sass-lang.com/guide) style file. You'll use [Liquid markup](http://liquidmarkup.org) in your HTML file to insert data from your invoice. Your HTML invoice layout will be transformed into a PDF by our servers using [wkhtmltopdf](http://wkhtmltopdf.org) - an open source PDF generator.

This kit contains Ruby scripts to help you develop your invoice: the scripts will create HTML and PDF previews of your layout.

***Note:*** *If you just want to change the colour or add a logo to an existing invoice layout then you don't need this kit - you can do this via the inniAccounts application. This kit is for confident HTML users who want to create custom layouts.*

## Quick start
* You'll need Ruby, Bundler & Git installed
* Fork this repository
* [Install wkhtmltopdf](https://github.com/pdfkit/pdfkit/wiki/Installing-WKHTMLTOPDF)
* Install fonts locally from [lib/fonts](lib/fonts)
* Run `bundle install` to install the Ruby Gems
* Run `guard` - this will watch source files in `invoice_designs` for changes and automagically output previews to `invoice_previews`

## Creating a layout
To create an invoice layout, simply create a new subdirectory in `invoice_designs` and give it a reasonable name. To get started, it's probably easier to base your layout on an existing one - copy `body.html`, `footer.html`, `header.html` and `style.scss` from another layout into your new directory. Guard should pick up the change and build a preview for you in `invoice_previews`. You can now hack away.

## Anatomy of a layout

### HTML templates
Your layout consists of three HTML files - the body, the header and the footer. The header and footer will be repeated on every page of your invoice. The body will be split over multiple pages, if needed. You should use [liquid markup](http://liquidmarkup.org) in your HTML to insert invoice data at run time, you'll also use Liquid tags to create the loop for outputting the invoice lines (i.e. `{% for Line in Invoice.Lines %}...`). You can view the data model for an invoice in [lib/data.yaml](lib/data.yaml).

### Stylesheet (style.scss)
You'll (obviously) use style.scss to apply formatting to your HTML. We use SCSS to allow you to set and use variable, plus, of course, write concise CSS. Your stylesheet *must* start with the following:

    /* Theme settings: */
    $name:                'My amazing invoice';
    $author:              'Cath Green, Camdle Ltd';
    $orientation:         'Portrait';
    $page-margin-top:     11.5cm;
    $page-margin-bottom:  1.5cm;
    $page-margin-left:    1cm;
    $page-margin-right:   1cm;

* The name and author will be shown in the layout picker in the inniAccounts app.
* Orientation: `Portrait` or `Landscape`
* Margins: *must* be specified in cm. The top and bottom margin determine the height of your header and footer.

There are four optional variables to allow the user to customise the fonts and colours used in your layout. The value of these can be set by the user when they choose their invoice layout in the app. If you use these variables in your stylesheet the user will be prompted to set them - if you don't, they won't appear in the user interface. It's a good idea to set some default values. The code block looks like this:

    /* User settings & defaults: */
    $font-title: Helvetica, sans-serif  !default;
    $font-body: Helvetica, sans-serif  !default;
    $color-primary: #DE4498 !default;
    $color-secondary: #333 !default;

In this case, by specifying these four variables, the user will be prompted to set them. Our invoice renderer will prepend your stylesheet at runtime with the user's values. That's why we're using `!default` above - it means that it will only use your default value if the user hasn't set one.

The final run-time variable is `$logo`. We'll base64 encode the user's logo image (if set) and prepend your stylesheet. To use the logo in your stylesheet, you can use code like this:

    @if $logo {
      #logo {
        content:$logo;
        max-width:350px;
        max-height:100px;
      }
    }

## Helpful hints

#### Header and footer sizing
If you'd like a 7cm header, a 4cm footer and a 1cm page margin then try the following in your stylesheet:

    $page-margin-top:     8cm; // 7 + 1
    $page-margin-bottom:  5cm; // 4 + 1
    $page-margin-left:    1cm;
    $page-margin-right:   1cm;

    section#header {
        margin-top:1cm;
        height:7cm;
    }

    section#footer {
        height:4cm;
        margin-bottom:1cm;
    }

#### Developing with a logo placeholder
Add this to the top of your stylesheet: `$logo: url('http://placehold.it/350x100')`

#### Guard problems?
If guard isn't working for you, you can also just issue a `rake` command to build your preview

#### Helpful browser extension
Chrome's LivePage extension is very helpful - it will automatically reload the preview page when you edit your source. It's great for dual monitor development.

#### Fonts
The following fonts are available to use in invoices:

* [Windows Server system fonts](https://www.microsoft.com/typography/fonts/product.aspx?PID=160)
* The fonts in lib/fonts, including [Font Awesome](http://fortawesome.github.io/Font-Awesome/icons/) for iconography

These fonts are installed and available on our production servers. At the moment it is not possible to use external fonts (e.g. web fonts loaded via CSS) due to rendering bugs with wkhtmltopdf.

#### Font combinations
Here's a few useful font combos *(heading + body)*

* Lobster + Cabin
* Montserrat + Neuton
* Montserrat + Cardo
* Montserrat + Playfair Display
* Lato + Merriweather
* Oswald + Quattrocento
* Dancing Script + EB Garamond
* Fjalla One + Cantarell
* Quicksand + EB Garamond

## Sharing your layouts
You can use this kit to create layouts for your own personal use. We also welcome high quality layouts to share with the rest of the inniAccounts community. If you'd like to share your design please issue a pull request and we'll take a look at your layout.