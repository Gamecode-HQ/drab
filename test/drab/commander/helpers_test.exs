defmodule Drab.Commander.HelpersTest do
  use ExUnit.Case, ascync: true
  import Drab.Commander.Helpers

  defmodule TestCommander do
    use Drab.Commander

    @impl true
    def handle_message(:first, _socket) do
      send self(), :second
    end
    def handle_message(_, _socket), do: :ok
  end

  describe "pid_to_binary/1" do
    test "converts pid to string" do
      pid = :erlang.list_to_pid('<0.100.0>')

      assert pid_to_binary(pid) == "0.100.0"
    end
  end

  describe "name/1" do
    test "generates module name based on drab_pid" do
      pid = :erlang.list_to_pid('<0.100.0>')

      assert name(pid) == :"Elixir.Drab.Commander.0.100.0"
    end
  end

  describe "commander_pid/1" do
    setup do
      socket = %Phoenix.Socket{assigns: %{
        __commander: TestCommander,
        __controller: Drab.Controller
      }}
      {:ok, socket: socket}
    end

    test "returns commander pid based on drab_pid", %{socket: socket} do
      {:ok, drab_pid} = Drab.start_link(socket)

      pid = commander_pid(drab_pid)
      assert is_pid(pid)

      :erlang.trace(pid, true, [:receive])

      send pid, :first

      assert_receive {:trace, ^pid, :receive, :first}
      assert_receive {:trace, ^pid, :receive, :second}
    end
  end

end
