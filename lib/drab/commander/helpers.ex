defmodule Drab.Commander.Helpers do

  @spec name(pid()) :: atom()
  def name(drab_pid) when is_pid(drab_pid) do
    Module.concat(Drab.Commander, pid_to_binary(drab_pid))
  end

  @spec commander_pid(pid()) :: pid() | {atom(), node()} | nil
  def commander_pid(drab_pid) when is_pid(drab_pid) do
    drab_pid
    |> name()
    |> GenServer.whereis()
  end

  @spec pid_to_binary(pid()) :: binary()
  def pid_to_binary(pid) when is_pid(pid) do
    pid
    |> :erlang.pid_to_list()
    |> List.pop_at(0)
    |> elem(1)
    |> List.pop_at(-1)
    |> elem(1)
    |> to_string
  end

end
