FROM ruby:3.2.2

RUN apt-get update && apt-get install -y curl

# Install Node.js
ENV NODE_VERSION=18.17.0
ENV NODE_PACKAGE=node-v$NODE_VERSION-linux-arm64
ENV NODE_HOME=/opt/$NODE_PACKAGE
ENV NODE_PATH=$NODE_HOME/lib/node_modules
ENV PATH=$NODE_HOME/bin:$PATH

RUN curl -fsSLO --compressed https://nodejs.org/dist/v$NODE_VERSION/$NODE_PACKAGE.tar.xz \
    && tar -xJf $NODE_PACKAGE.tar.xz -C /opt/ \
    && rm $NODE_PACKAGE.tar.xz \
    && ln -s $NODE_HOME/bin/node /usr/local/bin/node \
    && ln -s $NODE_HOME/bin/npm /usr/local/bin/npm \
    && ln -s $NODE_HOME/bin/npx /usr/local/bin/npx

# Install Yarn
RUN npm install -g yarn

ENV RAILS_ROOT /app
RUN mkdir /app
WORKDIR /app
RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-t", "0:8", "-p", "3000"]
