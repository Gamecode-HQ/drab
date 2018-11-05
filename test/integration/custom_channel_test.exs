defmodule Drab.Channel.CustomChannelTest do
  use DrabTestApp.IntegrationCase

  @endpoint DrabTestApp.Endpoint

  setup do
    config = Application.get_env(:drab, @endpoint)
    Application.put_env(:drab, @endpoint, Keyword.put(config, :socket, "/custom_socket"))

    on_exit fn ->
      Application.put_env(:drab, @endpoint, config)
    end

    custom_channel_url(@endpoint, :index) |> navigate_to()

    # wait for a page to load
    find_element(:id, "page_loaded_indicator")

    [socket: drab_socket()]
  end

  test "test", %{socket: socket} do
    pid = socket.channel_pid
    :erlang.trace(pid, true, [:receive])

    assert_receive {:trace, ^pid, :receive, :test}

    send pid, :poke_from_outside

    assert_receive {:trace, ^pid, :receive, :poke_finish}, 10000

    # element = find_element(:id, "test")
    # assert visible_text(element) == "POKED"


  end
end
