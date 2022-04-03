module UrlParse
  IP_REGEXP = /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ # 8.8.8.8
  DOMAIN_REGEXP = %r{^(http://)|(https://)\S*$} # https://google.com
  DOMAIN_PORT_REGEXP = %r{^(http://)|(https://)\S*:\d{1,4}$} # http://google.com:80
  PORT_REGEXP = %r{\d{1,4}/tcp} # 80/tcp

  def extract_host_port(text)
    text = "http://#{text}" unless text.start_with? 'http'

    if text.match?(DOMAIN_PORT_REGEXP)
      parts = text.split(':')
      [parts[0..1].join(':'), parts[2]]
    else
      [text, nil]
    end
  end

  def extract_tcp_ports(text)
    text.scan(PORT_REGEXP).map { |port| port.gsub('/tcp', '').to_i }
  end
end
