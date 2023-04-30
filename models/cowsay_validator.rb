class CowsayValidator
  attr_reader :message, :character, :available_characters

  def initialize(params)
    @message = params.fetch(:message, '').strip
    @character = params.fetch(:character, '').strip
    @available_characters = params.fetch(:available_characters, [])
  end

  def valid?
    !message.empty? && !character.empty? && available_characters.include?(character)
  end
end
