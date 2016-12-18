require 'spec_helper'

describe Lita::Alias::ChatHandler, lita_handler: true do
  context 'routes' do
    it 'receives commands and routes them' do
      expect(described_class).to route_command('alias add FOO BAR').to :add
      expect(described_class).to route_command('alias list').to :list
      expect(described_class).to route_command('alias delete FOO').to :delete
    end

    it 'does not take action when not spoken to directly' do
      expect(described_class).not_to route('alias add FOO BAR')
    end

    it 'does not route another plugin command' do
      expect(described_class).to_not route_command('sandwich')
    end
  end

  context 'commands' do
    before do
      # We need a valid command to alias against and validate behavior
      registry.register_handler(:echo) do
        route(/^echo\s+(.+)/) do |response|
          response.reply(response.match_data[1])
        end
      end
    end

    describe 'alias list' do
      it 'returns an empty list' do
        send_command('alias list')
        expect(replies.last).to eq 'No aliases have been saved'
      end
      it 'returns current listing' do
        send_command('alias add FOO echo BAR')
        send_command('alias list')
        expect(replies.last).to eq 'FOO => echo BAR'
      end
    end

    describe 'alias add' do
      context 'new' do
        it 'sets and responds' do
          send_command('alias add FOO echo BAR')
          expect(replies.last).to eq "Added alias 'FOO' for 'echo BAR'"
          send_command('FOO')
          expect(replies.last).to eq 'BAR'
        end

        it 'responds with extra args' do
          send_command('alias add SAY echo')
          send_command('SAY HELLO')
          expect(replies.last).to eq 'HELLO'
        end
      end

      context 'existing alias' do
        it 'overrides stored alias' do
          send_command('alias add foobar echo FOOBAR')
          expect(replies.last).to eq "Added alias 'foobar' for 'echo FOOBAR'"
          send_command('alias add foobar echo BARFOO')
          expect(replies.last).to eq "Added alias 'foobar' for 'echo BARFOO'"
          send_command('foobar')
          expect(replies.last).to eq 'BARFOO'
          expect(replies.include? 'FOOBAR').to be_falsey
        end
      end
    end

    describe 'alias delete' do
      context 'no alias exists' do
        it 'repsonds with an error message' do
          send_command('alias delete bar')
          expect(replies.last).to eq "Alias 'bar' does not exist"
        end
      end
      context 'an existing alias' do
        it 'responds with a delete message' do
          send_command('alias add bar BAZ')
          send_command('alias delete bar')
          expect(replies.last).to eq "Deleted alias 'bar' => 'BAZ'"
        end
      end
    end
  end
end
