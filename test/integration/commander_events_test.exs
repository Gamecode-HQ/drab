defmodule DrabTestApp.CommanderEventsTest do
  use DrabTestApp.IntegrationCase

  defp events_index do
    events_url(DrabTestApp.Endpoint, :index)
  end

  setup do
    events_index() |> navigate_to()
    # wait for a page to load
    find_element(:id, "page_loaded_indicator")
    [socket: drab_socket()]
  end

  test "pokes socket from outside", %{socket: socket} do
    element = find_element(:id, "test")
    assert visible_text(element) == "CHANGED"

    pid = Drab.commander_pid(socket)

    :erlang.trace(pid, true, [:receive])

    send pid, :second

    assert_receive {:trace, ^pid, :receive, :second}
    assert_receive {:trace, ^pid, :receive, :changed}

    element = find_element(:id, "test")
    assert visible_text(element) == "CHANGED AGAIN"
  end

end
