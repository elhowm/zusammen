module Handlers
  class Unknown < ::Handlers::Base
    def call
      send_message t('unknown')
    end
  end
end
