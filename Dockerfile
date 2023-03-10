FROM ruby:latest

RUN apt-get update -qq && apt-get install -y build-essential ruby-sinatra

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

EXPOSE 4567
CMD ["ruby", "./sqlparse.rb", "-o", "0.0.0.0"]