module DepositHelper
  def self.maturity_date(deposit)
    deposit.maturity_date.strftime("%d/%m/%Y") # TODO: use I18n
  end

  def self.start_of_next_month
    Date.today.next_month.beginning_of_month.strftime("%d/%m/%Y") # TODO: use I18n
  end
  def self.duration(deposit)
    (deposit.maturity_date.year * 12 + deposit.maturity_date.month) - (deposit.open_date.year * 12 + deposit.open_date.month)
  end

  def self.tax(deposit, value)
    value * deposit.tax / 100
  end

  def self.value_increase(deposit, months)
    year_value_increase = deposit.start_balance * deposit.apr / 100
    year_value_increase * months / 12
  end

  def self.value_increase_with_maturity(deposit)
    duration_in_months = duration(deposit)
    value_increase(deposit, duration_in_months)
  end

  def self.value_at_maturity(deposit)
    value_increase = value_increase_with_maturity(deposit)
    tax = tax(deposit, value_increase)
    deposit.start_balance + value_increase - tax
  end

  def self.value_next_month(deposit)
    value_increase = value_increase(deposit, 1)
    tax = tax(deposit, value_increase)
    deposit.start_balance + value_increase - tax
  end

  def self.get_deposit_value(deposit)
    if deposit.maturity_date.present?
      value_increase = value_increase_with_maturity(deposit)
      {
        value: FormatService.format_currency(value_at_maturity(deposit), deposit.currency),
        tax: FormatService.format_currency(tax(deposit, value_increase), deposit.currency),
        value_increase: FormatService.format_currency(value_increase, deposit.currency),
        value_date: maturity_date(deposit)
      }
    else
      value_increase = value_increase(deposit, 1)
      {
        value: FormatService.format_currency(value_next_month(deposit), deposit.currency),
        tax: FormatService.format_currency(tax(deposit, value_increase), deposit.currency),
        value_increase: FormatService.format_currency(value_increase, deposit.currency),
        value_date: start_of_next_month
      }
    end
  end
end
