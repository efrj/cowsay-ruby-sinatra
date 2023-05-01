require_relative '../../lib/cowsay_characters'

describe CowsayCharacters do
  describe '.available_characters' do
    it 'returns an array of available characters' do
      characters = CowsayCharacters.available_characters
      expect(characters).to be_an(Array)
      expect(characters).not_to be_empty
      expect(characters).to include('tux')
    end
  end
end
