# frozen_string_literal: true

require "sinatra"
require "omniauth-twitter"
require "yaml"
require "cgi"

# rubocop:disable Metrics/BlockLength
configure do
  enable :sessions
  use OmniAuth::Builder do
    provider :twitter,
             ENV["TWITTER_CONSUMER_KEY"], ENV["TWITTER_CONSUMER_SECRET"]
  end

  helpers do
    def current_user
      !session[:uid].nil?
    end
  end

  before do
    pass if request.path_info =~ %r{^/auth/}
    redirect to("/auth/twitter") unless current_user
  end

  get "/auth/twitter/callback" do
    session[:uid] = env["omniauth.auth"]["uid"]
    session[:token] = env["omniauth.auth"]["credentials"]["token"]
    session[:secret] = env["omniauth.auth"]["credentials"]["secret"]
    session[:name] = env["omniauth.auth"]["info"]["name"]
    redirect to("/")
  end

  get "/auth/failure" do
    "Fail!"
  end

  get "/" do
    "<html><head></head><body>" \
      "<h1>Hello " +  CGI.escapeHTML(session[:name]) + "!</h1>" \
      "<p>token: " +  CGI.escapeHTML(session[:token]) + "</p>" \
      "<p>secret: " + CGI.escapeHTML(session[:secret]) + "</p>" \
      "<pre>" + \
      CGI.escapeHTML(env.to_yaml) + \
      "</pre>" \
      "</body></html>"
  end
end
# rubocop:enable Metrics/BlockLength
