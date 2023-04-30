class ArgumentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "arguments_channel"
  end

  def unsubscribed
  end
end
