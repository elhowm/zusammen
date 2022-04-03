class ApplicationInteractor
  include Interactor
  extend Forwardable

  def_delegator :I18n, :t

  protected

  def logger
    Ctrl::App.instance.logger
  end
end
