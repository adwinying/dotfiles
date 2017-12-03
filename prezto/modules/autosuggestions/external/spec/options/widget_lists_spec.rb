describe 'a zle widget' do
  let(:widget) { 'my-widget' }
  let(:before_sourcing) { -> { session.run_command("#{widget}() {}; zle -N #{widget}; bindkey ^B #{widget}") } }

  context 'when added to ZSH_AUTOSUGGEST_ACCEPT_WIDGETS' do
    let(:options) { ["ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(#{widget})"] }

    it 'accepts the suggestion when invoked' do
      with_history('echo hello') do
        session.send_string('e')
        wait_for { session.content }.to eq('echo hello')
        session.send_keys('C-b')
        wait_for { session.content(esc_seqs: true) }.to eq('echo hello')
      end
    end
  end

  context 'when added to ZSH_AUTOSUGGEST_CLEAR_WIDGETS' do
    let(:options) { ["ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(#{widget})"] }

    it 'clears the suggestion when invoked' do
      with_history('echo hello') do
        session.send_string('e')
        wait_for { session.content }.to eq('echo hello')
        session.send_keys('C-b')
        wait_for { session.content }.to eq('e')
      end
    end
  end

  context 'when added to ZSH_AUTOSUGGEST_EXECUTE_WIDGETS' do
    let(:options) { ["ZSH_AUTOSUGGEST_EXECUTE_WIDGETS+=(#{widget})"] }

    it 'executes the suggestion when invoked' do
      with_history('echo hello') do
        session.send_string('e')
        wait_for { session.content }.to eq('echo hello')
        session.send_keys('C-b')
        wait_for { session.content }.to end_with("\nhello")
      end
    end
  end

  context 'when added to ZSH_AUTOSUGGEST_IGNORE_WIDGETS' do
    let(:options) { ["ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(#{widget})"] }

    it 'should not be wrapped with an autosuggest widget' do
      session.run_command("echo $widgets[#{widget}]")
      wait_for { session.content }.to end_with("\nuser:#{widget}")
    end
  end

  context 'that moves the cursor forward' do
    before { session.run_command("#{widget}() { zle forward-char }") }

    context 'when added to ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS' do
      let(:options) { ["ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(#{widget})"] }

      it 'accepts the suggestion as far as the cursor is moved when invoked' do
        with_history('echo hello') do
          session.send_string('e')
          wait_for { session.content }.to start_with('echo hello')
          session.send_keys('C-b')
          wait_for { session.content(esc_seqs: true) }.to match(/\Aec\e\[[0-9]+mho hello/)
        end
      end
    end
  end

  context 'that modifies the buffer' do
    before { session.run_command("#{widget}() { BUFFER=\"foo\" }") }

    context 'when not added to any of the widget lists' do
      it 'modifies the buffer and fetches a new suggestion' do
        with_history('foobar') do
          session.send_keys('C-b')
          wait_for { session.content }.to eq('foobar')
        end
      end
    end
  end
end

describe 'a modification to the widget lists' do
  let(:widget) { 'my-widget' }
  let(:before_sourcing) { -> { session.run_command("#{widget}() {}; zle -N #{widget}; bindkey ^B #{widget}") } }
  before { session.run_command("ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(#{widget})") }

  it 'takes effect on the next cmd line' do
    with_history('echo hello') do
      session.send_string('e')
      wait_for { session.content }.to eq('echo hello')
      session.send_keys('C-b')
      wait_for { session.content(esc_seqs: true) }.to eq('echo hello')
    end
  end
end
