class RoomsChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find_by(id: params[:id])
    rooms << @room
    stream_for @room

    # Add these lines to broadcast entering a room:
    self.class.broadcast_to @room,
      type: "RECEIVE_USER",
      user: current_user.slice(:id, :username)
  end

  # Define an `unsubscribed` callback method, to broadcast leaving a room
  def unsubscribed
    rooms.delete(@room)
    self.class.broadcast_to @room,
      type: "REMOVE_USER",
      id: current_user.id
  end

  def self.online_users(room)
    ActionCable.server.connections.filter_map do |conn|
      conn.rooms.include?(room) && conn.current_user
    end.uniq
  end
end
