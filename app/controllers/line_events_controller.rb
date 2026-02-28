class LineEventsController < ApplicationController
  skip_before_action :require_login, raise: false
  protect_from_forgery except: [ :callback ]

  def callback
    head :ok
  end
end
