module Ctrl
  class App
    include Singleton

    ROOT = __dir__
    LOGGING_ENABLED = ENV.fetch('LOG_ENABLED', true)
    REDIS_URL = ENV.fetch('REDIS_URL')

    attr_reader :redis, :logger

    def initialize
      init_logger(LOGGING_ENABLED)
      init_redis
    end

    def run
      logger.info('Starting..')
      ::Bot::Listen.call
    end

    private

    def init_logger(enable)
      @logger = Logger.new(enable ? $stdout : '/dev/null')
      @logger.formatter = proc do |severity, datetime, _name, msg|
        "#{datetime.strftime('%Y/%m/%d %T')} #{severity}: #{msg}\n"
      end
    end

    def init_redis
      @redis = Redis.new(url: REDIS_URL)
    end
  end
end
