# app/services/yfinance_wrapper_service.rb
require "net/http"
require "json"

class YfinanceWrapperService
    YFINANCE_WRAPPER_BASE_URL = ENV["YFINANCE_WRAPPER_BASE_URL"]
    class Ticker
        def self.get_info(symbol)
            url = URI.parse("#{YFINANCE_WRAPPER_BASE_URL}/ticker/#{symbol}")
            response = Net::HTTP.get_response(url)

            if response.is_a?(Net::HTTPSuccess)
                JSON.parse(response.body)
            else
                JSON.parse("{'error': 'No data found'}")
            end
        end
    end
end
