defmodule DrabTestApp.CustomChannelCommander do
  @moduledoc false
  use Drab.Commander

  onload(:page_loaded)

  def page_loaded(socket) do
    exec_js!(socket, "window.$ = jQuery")

    socket
    |> Drab.Query.insert("<h3 id='page_loaded_indicator'>Page Loaded</h3>", after: "#begin")

    p = inspect(socket.assigns.__drab_pid)
    pid_string = ~r/#PID<(?<pid>.*)>/ |> Regex.named_captures(p) |> Map.get("pid")
    socket |> Drab.Query.update(:text, set: pid_string, on: "#drab_pid")
  end
end
