defmodule BtmWeb.PageController do
  use BtmWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> assign(:stops, Btm.Stops.stops_with_lat_long())
    |> assign(:maptiler_key, Application.get_env(:btm, :maptiler_key, nil))
    |> render(:home, layout: false)
  end

  def stops_geojson(conn, _params) do
    json(
      conn,
      Geo.JSON.encode!(%Geo.MultiPoint{
        coordinates:
          Btm.Stops.stops_with_lat_long()
          |> Stream.map(fn {:ok, stop} -> stop end)
          |> Stream.map(&{&1["stop_lon"], &1["stop_lat"]})
      })
    )
  end
end
