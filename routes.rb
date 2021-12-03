# frozen_string_literal: true

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = fetch_all_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |id|
  @id = id
  @memo = fetch_memo_by_id(id) || (halt 404)
  erb :memo
end

get '/memos/:id/edit' do |id|
  @id = id
  @memo = fetch_memo_by_id(id) || (halt 404)
  erb :edit
end

post '/memos' do
  memo = Memo.new(title: params[:title], body: params[:body])
  new_id = store_memo(memo)
  @logger.info "Created id:#{new_id} title: #{memo.title}"
  redirect "/memos/#{new_id}"
end

patch '/memos/:id' do |id|
  @id = id

  memo = Memo.new(title: params[:title], body: params[:body])
  store_memo(memo, id)
  @logger.info "Updated id:#{id} title: #{memo.title}"
  redirect "/memos/#{@id}"
end

delete '/memos/:id' do |id|
  @id = id

  memo = delete_memo_by_id(id)
  halt 404 if memo.nil?
  @logger.info "Deleted id:#{id} title: #{memo.title}"
  redirect '/memos'
end

get '/*' do
  halt 404
end
