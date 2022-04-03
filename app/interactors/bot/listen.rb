module Bot
  class Listen < ::ApplicationInteractor
    HANDLERS = {
      '/start' => ::Handlers::Start,
      '/add' => ::Handlers::Targets::Create,
      '/rm' => ::Handlers::Targets::Remove,
      '/ls' => ::Handlers::Targets::List,
      '/bulk' => ::Handlers::Targets::ItArmyBulkCallback,
      '/flush' => ::Handlers::Targets::Flush
    }.freeze
    CALLBACKS = [
      ::Handlers::Targets::ItArmyBulk
    ].freeze
    TOKEN = ENV.fetch('BOT_TOKEN')
    OWNER_ID = ENV.fetch('OWNER_ID').to_i

    def call
      ::Telegram::Bot::Client.run(TOKEN) do |bot|
        bot.listen do |message|
          handle!(bot, message) if from_owner?(message)
        end
      end
    end

    private

    def handle!(bot, message)
      callback = current_callback
      if callback
        logger.info("CALLBACK: #{callback}")
        callback.call(bot:, message:, text: message.text)
      else
        logger.info("CMD: #{message.text}")
        handle_message(bot, message)
      end
    end

    def handle_message(bot, message)
      cmd, text = cmd_text(message)
      handler = self.class::HANDLERS[cmd]
      handler ||= ::Handlers::Unknown
      handler.call(bot:, message:, text:)
    end

    def current_callback
      CALLBACKS.find { |callback| redis.get(callback::REDIS_KEY) }
    end

    def cmd_text(message)
      cmd = message.text.scan(%r{^/\w+\s*}).first&.strip
      text = message.text.gsub(%r{^/\w+}, '').strip
      [cmd, text]
    end

    def from_owner?(message)
      OWNER_ID == message.from.id
    end

    def redis
      Ctrl::App.instance.redis
    end
  end
end
