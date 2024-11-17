class FormatService
  def self.currency_format
    I18n.t :format, scope: "number.currency.format"
  end

  def self.format_currency(amount, currency)
    Money.from_amount(amount, currency).format(format: currency_format)
  end

  def self.prefix(symbol)
    symbol = symbol.to_s.upcase
    format = I18n.t :preffix, scope: "number.currency.format"
    format.gsub("%u", symbol)
  end

  def self.grouping_symbol
    I18n.t :delimiter, scope: "number.currency.format"
  end

  def self.decimal_symbol
    I18n.t :separator, scope: "number.currency.format"
  end

  def self.suffix(symbol)
    symbol = symbol.to_s.upcase
    format = I18n.t :suffix, scope: "number.currency.format"
    format.gsub("%u", symbol)
  end
end
