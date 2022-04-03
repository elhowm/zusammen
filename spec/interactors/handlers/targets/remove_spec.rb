require 'app_helper'

describe ::Handlers::Targets::Remove, type: :handler do
  subject(:handle) do
    ::Handlers::Targets::Remove.call(bot:, message:, text:)
  end

  let(:bot) { double(api: double(send_message: true)) }
  let(:repo) { TargetRepo.new }

  let(:message) { message_stub(from: { id: 100_500 }, text:) }
  let(:text) { '' }

  before do
    repo.add Target.new(
      'url' => 'http://sample.com', 'ports' => [99], 'tag' => 'sample'
    )
    repo.add Target.new(
      'url' => 'https://sample2.com', 'ports' => [8080]
    )
    repo.save!
  end

  context 'with url' do
    let(:text) { 'sample.com' }

    it 'removes target by url' do
      handle

      repo.reload!
      expect(repo.targets.size).to eq 1
      expect(repo.targets.first.url).to eq 'https://sample2.com'
    end
  end

  context 'with tag' do
    let(:text) { 'sample' }

    it 'removes target by tag' do
      handle

      repo.reload!
      expect(repo.targets.size).to eq 1
      expect(repo.targets.first.url).to eq 'https://sample2.com'
    end
  end

  context 'in reply' do
    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Targets::Remove,
                    'Success'
  end
end
