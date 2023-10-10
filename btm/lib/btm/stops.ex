defmodule Btm.Stops do
  def stops() do
    "./priv/transient/gtfs/stops.txt"
    |> File.stream!()
    |> CSV.decode(headers: true)
  end

  def stops_with_lat_long() do
    stops()
    |> Stream.filter(fn {_, stop} ->
      stop["stop_lat"] !== "" and
        stop["stop_lon"] !== ""
    end)
  end
end
