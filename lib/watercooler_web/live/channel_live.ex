defmodule WatercoolerWeb.ChannelLive do
  use WatercoolerWeb, :live_view

  alias Watercooler.Channel

  def render(assigns) do
    ~H"""
    <div>
      You are: {@username}
    </div>
    <div>
      Messages:
      <ul>
        <%= for message <- @messages do %>
          <li>{message.username}: {message.body}</li>
        <% end %>
      </ul>
    </div>
    <form phx-submit="send_message" class="flex items-center gap-2">
      <input type="text" name="body" autocomplete="off" />
      <button type="submit">Send</button>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Channel.subscribe()

    random_username = Enum.random(["Josh", "Ben", "Sam", "Bob", "Alice"])
    socket = assign(socket, :username, random_username)
    socket = assign(socket, :messages, [])
    {:ok, socket}
  end

  def handle_event("send_message", params, socket) do
    Channel.send_message(%{:body => params["body"], :username => socket.assigns.username})
    {:noreply, socket}
  end

  def handle_info(message, socket) do
    {:noreply, update(socket, :messages, fn messages -> messages ++ [message] end)}
  end
end
