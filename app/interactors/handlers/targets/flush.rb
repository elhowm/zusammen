module Handlers
  module Targets
    class Flush < ::Handlers::Base
      def call
        repo.flush
        repo.save!
        send_message t('targets.added')
      end

      private

      def repo
        @repo ||= ::TargetRepo.new
      end
    end
  end
end
