class Target < BaseModel
  attr_accessor :url, :ports, :disabled, :tag

  def initialize(data)
    @url = data['url']
    @ports = data['ports'] || [80, 443]
    @disabled = data['disabled'] || false
    @tag = data['tag']
  end

  def eql?(other)
    return url == other.url if other.is_a?(Target)

    url == other
  end
  alias == eql?

  def hash
    url.hash
  end

  def inspect
    "Target (#{url})"
  end

  def as_json
    {
      'url' => url,
      'ports' => ports,
      'disabled' => disabled,
      'tag' => tag
    }.compact
  end

  def to_json(*_args)
    as_json.to_json
  end

  def status
    {
      'success' => redis.get("#{url}_success").to_i,
      'fails' => redis.get("#{url}_fails").to_i,
      'broken' => redis.get("#{url}_broken") || 'false'
    }
  end

  def check_fail!
    redis.incr("#{url}_fails")
  end

  def check_success!
    redis.incr("#{url}_success")
  end
end
