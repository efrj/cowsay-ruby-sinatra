module CowsayCharacters
  def self.available_characters
    cow_files = `/usr/games/cowsay -l`.split("\n")[1..-1].join(" ").split(" ")
    cow_files.map { |f| f.gsub('.cow', '') }
  end
end
  