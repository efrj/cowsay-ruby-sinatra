require 'sinatra'
require 'erb'
require 'shellwords'
require 'i18n'
require 'sinatra/i18n'

I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
I18n.config.available_locales = [:en, :pt]
I18n.default_locale = :en

before do
  I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
end

def available_characters
  cow_files = `/usr/games/cowsay -l`.split("\n")[1..-1].join(" ").split(" ")
  cow_files.map { |f| f.gsub('.cow', '') }
end

get '/' do
  erb :index
end

get '/cowsay_output' do
  message = params['message']
  character = params['character']
  escaped_message = Shellwords.escape(message)
  escaped_character = Shellwords.escape(character)

  if available_characters.include?(escaped_character)
    @output = `/usr/games/cowsay -f #{escaped_character} #{escaped_message}`
  else
    @output = I18n.t('unavailable_character', character: escaped_character)
  end

  erb :cowsay_output
end

__END__
