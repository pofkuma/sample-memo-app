# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'logger'
require 'pstore'
require 'erubi'

LOG_FILE = '/tmp/sample-memo-app.log'
PSTORE_FILE = '/tmp/sample-memo-app.pstore'
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

module MemoIO
  def setup_db
    @db ||= PStore.new(PSTORE_FILE)
    @db.transaction do
      @db[PSTORE_NAME] ||= { '0' => { title: 'サンプル', body: 'これはサンプルです。' } }
      @db.commit
      @logger.info @db[PSTORE_NAME]
    end
  end

  def fetch_all_memos
    @db.transaction(true) do |pstore|
      @memos = pstore.fetch(PSTORE_NAME).filter do |_id, content|
        content[:title]
      end
    end
    @memos
  end

  def fetch_memo_by_id(id)
    @db.transaction(true) do |pstore|
      @memo = pstore.fetch(PSTORE_NAME).fetch(id)
    end
    @memo
  end

  def store_memo(id, title, body)
    title = 'Untitled' if title.empty?
    @db.transaction do
      @db[PSTORE_NAME][id] = { title: title, body: body }
      @db.commit
    end
  end

  def create_new_id
    @db.transaction do
      @new_id = @db[PSTORE_NAME].keys.max.to_i + 1
    end
    @new_id.to_s
  end

  def delete_memo_by_id(id)
    @db.transaction do
      @db[PSTORE_NAME].delete(id)
      @db.commit
    end
  end
end

helpers MemoIO

# Rooting
get '/' do
  @memos = fetch_all_memos
  erb :index
end

get '/new' do
  erb :new
end

get '/memo/:id' do |id|
  @id = id
  fetch_memo_by_id(id)
  erb :memo
end

get '/memo/:id/edit' do |id|
  @id = id
  fetch_memo_by_id(id)
  erb :edit
end

post '/memo' do
  new_id = create_new_id
  store_memo(new_id, params[:title], params[:body])
  @logger.info "Created id:#{new_id}"
  redirect "/memo/#{new_id}"
end

patch '/memo/:id' do |id|
  @id = id
  store_memo(id, params[:title], params[:body])
  @logger.info "Updated id:#{id}"
  redirect "/memo/#{@id}"
end

delete '/memo/:id' do |id|
  @id = id
  delete_memo_by_id(id)
  @logger.info "Deleted id:#{id}"
  redirect '/'
end
