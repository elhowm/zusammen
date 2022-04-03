module Handlers
  module Targets
    class Create < ::Handlers::Base
      include UrlParse

      def call
        target = Target.new(payload)
        repo.add(target)
        repo.save!
        send_message t('targets.added')
      end

      private

      def payload
        url, port = extract_host_port(text)
        {
          'url' => url,
          'ports' => port ? [port.to_i] : nil
        }.compact
      end

      def repo
        @repo ||= ::TargetRepo.new
      end
    end
  end
end
