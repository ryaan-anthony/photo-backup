FROM ruby:3.2

WORKDIR /var/www/current

COPY . .

RUN bundle install
