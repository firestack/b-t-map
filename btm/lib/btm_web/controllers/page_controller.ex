defmodule BtmWeb.PageController do
  use BtmWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> assign(:maptiler_key, Application.get_env(:btm, :maptiler_key, nil))
    |> render(:home, layout: false)
  end
  end
end
