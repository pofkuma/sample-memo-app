# frozen_string_literal: true

class Memo
  attr_accessor :title, :body

  def initialize(title:, body:)
    @title = title
    @body = body
  end
end
