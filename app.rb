require 'sinatra'
require 'erb'
require 'shellwords'
require 'i18n'

I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
I18n.config.available_locales = [:en, :pt]
I18n.default_locale = :en

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
    @output = "Desculpe, o personagem '#{escaped_character}' não está disponível."
  end

  erb :cowsay_output
end

__END__

@@index
<!DOCTYPE html>
<html lang="<%= I18n.locale %>">
<head>
  <meta charset="UTF-8">
  <title><%= I18n.t('title') %></title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
  <div class="container">
    <h1 class="my-4"><%= I18n.t('title') %></h1>
    <form id="cowsayForm" onsubmit="return submitForm();" class="mb-4">
      <div class="form-group">
        <label for="message"><%= I18n.t('message_label') %>:</label>
        <input type="text" id="message" name="message" class="form-control" required>
      </div>
      <div class="form-group">
        <label for="character"><%= I18n.t('character_label') %>:</label>
        <select id="character" name="character" class="form-control">
          <option value="default">Vaca(Default)</option>
          <option value="tux">Tux</option>
          <option value="ghostbusters">Ghostbusters</option>
          <option value="dragon">Dragão</option>
        </select>
      </div>
      <button type="submit" class="btn btn-primary"><%= I18n.t('submit_button') %></button>
    </form>
    <iframe id="cowsayOutput" width="100%" height="400" frameborder="0" class="border"></iframe>
  </div>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  <script>
    function submitForm() {
      const form = document.getElementById("cowsayForm");
      const iframe = document.getElementById("cowsayOutput");
      iframe.src = `/cowsay_output?message=${encodeURIComponent(form.message.value)}&character=${encodeURIComponent(form.character.value)}`;
      return false;
    }
  </script>
</body>
</html>

@@cowsay_output
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <style>
    body {
      margin: 0;
      font-family: monospace;
      white-space: pre;
    }
  </style>
</head>
<body>
  <%= @output %>
</body>
</html>
