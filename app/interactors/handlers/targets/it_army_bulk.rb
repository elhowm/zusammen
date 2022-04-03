module Handlers
  module Targets
    class ItArmyBulk < ::Handlers::Base
      include UrlParse

      REDIS_KEY = 'it_army_bulk_callback'.freeze

      def call
        load_payloads.each do |payload|
          target = Target.new(payload)
          repo.add(target)
        end
        repo.save!
        redis.del(REDIS_KEY)
        send_message t('targets.added')
      end

      private

      def load_payloads
        tag = nil
        text.split("\n").map do |line|
          line = line.strip
          tag = line if tag_line?(line)
          next target_payload(line, tag) if line.match? IP_REGEXP

          nil
        end.compact
      end

      def tag_line?(text)
        text.match?(/\A\S*\z/)
      end

      def target_payload(line, tag)
        ip = line.match(IP_REGEXP).to_s
        ports = extract_tcp_ports(line)

        { 'url' => "http://#{ip}", 'ports' => ports, 'tag' => tag }
      end

      def repo
        @repo ||= ::TargetRepo.new
      end

      def redis
        Ctrl::App.instance.redis
      end
    end
  end
end
