FROM ruby:3.1
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle
COPY . /app
CMD rake
