require 'sinatra'
require 'erb'
require 'shellwords'
require 'i18n'

I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
I18n.config.available_locales = [:en, :pt]
I18n.default_locale = :en

def available_characters
  cow_files = `cowsay -l`.split("\n")[1..-1].join(" ").split(" ")
  cow_files.map { |file| File.basename(file, '.cow') }
end

get '/' do
  erb :index
end

post '/cowsay' do
  message = params['message']
  character = params['character']
  escaped_message = Shellwords.escape(message)
  escaped_character = Shellwords.escape(character)

  if available_characters.include?(escaped_character)
    @output = `cowsay -f #{escaped_character} "#{escaped_message}"`
  else
    @output = "Desculpe, o personagem '#{escaped_character}' não está disponível."
  end

  erb :index
end

__END__

@@index
<!DOCTYPE html>
<html lang="<%= I18n.locale %>">
<head>
  <meta charset="UTF-8">
  <title><%= I18n.t('title') %></title>
</head>
<body>
  <h1><%= I18n.t('title') %></h1>
  <form action="/cowsay" method="post">
    <label for="message"><%= I18n.t('message_label') %>:</label>
    <input type="text" id="message" name="message" required>
    <br>
    <label for="character"><%= I18n.t('character_label') %>:</label>
    <select id="character" name="character">
      <option value="default">Vaca(Default)</option>
      <option value="tux">Tux</option>
      <option value="ghostbusters">Ghostbusters</option>
      <option value="dragon">Dragão</option>
    </select>
    <br>
    <input type="submit" value="<%= I18n.t('submit_button') %>">
  </form>
  <% if @output %>
    <pre><%= @output %></pre>
  <% end %>
</body>
</html>
  
