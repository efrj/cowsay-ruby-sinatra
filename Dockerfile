FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev cowsay

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

CMD ["bundle", "exec", "rerun", "'ruby app.rb -o 0.0.0.0 -p 4567'", "--"]
