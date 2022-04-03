require 'app_helper'

describe ::Handlers::Targets::Flush, type: :handler do
  subject(:handle) do
    ::Handlers::Targets::Flush.call(bot:, message:, text:)
  end

  let(:bot) { double(api: double(send_message: true)) }
  let(:repo) { TargetRepo.new }

  let(:message) { message_stub(from: { id: 100_500 }, text:) }
  let(:text) { 'https://sample.com:567' }

  before do
    repo.add Target.new('url' => 'http://sample.com')
    repo.save!
  end

  it 'removes all targets' do
    handle

    repo.reload!
    expect(repo.targets.size).to eq 0
  end

  context 'in reply' do
    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Targets::Flush,
                    'Success'
  end
end
