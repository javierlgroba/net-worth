# app/services/yfinance_wrapper_service.rb
require "net/http"
require "json"

class YfinanceWrapperService
    YFINANCE_WRAPPER_BASE_URL = ENV["YFINANCE_WRAPPER_BASE_URL"]
    class Ticker
        def self.get_info(symbol)
            begin
                url = URI.parse("#{YFINANCE_WRAPPER_BASE_URL}/tickers/#{symbol}")
                response = Net::HTTP.get_response(url)

                if response.is_a?(Net::HTTPSuccess)
                    JSON.parse(response.body)
                else
                    puts "Error: #{response.body}"
                    JSON.parse('{"error": "Couldn\'t fetch stock data"}')
                end
            rescue StandardError => e
                puts "Error: #{e}"
                JSON.parse('{"error": "Cannot connect to the Yfinance Wrapper service"}')
            end
        end
    end

    class Portfolio
        def self.history(symbols)
            begin
                url = URI.parse("#{YFINANCE_WRAPPER_BASE_URL}/tickers/history?interval=1wk&q=#{symbols.join("&q=")}")
                response = Net::HTTP.get_response(url)

                if response.is_a?(Net::HTTPSuccess)
                    JSON.parse(response.body)
                else
                    puts "Error: #{response.body}"
                    JSON.parse('{"error": "Error fetching portfolio data"}')
                end
            rescue StandardError => e
                puts "Error: #{e}"
                JSON.parse('{"error": "Cannot connect to the Yfinance Wrapper service"}')
            end
        end
    end
end
