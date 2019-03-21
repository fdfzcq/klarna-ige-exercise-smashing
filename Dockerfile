FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y nodejs

RUN gem install bundler

COPY . /opt/klarna-ige-sl-dashboard

ENTRYPOINT ["/opt/klarna-ige-sl-dashboard/start.sh"]
CMD        [ "console" ]
