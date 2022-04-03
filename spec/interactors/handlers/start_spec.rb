require 'app_helper'

describe ::Handlers::Start, type: :handler do
  subject(:handle) { ::Handlers::Start.call(bot:, message:) }

  let(:bot) { double(api: double(send_message: true)) }

  context 'in reply' do
    let(:message) do
      message_stub(from: { id: 100_500, first_name: 'Ricardo' }, text: '')
    end

    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Start,
                    'Hello, Ricardo'
  end
end
