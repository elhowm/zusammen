module Handlers
  module Targets
    class List < ::Handlers::Base
      def call
        list = targets_list.join("\n")
        list = t('targets.list.none') if list.empty?

        send_message list
      end

      private

      def repo
        @repo ||= ::TargetRepo.new
      end

      def targets_list
        repo.targets.map { |target| item_info(target) }
      end

      def item_info(target)
        ports = target.ports.join(', ')
        tag = target.tag || t('targets.list.none')
        status = target.status.map { |key, value| "#{key}-#{value}" }
                       .join(', ')

        "#{target.url} ports: #{ports}; tag: #{tag}; #{status}"
      end
    end
  end
end
