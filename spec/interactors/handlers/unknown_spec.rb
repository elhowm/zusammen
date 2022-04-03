require 'app_helper'

describe ::Handlers::Unknown, type: :handler do
  subject(:handle) { ::Handlers::Unknown.call(bot:, message:) }

  let(:bot) { double(api: double(send_message: true)) }

  context 'in reply' do
    let(:message) do
      message_stub(from: { id: 100_500 }, text: Faker::Lorem.sentence)
    end

    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Unknown,
                    'Sorry, command is not clear'
  end
end
