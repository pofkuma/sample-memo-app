# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'logger'
require 'pstore'
require 'erubi'

require_relative 'memo_access_helper'
require_relative 'route'

LOG_FILE = "#{__dir__}/log/sample-memo-app.log"
PSTORE_FILE = "#{__dir__}/db/sample-memo-app.pstore"
PSTORE_NAME = 'memos'

configure do
  set :public_folder, "#{__dir__}/static"
  set :erb, escape_html: true
end

before do
  @app_name = 'Memo App'

  @logger ||= Logger.new(LOG_FILE)

  setup_db
end

helpers MemoAccessHelper
