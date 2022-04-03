module Handlers
  module Targets
    class Remove < ::Handlers::Base
      include UrlParse

      def call
        url, _port = extract_host_port(text)
        repo.targets.reject! do |target|
          target.url == url || target.tag == text
        end
        repo.save!
        send_message t('targets.removed')
      end

      private

      def repo
        @repo ||= ::TargetRepo.new
      end
    end
  end
end
