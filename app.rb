# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'logger'
require 'pstore'
require 'erubi'

require_relative 'memo'
require_relative 'memo_access_helper'
require_relative 'route'

LOG_FILE = '/log/sample-memo-app.log'
PSTORE_FILE = '/db/sample-memo-app.pstore'

configure do
  set :public_folder, "#{__dir__}/static"
  set :erb, escape_html: true
end

before do
  @app_name = 'Memo App'

  @logger ||= Logger.new("#{__dir__}/#{LOG_FILE}")

  setup_db
end

helpers MemoAccessHelper
