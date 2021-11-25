# frozen_string_literal: true

get '/' do
  @memos = fetch_all_memos
  erb :index
end

get '/new' do
  erb :new
end

get '/memo/:id' do |id|
  @id = id
  memo = fetch_memo_by_id(id)
  halt 404 if memo.nil?
  erb :memo
end

get '/memo/:id/edit' do |id|
  @id = id
  fetch_memo_by_id(id)
  erb :edit
end

post '/memo' do
  new_id = create_new_id
  memo = store_memo(new_id, params[:title], params[:body])
  @logger.info "Created id:#{new_id} title: #{memo[:title]}"
  redirect "/memo/#{new_id}"
end

patch '/memo/:id' do |id|
  @id = id
  memo = store_memo(id, params[:title], params[:body])
  @logger.info "Updated id:#{id} title: #{memo[:title]}"
  redirect "/memo/#{@id}"
end

delete '/memo/:id' do |id|
  @id = id
  memo = delete_memo_by_id(id)
  @logger.info "Deleted id:#{id} title: #{memo[:title]}"
  redirect '/'
end

get '/*' do
  halt 404
end
