require_relative '../../models/cowsay_validator'

RSpec.describe CowsayValidator do
  let(:available_characters) { %w[tux cheese] }
  let(:valid_message) { 'Hello, world!' }
  let(:valid_character) { 'tux' }
  let(:invalid_character) { 'invalid_character' }

  describe '#valid?' do
    context 'when the message and character are valid' do
      let(:cowsay_validator) { CowsayValidator.new(message: valid_message, character: valid_character, available_characters: available_characters) }

      it 'returns true' do
        expect(cowsay_validator.valid?).to be_truthy
      end
    end

    context 'when the message is empty' do
      let(:cowsay_validator) { CowsayValidator.new(message: '', character: valid_character, available_characters: available_characters) }

      it 'returns false' do
        expect(cowsay_validator.valid?).to be_falsey
      end
    end

    context 'when the character is invalid' do
      let(:cowsay_validator) { CowsayValidator.new(message: valid_message, character: invalid_character, available_characters: available_characters) }

      it 'returns false' do
        expect(cowsay_validator.valid?).to be_falsey
      end
    end
  end
end
