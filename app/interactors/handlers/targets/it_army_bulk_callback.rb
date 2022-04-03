module Handlers
  module Targets
    class ItArmyBulkCallback < ::Handlers::Base
      def call
        redis.set(Handlers::Targets::ItArmyBulk::REDIS_KEY, true)
        send_message t('targets.bulk_start')
      end

      private

      def redis
        Ctrl::App.instance.redis
      end
    end
  end
end
