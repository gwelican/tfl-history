FROM ruby:2.1-alpine

ADD . /usr/src/app

RUN apk --update add --virtual build-dependencies ruby-dev build-base 
RUN gem install bundler --no-ri --no-rdoc
RUN cd /usr/src/app ; bundle install --without development test 
RUN apk del build-dependencies

WORKDIR /usr/src/app

CMD ["./download.rb"]
