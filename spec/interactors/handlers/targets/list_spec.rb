require 'app_helper'

describe ::Handlers::Targets::List, type: :handler do
  subject(:handle) do
    ::Handlers::Targets::List.call(bot:, message:, text:)
  end

  let(:bot) { double(api: double(send_message: true)) }
  let(:repo) { TargetRepo.new }

  let(:message) { message_stub(from: { id: 100_500 }, text:) }
  let(:text) { '' }

  before do
    repo.add Target.new(
      'url' => 'http://sample.com', 'ports' => [99], 'tag' => 'sample.com'
    )
    repo.add Target.new(
      'url' => 'https://sample2.com', 'ports' => [8080]
    )
    repo.save!
  end

  context 'in reply' do
    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Targets::List,
                    "http://sample.com ports: 99; tag: sample.com; "\
                    "success-0, fails-0, broken-false\n"\
                    'https://sample2.com ports: 8080; tag: none; '\
                    "success-0, fails-0, broken-false"
  end
end
