defmodule DrabTestApp.CustomChannel do
  use Drab.Channel.Base

  def on_join(socket) do
    Process.send_after(self(), :test, 100)
    {:ok, socket}
  end

  def on_handle_info(socket, :test) do
    Process.send_after(self(), :test, 5)
    # assigns = Drab.Live.assigns(socket, "index.html.drab")
    # Process.send_after(self(), {:on_handle_info, assigns}, 1)
  end
  def on_handle_info(socket, :poke_from_outside) do
    # socket
    # |> Drab.Query.insert("<h3 id='test'>POKED</h3>", after: "#page_loaded_indicator")

    Process.send_after(self(), :poke_finish, 5)
  end
  def on_handle_info(_socket, msg), do: msg
end
