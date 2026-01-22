require "sinatra"

# CloudWatchアラームのチェック
abort "fail for alarm test"

set :bind, "0.0.0.0"
set :port, ENV.fetch("PORT", 3000)

get "/" do
  "hello apprunner"
end

get "/health" do
  status 200
  "ok"
end
