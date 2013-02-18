# PrawnCocktail

Simple views, templates and helpers on top of Prawn in Ruby on Rails.

Because writing Prawn documents PHP 4 style is no fun.

Ruby 1.9 only.

NOTE: Work in progress; well used but untested.

![](http://upload.wikimedia.org/wikipedia/commons/f/f8/Cocktail_1_bg_060702.jpg)

## TODO

* Tests.
* Syntax to declare page size shorthands?
* Look into what dependencies to declare. Rails? Active Support?
* Include instead of inherit? Consider `class_attribute`.

## Usage

### Controller

Your controllers get a `send_pdf` method:

``` ruby
class InvoiceController < ApplicationController
  def show
    invoice = Invoice.find(params[:id])
    document = InvoiceDocument.new(invoice)
    send_pdf document
  end
end
```

### View

Against Rails conventions, but in line with the idea of [two-step views](http://martinfowler.com/eaaCatalog/twoStepView.html), we think of these as "views" as opposed to "templates".

Build your view data in a document class:

``` ruby
# app/documents/invoice_document.rb

class InvoiceDocument < PrawnCocktail::Document
  def initialize(invoice)
    @invoice = invoice
  end

  def filename
    "invoice_#{@invoice.id}"
  end

  private

  def data
    {
      number: @invoice.id,
      amount: @invoice.amount,
      customer_name: @invoice.customer_name
    }
  end
end
```

The document has `render` and `render_file(name)` methods, just like `Prawn::Document`.

The filename, if defined, is used when generating the document. The `data` value is passed to the template as an `OpenStruct`.

If the data becomes complex, you are advised to extract one or many builder classes like `InvoiceDocument::Data` and call those from `data`.

### Template

Put the Prawn code in a template named after the view:

``` ruby
# app/views/documents/invoice_document.pdf.rb

meta page_size: "A4"

content do |data|
  text "Invoice #{data.number}"
  move_down 10
  text "Amount: #{data.amount}"
  move_down 10
  text data.customer_name
end
```

The `meta` declaration is optional. It takes a hash which will be passed to `Prawn::Document.new`. This is where you specify `page_size`, `page_layout` and such.

The `content` block will be passed the data from the document as an `OpenStruct`, and will be rendered in the context of a `Prawn::Document` instance.

### Helpers

You are advised to extract any complexity or shared code out of the template and into helpers:

``` ruby
# app/documents/invoice_document.rb

class InvoiceDocument
  helper BaseDocumentHelper
  helper InvoiceDocumentHelper
end
```

``` ruby
# app/views/documents/invoice_document.pdf.rb

content do |data|
  common_header
  text "Yo."
end
```

``` ruby
# app/documents/helpers/base_document_helper.rb

module BaseDocumentHelper
  def common_header
    text "Document generated #{Time.now}."
  end
end
```

Note that you must explicitly declare the helpers you want. No helpers are automatically included.

You can declare base helpers in a base document class, though, and that will be inherited.

### `initialize_document`

If you want to run some code in every document, use an `initialize_document` block:

``` ruby
class BaseDocument < PrawnCocktail::Document
  initialize_document do
    font "Courier"
  end
end
```

This is incidentally how helper modules are implemented. They simply extend the document instance in such a block.

## Installation

Add this line to your application's Gemfile:

    gem 'prawn_cocktail'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prawn_cocktail

## License

Copyright (c) 2013 [Barsoom AB](http://barsoom.se)

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
