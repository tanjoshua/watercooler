defmodule Watercooler.Channel do
  def send_message(message \\ %{}) do
    broadcast_message(message)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Watercooler.PubSub, "messages")
  end

  defp broadcast_message(message) do
    Phoenix.PubSub.broadcast(Watercooler.PubSub, "messages", message)
  end
end
