# frozen_string_literal: true

module MemoAccessHelper
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
