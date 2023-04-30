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
              <option value="default"><%= I18n.t('characters.cow') %></option>
              <option value="apt"><%= I18n.t('characters.apt') %></option>
              <option value="bud-frogs"><%= I18n.t('characters.bud_frogs') %></option>
              <option value="bunny"><%= I18n.t('characters.bunny') %></option>
              <option value="calvin"><%= I18n.t('characters.calvin') %></option>
              <option value="cheese"><%= I18n.t('characters.cheese') %></option>
              <option value="cock"><%= I18n.t('characters.cock') %></option>
              <option value="cower"><%= I18n.t('characters.cower') %></option>
              <option value="daemon"><%= I18n.t('characters.daemon') %></option>
              <option value="dragon"><%= I18n.t('characters.dragon') %></option>
              <option value="dragon-and-cow"><%= I18n.t('characters.dragon_and_cow') %></option>
              <option value="duck"><%= I18n.t('characters.duck') %></option>
              <option value="elephant"><%= I18n.t('characters.elephant') %></option>
              <option value="elephant-in-snake"><%= I18n.t('characters.elephant_in_snake') %></option>
              <option value="eyes"><%= I18n.t('characters.eyes') %></option>
              <option value="flaming-sheep"><%= I18n.t('characters.flaming_sheep') %></option>
              <option value="fox"><%= I18n.t('characters.fox') %></option>
              <option value="ghostbusters"><%= I18n.t('characters.ghostbusters') %></option>
              <option value="gnu"><%= I18n.t('characters.gnu') %></option>
              <option value="hellokitty"><%= I18n.t('characters.hellokitty') %></option>
              <option value="kangaroo"><%= I18n.t('characters.kangaroo') %></option>
              <option value="kiss"><%= I18n.t('characters.kiss') %></option>
              <option value="koala"><%= I18n.t('characters.koala') %></option>
              <option value="kosh"><%= I18n.t('characters.kosh') %></option>
              <option value="luke-koala"><%= I18n.t('characters.luke_koala') %></option>
              <option value="mech-and-cow"><%= I18n.t('characters.mech_and_cow') %></option>
              <option value="milk"><%= I18n.t('characters.milk') %></option>
              <option value="moofasa"><%= I18n.t('characters.moofasa') %></option>
              <option value="moose"><%= I18n.t('characters.moose') %></option>
              <option value="pony"><%= I18n.t('characters.pony') %></option>
              <option value="pony-smaller"><%= I18n.t('characters.pony_smaller') %></option>
              <option value="ren"><%= I18n.t('characters.ren') %></option>
              <option value="sheep"><%= I18n.t('characters.sheep') %></option>
              <option value="skeleton"><%= I18n.t('characters.skeleton') %></option>
              <option value="snowman"><%= I18n.t('characters.snowman') %></option>
              <option value="stegosaurus"><%= I18n.t('characters.stegosaurus') %></option>
              <option value="stimpy"><%= I18n.t('characters.stimpy') %></option>
              <option value="suse"><%= I18n.t('characters.suse') %></option>
              <option value="three-eyes"><%= I18n.t('characters.three_eyes') %></option>
              <option value="turkey"><%= I18n.t('characters.turkey') %></option>
              <option value="turtle"><%= I18n.t('characters.turtle') %></option>
              <option value="tux"><%= I18n.t('characters.tux') %></option>
              <option value="unipony"><%= I18n.t('characters.unipony') %></option>
              <option value="unipony-smaller"><%= I18n.t('characters.unipony_smaller') %></option>
              <option value="vader"><%= I18n.t('characters.vader') %></option>
              <option value="vader-koala"><%= I18n.t('characters.vader_koala') %></option>
              <option value="www"><%= I18n.t('characters.www') %></option>            
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
