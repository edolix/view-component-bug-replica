FROM ruby:3.4.5-slim

ARG environment
ARG bundle_args

ENV RAILS_ENV=$environment
ENV RACK_ENV=$environment
ENV RAILS_LOG_TO_STDOUT=true

ENV APP_HOME=/app
RUN mkdir -p $APP_HOME

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    git \
    libpq-dev \
    postgresql-client \
    curl \
    libvips \
    libyaml-dev \
    vim \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

RUN gem update --system && gem install bundler

WORKDIR $APP_HOME

ENTRYPOINT ["./provisioning/rails/entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
