# frozen_string_literal: true

module MemoAccessHelper
  PSTORE_NAME = 'memos'

  def setup_db
    @db ||= PStore.new(PSTORE_FILE)
    @db.transaction do
      @db[PSTORE_NAME] ||= {
        '0' => Memo.new(
          title: 'Sample',
          body: "This is a sample text.\r\nYou can edit or delete this memo."
        )
      }
    end
  end

  def fetch_all_memos
    @db.transaction(true) do |pstore|
      memos =
        pstore.fetch(PSTORE_NAME).filter do |_id, content|
          content.title
        end
      memos
    end
  end

  def fetch_memo_by_id(id)
    @db.transaction(true) do |pstore|
      pstore.fetch(PSTORE_NAME).fetch(id)
    end
  rescue KeyError
    halt 404
  end

  def store_memo(id, memo)
    memo.title = 'Untitled' if memo.title.empty?
    @db.transaction do
      @db[PSTORE_NAME][id] = memo
    end
  end

  def create_new_id
    @db.transaction do
      new_id = @db[PSTORE_NAME].keys.max.to_i + 1
      new_id.to_s
    end
  end

  def delete_memo_by_id(id)
    @db.transaction do
      memo = @db[PSTORE_NAME].delete(id)
      memo
    end
  end
end
