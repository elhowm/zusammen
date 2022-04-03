module MessageTestHelper
  def message_stub(custom_options = {})
    defaults = {
      chat: { id: rand(1..100) },
      from: {
        id: rand(1..100),
        username: ::Faker::Internet.user_name
      },
      text: ::Faker::Lorem.word
    }
    data = defaults.merge(custom_options).to_json
    JSON.parse(data, object_class: OpenStruct) # rubocop:disable Style/OpenStructUse
  end
end

RSpec.configure do |config|
  config.include MessageTestHelper, type: :handler
end
