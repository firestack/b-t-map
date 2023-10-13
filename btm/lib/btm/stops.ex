defmodule Btm.Stops do
  def stops() do
    "./priv/transient/gtfs/stops.txt"
    |> File.stream!()
    |> CSV.decode(headers: true)
  end

  def stops(:geojson, :multipoint) do
    Geo.JSON.encode!(%Geo.MultiPoint{
      coordinates:
        stops_with_lat_long()
        |> Stream.map(fn {:ok, stop} -> stop end)
        |> Stream.map(&{&1["stop_lon"], &1["stop_lat"]})
    })
  end

  def stops(:geojson, :points) do
    Geo.JSON.encode!(%Geo.GeometryCollection{
      geometries:
        stops_with_lat_long()
        |> Stream.map(fn {:ok, stop} -> stop end)
        |> Stream.map(
          &%Geo.Point{
            coordinates: {&1["stop_lon"], &1["stop_lat"]}
          }
        )
    })
  end

  def stops_with_lat_long() do
    stops()
    |> Stream.filter(fn {_, stop} ->
      stop["stop_lat"] !== "" and
        stop["stop_lon"] !== ""
    end)
  end
end
