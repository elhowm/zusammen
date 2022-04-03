require 'app_helper'

describe ::Handlers::Targets::Create, type: :handler do
  subject(:handle) do
    ::Handlers::Targets::Create.call(bot:, message:, text:)
  end

  let(:bot) { double(api: double(send_message: true)) }
  let(:repo) { TargetRepo.new }

  let(:message) { message_stub(from: { id: 100_500 }, text:) }
  let(:text) { 'https://sample.com:567' }

  it 'saves target' do
    handle

    target = repo.targets.first
    expect(repo.targets.size).to eq 1
    expect(target.url).to eq 'https://sample.com'
    expect(target.ports).to eq [567]
  end

  context 'without protocol' do
    let(:text) { 'sample.com' }

    it 'saves target with http' do
      handle

      target = repo.targets.first
      expect(repo.targets.size).to eq 1
      expect(target.url).to eq 'http://sample.com'
      expect(target.ports).to eq [80, 443]
    end
  end

  context 'in reply' do
    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Targets::Create,
                    'Success'
  end
end
