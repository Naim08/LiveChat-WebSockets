class MentionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "fun_stream_name"
    stream_for current_user
  end
end
