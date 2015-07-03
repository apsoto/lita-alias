require 'spec_helper'

describe Lita::Alias::AliasedCommand do
  context 'an empty object' do
    let(:dummy) { subject.class.new }

    it '#valid?' do
      expect(dummy.valid?).to be_falsey
    end

    it '#name' do
      expect(dummy.name).to be_nil
    end
  end

  context 'an invalid named object' do
    let(:dummy) { subject.class.new('someobj') }

    it '#valid?' do
      expect(dummy.valid?).to be_falsey
    end
    it '#name' do
      expect(dummy.name).to eq 'someobj'
    end
    it '#command' do
      expect(dummy.command).to be_nil
    end
  end

  context 'invalid, command only' do
    let(:dummy) { subject.class.new(nil, 'somecommand') }

    it '#name' do
      expect(dummy.name).to be nil
    end
    it '#command' do
      expect(dummy.command).to eq 'somecommand'
    end
    it '#valid?' do
      expect(dummy.valid?).to be_falsey
    end
  end

  context 'a named object with a command' do
    let(:dummy) { subject.class.new('some', 'important command') }

    it '#valid?' do
      expect(dummy.valid?).to be_truthy
    end
    it '#name' do
      expect(dummy.name).to eq 'some'
    end
    it '#command' do
      expect(dummy.command).to eq 'important command'
    end
  end
end
