class StockService
  class Stock
    def self.get_info(stock)
      stock_data = {}
      if stock.stock_orders.present? && stock.stock_orders.any?
        total_units = stock.stock_orders.sum(:units)
        total_invested_amount = stock.stock_orders.sum { |order| order.units * order.unit_cost }
        stock_data.merge!({
          total_units: total_units,
          total_invested_amount: Money.from_amount(total_invested_amount, stock.currency),
          average_unit_cost: Money.from_amount(total_invested_amount / total_units, stock.currency)
        })
      end

      yfinance_data = YfinanceWrapperService::Ticker.get_info(stock.symbol)
      return stock_data if yfinance_data.key?("error")

      symbol_data = yfinance_data["data"]
      puts symbol_data

      stock_data.merge!(
        current_price: Money.from_amount(symbol_data["price"] || symbol_data["previous_close"], stock.currency),
        current_value: Money.from_amount((total_units || 0)* (symbol_data["price"] || symbol_data["previous_close"]), stock.currency)
      )

      if !symbol_data["day_change"].nil?
        stock_data[:day_change] = Money.from_amount(symbol_data["day_change"], stock.currency)
      end

      puts stock_data
      stock_data
    end

    def self.preview(symbol)
      yfinance_data = YfinanceWrapperService::Ticker.get_info(symbol)
      return {} if yfinance_data.key?("error")

      symbol_data = yfinance_data["data"]
      {
        name: symbol_data["name"],
        currency: symbol_data["currency"]
      }
    end
  end

  class Portfolio
    def self.history
      currencies = ::Stock.all.pluck(:currency).uniq
      portfolio_data = {}
      for currency in currencies
        stocks = ::Stock.where(currency: currency).uniq
        total_invested_amount = StockOrder.joins(:stock).where(stocks: { currency: currency }).sum("units * unit_cost")
        currency_object = Money::Currency.new(currency)
        portfolio_data[currency_object] = {
          total_invested_amount: Money.from_amount(total_invested_amount, currency),
          total_current_value: Money.from_amount(0, currency),
          stocks: stocks,
          chart_data: {
            symbols: [],
            symbols_history: {}
          }
        }

        stocks.each do |stock|
          stock_info = Stock.get_info(stock)
          next if stock_info.empty?
          portfolio_data[currency_object][:total_current_value] += stock_info[:current_value]
        end

        portfolio_data[currency_object][:diff] = portfolio_data[currency_object][:total_current_value] - portfolio_data[currency_object][:total_invested_amount]

        yfinance_data = YfinanceWrapperService::Portfolio.history(stocks.pluck(:symbol))
        next if yfinance_data.key?("error")

        yfinance_portfolio_data = yfinance_data["data"]
        stocks.each do |stock|
          symbol_data = yfinance_portfolio_data.find { |data| data["ticker"] == stock.symbol }
          next if symbol_data.nil?

          symbol_history = {}
          yfinance_history = symbol_data["history"]
          for date, value in yfinance_history
            units = StockOrder.joins(:stock).where(stocks: { symbol: stock.symbol }).where("date <= ?", date).sum(:units)
            next if units.zero?
            value = Money.from_amount(value * units, currency)
            symbol_history[date] = value
          end

          next if symbol_history.empty?
          portfolio_data[currency_object][:chart_data][:symbols] << { id: stock.id, symbol: stock.symbol, alias: stock.alias }
          for date, value in symbol_history
            portfolio_data[currency_object][:chart_data][:symbols_history][date] ||= {}
            portfolio_data[currency_object][:chart_data][:symbols_history][date][stock.id] = value.amount.to_f
          end

          portfolio_data[currency_object][:chart_data][:symbols_history] = portfolio_data[currency_object][:chart_data][:symbols_history].sort_by { |date, _| date }.to_h
        end
      end

      puts portfolio_data
      portfolio_data
    end
  end
end
