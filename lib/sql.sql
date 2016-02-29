UPDATE InvoiceTemplate SET
Name='Classic', 
SCSS='/* Theme settings: */
$name:                ''Classic'';
$author:              ''inniAccounts'';
$orientation:         ''Portrait'';
$page-margin-top:     11.5cm;
$page-margin-bottom:  1.5cm;
$page-margin-left:    1cm;
$page-margin-right:   1cm;
 
/* User settings & defaults: */
$font-title: Arial, sans-serif  !default;
$font-body: Arial, sans-serif  !default;
$color-primary: #000066 !default;
$logo: false !default;  // url(''http://placehold.it/350x100'')

body {
  font: 17px/1.1 $font-body;
  margin: 0;
  padding: 1px; // Intentional: to allow table borders to render correctly
  width:920px;
}

h2 {
  font-family:  $font-title;
  font-size:inherit;
  font-weight: bold;
  margin:0;
  text-transform: uppercase;
}

table {
  border-collapse: collapse;
  td, th {
    padding: 7px;
  }
  th {
    background-color:$color-primary;
    color:white;
    font-family: $font-title;
  }
}


section#header {
  height: 12cm;//($page-margin-top - 1.5cm) * 1.33;
  position: relative;

  // Clearfix:
  &:after {
    content: "";
    display: table;
    clear: both;
  }

  #identity {
    max-width:50%;
    float:left;
    min-height: 200px;

    @if $logo {
      .logo {
        content:$logo;
        max-width:465px;
        max-height:133px;
        margin-bottom: 1em;
      }
    }

    .company-name {
      font-weight: bold;
      font-family: $font-title;
    }
    .phone {
      margin-top:13px;
    }
  }

  #meta {
    max-width:40%;
    float:right;
    text-align: center;

    h1  {
      text-align: center;
      font: 43px/1.1 $font-title;
      font-weight: bold ;
      color:$color-primary;
      margin:0;
      padding-top:1em;
      padding-bottom: 4px;
    }

    table {
      font-size:17px;

      td, th {
        border:1px solid black;
        text-align: center;
        padding:4px;
      }
    }

  }

  #customer {
    margin-top:1em;
    clear:both;
    float:left;
    width:55%;
  }

  #notes {
    margin-top:1em;
    float:left;
  }

  #description {
    font-size:21px;
    font-weight: bold;
    margin-bottom:0px;
    position:absolute;
    bottom:0;
    width:100%;
    font-family: $font-title;
  }

}


section#lines {

  table {
    width: 100%;
    margin:0;
    border-bottom: 1px solid black;

    thead {display: table-header-group;}

    // The tfoot is an empty row - it''s used to ensure the black bottom
    // border appears on each page
    tfoot {
      display: table-footer-group;
      td {
        font-size: 0.1px !important;
        padding:0 !important;

      }
    }
    // Global styles:
    tr {
      height: 26px;
      page-break-inside: avoid;
      th {
        border:1px solid black;
      }

      td {
        border-left: 1px solid black;
        border-right: 1px solid black;
        vertical-align: top;

        &.qty, &.vatrate {
          text-align: center;
        }

        &.unit, &.price {
          text-align: right;
        }

      }

      td, th {
        font-size:17px;
      }
    }

    th {
      &.description {
        text-align: left;
        width: auto;
      }

      &.qty, &.vatrate {
        width: 63px;
      }
      &.unit, &.price {
        width: 106px;
      }
    }

    tbody {
      tr:nth-child(2n+1) td {
        background-color: #eeeeee;
      }
    }

  }

}

section#totals {
  margin-top:3px;

  table {
    float: right;
    page-break-inside: avoid;
    td {
      width:110px;
      font-size:17px;
      text-align: right;
      border:1px solid black;

      &.label {font-size:13px; text-transform: uppercase}

    }

    tr.subtotal {
    }

    tr.vat {
    }

    tr.total td {
      &.label {font-size:13px; text-transform: uppercase; font-weight: bold;}
      font-size:23px;
    }
  }

  td.base {
    display: none;
  }

  &.non-gbp-invoice {
    td.base {
      display: table-cell;
    }
  }

}

section#footer {
  padding-top: 0.5cm;
  height: $page-margin-bottom;
  clear:both;
  font-size:13px;
  width:100%;
}

', 
Header='<section id="header">

    <div id="identity">
        <div class="logo"></div>
        <div class="company-name">
            {{Invoice.CompanyName}}
        </div>
        <div class="address">
            {{Invoice.CompanyAddress | newline_to_br}}
        </div>
        <div class="phone">
            <label>Phone: &nbsp; </label>{{Invoice.CompanyPhone}}
        </div>
        <div class="email">
            <label>Email: &nbsp; </label>{{Invoice.CompanyEmail}}
        </div>
    </div>

    <div id="meta">
        <h1>INVOICE</h1>
        <table>
            <thead>
            <tr>
                <th>INVOICE #</th>
                {% if Invoice.InvoiceReference %}
                <th>INVOICE REF</th>
                {% endif %}
                <th>DATE</th>
                <th>DUE</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>{{Invoice.InvoiceNumber}}</td>
                {% if Invoice.InvoiceReference %}
                <td>{{Invoice.InvoiceReference}}</td>
                {% endif %}
                <td>{{Invoice.Date | date: ''%d/%m/%Y'' }}</td>
                <td>{{Invoice.DateDue | date: ''%d/%m/%Y'' }}</td>
            </tr>
            </tbody>
        </table>
    </div>

    <div id="customer">
        <h2>Invoice to:</h2>
        <div class="address">{{Invoice.InvoiceAddress | newline_to_br}}</div>
    </div>

    <div id="notes">
        <h2>Notes:</h2>
        <div>
            {{Invoice.InvoiceMessage | newline_to_br}}
        </div>
    </div>

    <div id="description" >
        {{Invoice.Description}}
    </div>

</section>', 
Body='<section id="lines">
    <table>
        <thead>
            <tr>
                <th class="description">Description</th>
                <th class="qty">Qty</th>
                <th class="vatrate">VAT</th>
                <th class="unit">Unit</th>
                <th class="price">Total</th>
            </tr>
        </thead>
        <tbody>
            {% for Line in Invoice.Lines %}
            <tr class="item-row">
                <td class="description">{{Line.Description}}</td>
                <td class="qty">{{Line.Quantity}}</td>
                <td class="vatrate">{{Line.VATRate}}</td>
                <td class="unit">{{Line.UnitPrice}}</td>
                <td class="price">{{Line.AmountExVAT}}</td>
            </tr>
            {% endfor %}
            {% if forloop.length < 10  %}
            <tr class="filler">
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
            </tr>
            {% endif %}
        </tbody>
        <tfoot>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        </tfoot>
    </table>
</section>

<section id="totals" {% if Invoice.NonGBPVatInvoice %} class="non-gbp-invoice"{% endif %}>


    <table>
        <tr class="subtotal">
            <td class="label">Subtotal</td>
            <td class="gbp">{{Invoice.AmountNetGBP}}</td>
            <td class="base">{{Invoice.AmountNet}}</td>
        </tr>
        <tr class="vat">
            <td class="label">VAT</td>
            <td class="gbp">{{Invoice.AmountVATGBP}}</td>
            <td class="base">{{Invoice.AmountVAT}}</td>
        </tr>
        <tr class="total">
            <td class="label">Total</td>
            <td class="gbp">{{Invoice.AmountTotalGBP}}</td>
            <td class="base">{{Invoice.AmountTotal}}</td>
        </tr>
    </table>



</section>

', 
Footer='<section id="footer">
    {{Invoice.LegalFooter}}
</section>'
WHERE id=4;
UPDATE InvoiceTemplate SET
Name='Blend', 
SCSS='/* Theme settings: */
$name:                ''Blend'';
$author:              ''inniAccounts'';
$orientation:         ''Portrait'';
$page-margin-top:     10cm;
$page-margin-bottom:  2cm;
$page-margin-left:    1cm;
$page-margin-right:   1cm;

/* User settings & defaults: */
$font-title: Arial, sans-serif  !default;
$font-body: Arial, sans-serif  !default;
$color-primary: #882251 !default;
$color-secondary: #333 !default;
$logo: false !default;

$border-color: change-color($color-secondary, $lightness: 70);

$base-font-size:17px;

//
// $logo: url(''http://placehold.it/350x100'');

body {
  font: $base-font-size $font-body;
  line-height: 1.1em;
  margin: 0;
  padding: 1px; // Intentional: to allow table borders to render correctly
  vertical-align: top;
  height:100%;
  width:920px;
}

h2 {
  font-family:  $font-title;
  font-size:inherit;
  font-weight: bold;
  margin:0;
  text-transform: uppercase;
}

table {
  border-collapse: collapse;
  td, th {
    padding: 5px;
  }
  th {
    font-family: $font-title;
  }
}


section#header {
  //margin-top:1.5cm * 1.33;
  //height:8.5cm * 1.33;
  height:10.5cm;

  // Clearfix:
  &:after {
    content: "";
    display: table;
    clear: both;
  }

  .left {
    width:49%;
    float: left;
  }
  .right {
    width:49%;
    float: right;
  }

  @if $logo {
    #logo {
      content:$logo;
      max-width:350px;
      max-height:100px;
      margin-bottom: 1em;
    }
  }

  #company {
    color:$color-secondary;
  }

  #customer {
    margin-top:1em;
    color:$color-secondary;
  }

  #icons {
    width:100%;

    th, td {
      text-align: left;
      color: change-color($color-secondary, $lightness: 60);
      font-size:13px;
      padding:0 0 0.6em 0;
    }
    th {width:1.5em;}

    border-bottom: 1px solid $border-color;

  }

  h1 {
    text-align: left;
    font: 71px/1 $font-title;
    font-weight: bold ;
    color:$color-primary;
    margin:$base-font-size*2 0;
  }

  table#meta {
    width:100%;
    font-size:$base-font-size;
    background-color:$color-primary;

    td, th {
      color:white;
      text-align: left;
      padding:0;
      padding-left: $base-font-size;
    }

    td {
      padding-bottom:$base-font-size;
      font-size:$base-font-size;
      font-weight: bold;
      font-family: $font-title;
    }
    th {
      padding-top:$base-font-size;
      font-size:$base-font-size;
      font-weight: normal;
    }

  }

  #description {
    font-size:$base-font-size;
    margin:1em 0 0 0;
    font-family: $font-body;
    color:$color-secondary;
  }

}


section#lines {

  table {
    width: 100%;
    margin:0;

    thead {display: table-header-group;}

    tr {
      page-break-inside: avoid;


      td {
        font-size:$base-font-size;
        vertical-align: top;
        padding:5px 0;
        color:$color-secondary;
      }

      td:first-child {
        padding-left: 3px;
      }
      td:last-child  {
        padding-right: 3px;
      }

      th {
        font-size:$base-font-size;
        color:$color-primary;
        padding:4px 0;
        border-bottom: 1px solid $color-primary;

        &.description {
          text-align: left;
          width: auto;
        }

        &.qty, &.vatrate {
          width: 48px;
        }
        &.unit, &.price {
          width: 80px;
        }
      }

      .qty, .vatrate {
        text-align: center;
      }

      .unit, .price {
        text-align: right;
      }
    }


    tbody {
      tr:nth-child(2n+1) td {
        background-color: change-color($color-secondary, $lightness: 95);
      }
    }

  }

}

section#totals {

  table {
    float: right;
    font-family: $font-title;
    page-break-inside: avoid;


    td {
      width:77px;
      font-size:17px;
      text-align: right;
      padding: 5px 0;
      color: $color-secondary;

      &.label {
        font-weight:bold;
      }

      &.base {
        display: none;
      }

      &.base, &.gbp {
        padding-right: 3px;
      }

    }

    tr.total {
      background-color: $color-primary;

      td {
        &.label {
          //font-size: 23px;
          font-weight: bold;
        }
        padding-top:8px;
        padding-bottom:8px;
        background-color: $color-primary;
        color: white;
        //font-size: 23px;
      }
    }
  }


  &.non-gbp-invoice {
    td.base {
      display: table-cell;
    }
    td.gbp {
      padding-right:0;
    }
  }

}

section#notes {
  padding-top:1em;

  h2, div {
    color:$color-secondary;
  }
}

section#footer {
  font-size:13px;
  width:100%;
  height:1cm;
  margin-bottom:1cm;
  clear:both;

  #line {
    div {
      background: linear-gradient(90deg, $color-primary, lighten($color-primary, 20%));
      background: -webkit-linear-gradient(left, $color-primary, lighten($color-primary, 20%));
      display: block;
      min-height:5px;
    }

    #l1 {
      float:left;
      width:30%;
    }

    #l2 {
      float:right;
      width:70%;
    }


  }

  #legal {
    clear:both;
    padding-top:1em;
    margin:0 auto;
    max-width: 60%;
    text-align: center;
    color:change-color($color-secondary, $lightness: 50);
  }
}
', 
Header='<section id="header">
    <div class="left">
        <div id="logo"></div>
        <div id="company">
            <h2>{{Invoice.CompanyName}}</h2>
            <div class="address">
                {{Invoice.CompanyAddress | newline_to_br}}
            </div>
        </div>
        <div id="customer">
            <h2>Invoice to:</h2>
            <div class="address">
                {{Invoice.InvoiceAddress | newline_to_br}}
            </div>
        </div>
    </div>
    <div class="right">
        <table id="icons">
            {% if Invoice.CompanyPhone %}
            <tr>
                <th><i class="fa fa-phone"></i></th>
                <td>{{Invoice.CompanyPhone}}</td>
            </tr>
            {% endif %}
            {% if Invoice.CompanyEmail %}
            <tr>
                <th><i class="fa fa-envelope"></i></th>
                <td>{{Invoice.CompanyEmail}}</td>
            </tr>
            {% endif %}
            {% if Invoice.CompanyURL %}
            <tr>
                <th><i class="fa fa-globe"></i></th>
                <td>{{Invoice.CompanyURL}}</td>
            </tr>
            {% endif %}
        </table>
        <h1>INVOICE</h1>
        <table id="meta">
            <thead>
            <tr>
                <th>Number</th>
                {% if Invoice.InvoiceReference %}
                <th>Reference</th>
                {% endif %}
                <th>Issued</th>
                <th>Due</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>{{Invoice.InvoiceNumber}}</td>
                {% if Invoice.InvoiceReference %}
                <td>{{Invoice.InvoiceReference}}</td>
                {% endif %}
                <td>{{Invoice.Date | date: ''%d/%m/%Y'' }}</td>
                <td>{{Invoice.DateDue | date: ''%d/%m/%Y'' }}</td>
            </tr>
            </tbody>
        </table>
        <div id="description" >
            {{Invoice.Description}}
        </div>
    </div>
</section>
', 
Body='<section id="lines">
    <table>
        <thead>
            <tr>
                <th class="description">Description</th>
                <th class="qty">Qty</th>
                <th class="vatrate">VAT</th>
                <th class="unit">Unit</th>
                <th class="price">Total</th>
            </tr>
        </thead>
        <tbody>
            {% for Line in Invoice.Lines %}
            <tr class="item-row">
                <td class="description">{{Line.Description}}</td>
                <td class="qty">{{Line.Quantity}}</td>
                <td class="vatrate">{{Line.VATRate}}</td>
                <td class="unit">{{Line.UnitPrice}}</td>
                <td class="price">{{Line.AmountExVAT}}</td>
            </tr>
            {% endfor %}
        </tbody>
    </table>
</section>

<section id="totals" {% if Invoice.NonGBPVatInvoice %} class="non-gbp-invoice"{% endif %}>
    <table>
        <tr class="subtotal">
            <td class="label">Subtotal</td>
            <td class="gbp">{{Invoice.AmountNetGBP}}</td>
            <td class="base">{{Invoice.AmountNet}}</td>
        </tr>
        <tr class="vat">
            <td class="label">VAT</td>
            <td class="gbp">{{Invoice.AmountVATGBP}}</td>
            <td class="base">{{Invoice.AmountVAT}}</td>
        </tr>
        <tr class="total">
            <td class="label">Total</td>
            <td class="gbp">{{Invoice.AmountTotalGBP}}</td>
            <td class="base">{{Invoice.AmountTotal}}</td>
        </tr>
    </table>
</section>

{% if Invoice.InvoiceMessage %}
<section id="notes">
    <h2>Notes:</h2>
    <div>
        {{Invoice.InvoiceMessage | newline_to_br}}
    </div>
</section>
{% endif %}', 
Footer='<section id="footer">
    <div id="line">
        <div id="l1"></div>
        <div id="l2"></div>
    </div>
    <div id="legal">
        {{Invoice.LegalFooter}}
    </div>
</section>'
WHERE id=5;
INSERT INTO InvoiceTemplate (Name,SCSS,Header,Body,Footer) VALUES (
'Stripe',
'/* Theme settings: */
$name:                ''Stripe'';
$author:              ''inniAccounts'';
$orientation:         ''Portrait'';
$page-margin-top:     12.2cm;
$page-margin-bottom:  3.8cm;
$page-margin-left:    1cm;
$page-margin-right:   1cm;

/* User settings & defaults: */
$font-title: Arial, sans-serif  !default;
$font-body: Arial, sans-serif  !default;
$color-primary: #52c0e8 !default;
$color-secondary: #231f20 !default;
$logo: false !default;
$bg-primary: #f3f3f4;
$left-col-width: 55px;


body {
  font: 14px $font-body;
  line-height: 15px;
  margin: 0;
  position: relative;
  //OSX height: 100%;
  color: $color-secondary;
}

.clearfix {
  clear: both;
}

.title {
  color: $color-primary;
}

.bg-primary {
  background-color: $color-primary;
  color: #fff;
}

.blue-bg {
  display: inline-block;
  background-color: $color-primary;
  width: $left-col-width;
  height: 100%;
}

.empty-space {
  position: absolute;
  height: 100%;

  .blue-bg {
    margin-left: 0;
  }
}

table {
  border-collapse: collapse;
//  border-spacing: 2px;
//  border-collapse: separate;

  td {
    padding: 15px 10px 15px 25px;
    vertical-align: top;

    &:first-child {
      width: $left-col-width;
      text-align: center;
      font-size: 18px;
      padding-right: 0;
      padding-left: 0;
      vertical-align: middle;
    }
  }

  th {
    color: $color-primary;
    background-color: white;
    font-family: $font-title;
  }

  td, th {
    text-align: left;
  }
}


section#header {
  //height:12.2cm;
  height:100%;
  // Setting height of 100% works well, on windows at least
  // content is aligned to top of header, plus there''s (oddly) a margin too
  position: relative;
  width: auto;
  //display: none;

  // Clearfix:
  &:after {
    content: "";
    display: table;
    clear: both;
  }

  .grey-bg {
    top: 0;
    right: 0;
    left: 0;
  }

  #identity {
    //OSX min-height: 200px;
    width: 100%;
    margin-bottom: 40px;
    margin-top: 50px;

    @if $logo {
      .logo {
        content: $logo;
        max-width: 5cm;
        height: 1.5cm;
        background-color: #e2e3e4;
        float: left;
      }

      .company-name {
        display: none;
      }
    }

    .company-name {
      float: left;
      font-family: $font-title;
      font-size: 22px;
      padding: 20px;
      background-color: #e3e3e4;
      margin-right: 5px;
      text-transform: uppercase;
    }

    .reference-block {
      font-size: 35px;
      padding-top: 15px;
      color: $color-secondary;
      float: right;
      height: 1.2cm;

      .reference {
        display: inline-block;

        .invoice-number {
          font-size: 12px;
          text-align: right;
          margin-top: 10px;
        }
      }
    }
  }

  table.company-info {
    margin-top: 40px;
    width: 100%;
    color: $color-secondary;

    .color-line {
      height: 3px;

      td {
        background-color: $bg-primary;
        padding: 0;
      }
    }

    td {
      border: none;
      border-top: 5px solid white;
      border-bottom: 5px solid white;
      padding: 25px 0 25px 25px;

      &:first-child {
        padding: 0;
      }

      &.title {
        width: 70px;
      }

      &.from {
        width: 100px;
      }
    }
  }
}

#items {
  float: left;
  width: 100%;
  position: relative;

  .empty-space {
    position: absolute;
  }

  &:after {
    content: "";
    display: table;
    clear: both;
  }

  table {
    width: 100%;
    margin: 0;

    thead {
      display: table-header-group;

      tr {

        th {
//          border-left: 3px solid #fff;
 //         border-right: 3px solid #fff;
  //        border-bottom: 3px solid $color-primary;
          font-weight: normal;
          background-color: white;
          padding:15px;

          &.number {
            text-align: center;
          }
          &:first-child {
            border-left:none;
          }
        }


      }

    }

    .color-line {
      font-size:0px;

      td {
        background-color: $color-primary;
        padding: 0;
        height: 3px;
      }
    }

    tr {
      page-break-inside: avoid;
      td {
        background-color: #f3f3f4;
        border: 3px solid #fff;

        &:first-child {
          border-left: none;
        }

        &:last-child {
          border-right: none;
        }

        &.bg-primary {
          background-color: $color-primary;
        }
      }

      &:last-child {
        border-bottom: none;
      }


      .description {
        padding-left: 27px;
      }

      .qty, .vatrate, .unit, .price {
        text-align: right;
        padding-right: 10px;
        padding-left: 10px;
        width: 80px;
      }


    }
  }
  #lines {
    position: relative;
  }

  #totals {
    tr:first-child {
      td {
        //border-top: 3px solid $color-primary;
      }
    }

    tr:last-child {
      td {
        border-bottom: none;
      }
    }

    .gbp-row {
      &.net-gbp td {
        padding-top: 10px;
      }

      td {
        color: $color-secondary;
        font-size: 13px;
        padding-top: 2px;
        padding-bottom: 2px;
      }
    }

    td {
      text-align: right;
      border-bottom: none;

      &.bg-primary {
        border-top-color: $color-primary;
      }

      &.title {
        background-color: white;
        width: 530px;
        padding-right: 30px;
      }

      &.total {
        font-size: 23px;
      }

      &.label {
        padding-right: 0;
        background-color: white;
      }

      &.gbp {
        background-color: white;
      }
      &.no-fill {
        background-color: transparent;
      }
    }
  }
}

.grey-bg {
  background-color: $bg-primary;
  height: 1cm;
}

.wrapper, #lines, #totals, #message {
}

#message {
  border-top: 5px solid white;
  border-bottom: 5px solid white;
  color: #6d6e71;
  font-size: 12px;
}

section#footer {
  height: $page-margin-bottom;
  clear: both;
  font-size: 13px;
  width: 100%;

  .grey-bg-footer {
    margin-top: 1cm;
    position: relative;
    bottom: 0;
    width: 100%;
  }
}
',
'<section id="header">
    <!--<div class="grey-bg">
        <div class="blue-bg"></div>
    </div>-->
    <div class="wrapper">
        <div id="identity">
            <div class="main-title">
                <div class="logo"></div>
                <div class="company-name">
                    {{Invoice.CompanyName}}
                </div>
                <div class="reference-block">
                    <div class="reference">
                        Invoice
                        {% if Invoice.InvoiceReference %}
                            {{Invoice.InvoiceReference}}
                            <div class="invoice-number">{{Invoice.InvoiceNumber}}</div>
                        {% else %}
                            {{Invoice.InvoiceNumber}}
                        {% endif %}
                    </div>
                </div>
                <div class="clearfix"></div>
            </div>
            <table class="company-info">
                <tbody>
                    <tr class="color-line"><td colspan="5"></td></tr>
                    <tr>
                        <td class="bg-primary"><i class="fa fa-envelope"></i></td>
                        <td class="title align-top">From:</td>
                        <td class="from align-top">
                            {{Invoice.CompanyName}}<br>
                            {{Invoice.CompanyAddress | newline_to_br}}<br>
                            {{Invoice.CompanyEmail}}<br>
                            {{Invoice.CompanyPhone}}
                        </td>
                        <td class="title align-top">To:</td>
                        <td class="align-top">{{Invoice.InvoiceAddress | newline_to_br}}</td>
                    </tr>
                    <tr class="color-line"><td colspan="5"></td></tr>
                    <tr>
                        <td class="bg-primary"><i class="fa fa-calendar"></i></td>
                        <td class="title">Date:</td>
                        <td>{{Invoice.Date | date: ''%d/%m/%Y''}}</td>
                        <td class="title">Due date:</td>
                        <td>{{Invoice.DateDue | date: ''%d/%m/%Y''}}</td>
                    </tr>
                    <tr class="color-line"><td colspan="5"></td></tr>
                    <tr>
                        <td class="bg-primary"><i class="fa fa-file-text-o"></i></td>
                        <td colspan="4">{{Invoice.Description}}</td>
                    </tr>
                    <tr class="color-line"><td colspan="5"></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</section>
',
'<section id="items">
    <div id="lines">
        <table>
            <thead>
                <tr>
                    <th class="number">No.</th>
                    <th class="description">Item</th>
                    <th class="qty">Quantity</th>
                    <th class="vatrate">VAT</th>
                    <th class="unit">Price</th>
                    <th class="price">Total</th>
                </tr>
                <tr class="color-line"><td colspan="6"></td></tr>
            </thead>
            <tbody>

                {% for Line in Invoice.Lines %}
                    <tr class="item-row">
                        <td class="number bg-primary">{{forloop.index}}</td>
                        <td class="description">{{Line.Description}}</td>
                        <td class="qty">{{Line.Quantity}}</td>
                        <td class="vatrate">{{Line.VATRate}}</td>
                        <td class="unit">{{Line.UnitPrice}}</td>
                        <td class="price">{{Line.AmountExVAT}}</td>
                    </tr>
                {% endfor %}
                <tr class="color-line"><td colspan="6"></td></tr>
            </tbody>
        </table>
    </div>
    <div class="wrapper">
        {% assign net = Invoice.AmountNetGBP %}
        {% assign vat = Invoice.AmountVATGBP %}
        {% assign total = Invoice.AmountTotalGBP %}

        {% if Invoice.NonGBPVatInvoice %}
            {% assign net = Invoice.AmountNet %}
            {% assign vat = Invoice.AmountVAT %}
            {% assign total = Invoice.AmountTotal %}
        {% endif %}
        <table id="totals">
            <tbody>
                <tr>
                    <td class="no-fill"></td>
                    <td class="title">Net:</td>
                    <td colspan="2">{{ net }}</td>
                </tr>
                <tr>
                    <td class="no-fill"></td>
                    <td class="title">VAT:</td>
                    <td colspan="2">{{ vat }}</td>
                </tr>
                <tr>
                    <td class="no-fill"></td>
                    <td class="title">Total:</td>
                    <td class="total bg-primary" colspan="2">{{ total }}</td>
                </tr>
                {% if Invoice.NonGBPVatInvoice %}
                    <tr class="gbp-row net-gbp">
                        <td class="no-fill"></td>
                        <td class="title"></td>
                        <td class="label">Net (GBP):</td>
                        <td class="gbp">{{Invoice.AmountNetGBP}}</td>
                    </tr>
                    <tr class="gbp-row">
                        <td class="no-fill"></td>
                        <td class="title"></td>
                        <td class="label">VAT (GBP):</td>
                        <td class="gbp">{{Invoice.AmountVATGBP}}</td>
                    </tr>
                    <tr class="gbp-row">
                        <td class="no-fill"></td>
                        <td class="title"></td>
                        <td class="label">Total (GBP):</td>
                        <td class="gbp">{{Invoice.AmountTotalGBP}}</td>
                    </tr>
                {% endif %}
            </tbody>
        </table>
    </div>
</section>
',
'<table id="message">
    <tbody>
        <tr>
            <td class="bg-primary"><i class="fa fa-info-circle"></i></td>
            <td>
                {{Invoice.InvoiceMessage | newline_to_br}}
                <br/>
                {{Invoice.LegalFooter}}
            </td>
        </tr>
    </tbody>
</table>
<!--<div class="wrapper empty-space">
    <div class="blue-bg"></div>
</div>
<section id="footer">
    <div class="grey-bg grey-bg-footer">
        <div class="blue-bg"></div>
    </div>
</section>-->
')
