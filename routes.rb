# frozen_string_literal: true

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = select_all_memos.map { |memo| Memo.new(**memo) }
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |id|
  memo = select_memo_by_id(id.to_i) || (halt 404)
  p id
  @memo = Memo.new(**memo)
  erb :memo
end

get '/memos/:id/edit' do |id|
  memo = select_memo_by_id(id.to_i) || (halt 404)
  @memo = Memo.new(**memo)
  erb :edit
end

post '/memos' do
  memo = { id: nil, title: params[:title], body: params[:body] }
  new_id = insert_memo_with_new_id Memo.new(**memo)

  @logger.info "Created id:#{new_id} title: #{memo[:title]}"
  redirect "/memos/#{new_id}"
end

patch '/memos/:id' do |id|
  @id = id

  memo = select_memo_by_id(id.to_i) || (halt 404)
  new_memo = { id: id, title: params[:title], body: params[:body] }
  update_memo Memo.new(**new_memo)

  @logger.info "Updated id:#{id} title: #{memo[:title]}"
  redirect "/memos/#{@id}"
end

delete '/memos/:id' do |id|
  memo = select_memo_by_id(id.to_i) || (halt 404)
  delete_memo_by_id(id.to_i)

  @logger.info "Deleted id:#{id} title: #{memo[:title]}"
  redirect '/memos'
end

get '/*' do
  halt 404
end
