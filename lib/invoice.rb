# THIS IS NOT USED!

class Invoice
  attr_accessor :Date
  attr_accessor :DateDue
  attr_accessor :InvoiceNumber
  attr_accessor :InvoiceNumberAndRef
  attr_accessor :InvoiceAddress     #2000
  attr_accessor :Description        #255
  attr_accessor :HeaderMessage      #2000
  attr_accessor :FooterMessage      #2000
  attr_accessor :AmountNet          #18,2
  attr_accessor :AmountVAT          #18,2
  attr_accessor :AmountTotal        #18,2
  attr_accessor :SupplyCountryName
  attr_accessor :InvoiceCurrencyName
  attr_accessor :InvoiceCurrencySymbol
  attr_accessor :GBPAmountVAT
  attr_accessor :GBPAmountNET
  attr_accessor :GBPAmountTotal

  attr_accessor :InvoiceLines

  def initialize
    @InvoiceLines = Array.new
  end
end


class InvoiceLine
  attr_accessor :Description  #255
  attr_accessor :Quantity     #18,2
  attr_accessor :UnitPrice    #18,2
  attr_accessor :AmountExVAT  #18,2
  attr_accessor :AmountVAT    #18,2
  attr_accessor :VATCode      #1
  attr_accessor :VATRate      #3,3
end