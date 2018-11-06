defmodule DrabTestApp.EventsCommander do
  @moduledoc false
  use Drab.Commander

  onload(:page_loaded)

  def page_loaded(socket) do
    DrabTestApp.IntegrationCase.add_page_loaded_indicator(socket)
    DrabTestApp.IntegrationCase.add_pid(socket)

    socket
    |> Drab.commander_pid()
    |> Process.send_after(:test, 0)
  end

  @impl true
  def handle_message(:test, socket) do
    Drab.Live.poke(socket, test: "CHANGED")
  end
  def handle_message(_, _socket), do: :ok

end
