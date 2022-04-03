module Handlers
  class Start < ::Handlers::Base
    def call
      send_message t('start.hello', name: message.from.first_name)
    end
  end
end
