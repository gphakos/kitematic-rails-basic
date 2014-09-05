FROM ubuntu:14.04
 
RUN apt-get update -qq && \
    apt-get install -y make curl git libsqlite3-dev -qq && \
    apt-get clean && \
    curl -sSL "https://github.com/postmodern/ruby-install/archive/master.tar.gz" -o /tmp/ruby-install-master.tar.gz && \
    cd /tmp && tar -zxvf ruby-install-master.tar.gz && \
    cd /tmp/ruby-install-master && make install && \
    apt-get update && \
    ruby-install -i /usr/local/ ruby -- --disable-install-rdoc --disable-install-ri && \
    gem update --system && \
    gem install bundler


USER railsapp

RUN gem install rails

RUN gem install sqlite3 -v '1.3.9'

ADD ./volumes/app /app
VOLUME ["/app"]

WORKDIR /app
RUN bundle install

EXPOSE 80
#seems hacky to use cd... research fix
CMD cd /app; bundle exec rails server -p 80