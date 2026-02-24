class LineEventsController < ApplicationController
  protect_from_forgery except: [ :callback ]

  def callback
    head :ok
  end
end
