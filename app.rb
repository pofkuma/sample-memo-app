# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'logger'
require 'erubi'
require 'pg'
require 'dotenv/load'

require_relative 'memo'
require_relative 'routes'

LOG_FILE ||= '/log/sample-memo-app.log'

configure do
  set :public_folder, "#{__dir__}/static"
  set :erb, escape_html: true
end

before do
  @app_name = 'Memo App'

  @logger ||= Logger.new("#{__dir__}/#{LOG_FILE}")

  sample_memo ||= Memo.new(id: 0,
                           title: 'Sample',
                           body: "This is a sample text.\r\nYou can edit or delete this memo.")
  setup_db(sample_memo)
end

# PostgreSQL Access
module MemoAccessHelper
  def conn
    @conn ||= PG.connect(host: ENV['DBHOST'],
                         port: ENV['DBPORT'],
                         user: ENV['DBUSER'],
                         password: ENV['DBPASS'],
                         dbname: ENV['DBNAME'])
  end

  def setup_db(memo)
    conn

    @conn.exec(<<~SQL)
      CREATE TABLE memos( id    integer,
                          title varchar(256),
                          body  varchar(1000),
                          PRIMARY KEY (id)    );
    SQL
    @conn.exec_params(<<~SQL, [memo.id, memo.title, memo.body])
      INSERT INTO memos(id, title, body) VALUES($1, $2, $3);
    SQL
  rescue PG::DuplicateTable => e
    puts e.message
  end

  def select_all_memos
    @conn.exec(<<~SQL).map { _1.transform_keys(&:to_sym) }
      SELECT * FROM memos ORDER BY id;
    SQL
  end

  def select_memo_by_id(id)
    @conn.exec_params(<<~SQL, [id]).first&.transform_keys(&:to_sym)
      SELECT * FROM memos WHERE id = $1;
    SQL
  end

  def insert_memo_with_new_id(memo)
    @conn.transaction do |t_conn|
      memo.id = t_conn.exec(<<~SQL).first['max'].to_i + 1
        SELECT MAX(id) FROM memos;
      SQL

      t_conn.exec_params(<<~SQL, [memo.id, memo.title, memo.body])
        INSERT INTO memos(id, title, body) VALUES($1, $2, $3);
      SQL

      memo.id
    end
  end

  def update_memo(memo)
    @conn.exec_params(<<~SQL, [memo.id, memo.title, memo.body])
      UPDATE memos SET title = $2, body = $3 WHERE id = $1;
    SQL
  end

  def delete_memo_by_id(id)
    @conn.exec_params(<<~SQL, [id])
      DELETE FROM memos WHERE id = $1;
    SQL
  end
end

helpers MemoAccessHelper
