RSpec.configure do |config|
  config.after do
    repo = TargetRepo.new
    repo.flush
    repo.save!
  end
end
