class BaseModel
  protected

  def redis
    Ctrl::App.instance.redis
  end
end
