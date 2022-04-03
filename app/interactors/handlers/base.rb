module Handlers
  class Base < ::ApplicationInteractor
    def_delegators :context, :bot, :message, :text

    def send_message(text)
      bot.api.send_message(
        chat_id: message.from.id,
        text:
      )
    end
  end
end
