::RSpec.shared_examples 'handler responds with error' do |handler_class, fail_text|
  it 'handler responds with fail' do
    expect_any_instance_of(handler_class)
      .to receive(:fail!)
      .with(fail_text)
      .and_call_original
  end
end

::RSpec.shared_examples 'handler responds with message' do |handler_class, text|
  it 'handler responds with message' do
    expect_any_instance_of(handler_class)
      .to receive(:send_message)
      .with(text)
      .and_call_original
  end
end
