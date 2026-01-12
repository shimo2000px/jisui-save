class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: [ :terms, :privacy, :contact ], raise: false

  def terms
  end

  def privacy
  end

  def contact
  end
end
