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
    <div class="row">
      <div class="col-md-4">
        <form id="cowsayForm" onsubmit="return submitForm();" class="mb-4">
          <div class="form-group">
            <label for="message"><%= I18n.t('message_label') %>:</label>
            <textarea id="message" name="message" class="form-control" required></textarea>
          </div>
          <div class="form-group">
            <label for="character"><%= I18n.t('character_label') %>:</label>
            <select id="character" name="character" class="form-control">
              <option value="default">Vaca(Default)</option>
              <option value="apt">apt</option>
              <option value="bud-frogs">bud-frogs</option>
              <option value="bunny">bunny</option>
              <option value="calvin">calvin</option>
              <option value="cheese">cheese</option>
              <option value="cock">cock</option>
              <option value="cower">cower</option>
              <option value="daemon">daemon</option>
              <option value="dragon">dragon</option>
              <option value="dragon-and-cow">dragon-and-cow</option>
              <option value="duck">duck</option>
              <option value="elephant">elephant</option>
              <option value="elephant-in-snake">elephant-in-snake</option>
              <option value="eyes">eyes</option>
              <option value="flaming-sheep">flaming-sheep</option>
              <option value="fox">fox</option>
              <option value="ghostbusters">ghostbusters</option>
              <option value="gnu">gnu</option>
              <option value="hellokitty">hellokitty</option>
              <option value="kangaroo">kangaroo</option>
              <option value="kiss">kiss</option>
              <option value="koala">koala</option>
              <option value="kosh">kosh</option>
              <option value="luke-koala">luke-koala</option>
              <option value="mech-and-cow">mech-and-cow</option>
              <option value="milk">milk</option>
              <option value="moofasa">moofasa</option>
              <option value="moose">moose</option>
              <option value="pony">pony</option>
              <option value="pony-smaller">pony-smaller</option>
              <option value="ren">ren</option>
              <option value="sheep">sheep</option>
              <option value="skeleton">skeleton</option>
              <option value="snowman">snowman</option>
              <option value="stegosaurus">stegosaurus</option>
              <option value="stimpy">stimpy</option>
              <option value="suse">suse</option>
              <option value="three-eyes">three-eyes</option>
              <option value="turkey">turkey</option>
              <option value="turtle">turtle</option>
              <option value="tux">tux</option>
              <option value="unipony">unipony</option>
              <option value="unipony-smaller">unipony-smaller</option>
              <option value="vader">vader</option>
              <option value="vader-koala">vader-koala</option>
              <option value="www">www</option>
            </select>
          </div>
          <button type="submit" class="btn btn-primary"><%= I18n.t('submit_button') %></button>
        </form>
      </div>
      <div class="col-md-8">
        <iframe id="cowsayOutput" width="100%" height="400" frameborder="0" class="border"></iframe>
      </div>
    </div>
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
