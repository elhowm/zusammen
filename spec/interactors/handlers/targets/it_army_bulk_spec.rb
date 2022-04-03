require 'app_helper'

describe ::Handlers::Targets::ItArmyBulk, type: :handler do
  subject(:handle) do
    ::Handlers::Targets::ItArmyBulk.call(
      bot:, message:, text:
    )
  end

  let(:bot) { double(api: double(send_message: true)) }

  let(:message) { message_stub(from: { id: 100_500 }, text:) }
  let(:text) do
    <<-TEXT
      Some text 123

      https://target-1.com#{' '}
      62.76.145.221 (80/tcp, 443/tcp)#{' '}

      http://target-2.com
      62.76.145.203 (80/tcp, 443/tcp, 8080/tcp)
      62.76.145.207 (80/tcp, 443/tcp, 8080/tcp)
    TEXT
  end
  let(:repo) { TargetRepo.new }

  before { allow(Ctrl::App.instance.redis).to receive(:del) }

  it 'removes callback redis flag' do
    handle

    expect(Ctrl::App.instance.redis)
      .to have_received(:del).with('it_army_bulk_callback')
  end

  it 'adds all given targets' do
    handle

    expect(repo.targets.size).to eq 3
    expect(repo.targets.map(&:url))
      .to match_array(%w[http://62.76.145.221 http://62.76.145.203 http://62.76.145.207])
    expect(repo.targets.map(&:ports))
      .to contain_exactly([80, 443], [80, 443, 8080], [80, 443, 8080])
    expect(repo.targets.map(&:tag))
      .to match_array(%w[https://target-1.com http://target-2.com http://target-2.com])
  end

  context 'in reply' do
    after { handle }

    it_behaves_like 'handler responds with message',
                    ::Handlers::Targets::ItArmyBulk,
                    'Success'
  end
end
