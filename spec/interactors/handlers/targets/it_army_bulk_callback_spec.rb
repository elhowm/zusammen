require 'app_helper'

describe ::Handlers::Targets::ItArmyBulkCallback, type: :handler do
  subject(:handle) do
    ::Handlers::Targets::ItArmyBulkCallback.call(
      bot:, message:, text:
    )
  end

  let(:bot) { double(api: double(send_message: true)) }

  let(:message) { message_stub(from: { id: 100_500 }, text:) }
  let(:text) { '' }

  before { allow(Ctrl::App.instance.redis).to receive(:set) }

  it 'triggers callback redis flag' do
    handle

    expect(Ctrl::App.instance.redis)
      .to have_received(:set).with('it_army_bulk_callback', true)
  end

  context 'in reply' do
    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Targets::ItArmyBulkCallback,
                    'Enter targets to parse'
  end
end
