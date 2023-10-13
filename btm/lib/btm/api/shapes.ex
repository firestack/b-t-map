defmodule Btm.Api.Shapes do
  @type shape_id :: String.t()
  @type shape_points :: [%{seq: integer, lat: float, long: float}]

  @type shape_point :: %{
          id: shape_id,
          seq: integer,
          lat: float,
          long: float
        }

  @type shape_map :: %{shape_id => shape_points}
  @type shape :: {shape_id, shape_points}

  @spec shapes() :: Stream.default()
  def shapes() do
    "./priv/transient/gtfs/shapes.txt"
    |> File.stream!()
    |> CSV.decode!(headers: true)
  end

  @spec shapes(:by_id) :: %{shape_id => [shape_point]}
  def shapes(:by_id) do
    shapes()
    |> Enum.group_by(
      fn shape -> shape["shape_id"] end,
      fn shape ->
        %{
          id: shape["shape_id"],
          seq: String.to_integer(shape["shape_pt_sequence"]),
          lat: String.to_float(shape["shape_pt_lat"]),
          long: String.to_float(shape["shape_pt_lon"])
        }
      end
    )
  end

  @spec shapes(:geojson) :: Geo.GeometryCollection.t()
  def shapes(:geojson) do
    features =
      shapes(:by_id)
      # |> Enum.take(1)
      # |> dbg
      |> Enum.map(fn {id, points} ->
        points =
          Enum.sort(points, fn lhs, rhs ->
            lhs.seq < rhs.seq
          end)
          |> Enum.map(&{&1.long, &1.lat})

        %Geo.LineString{
          coordinates: points
        }
      end)

    %Geo.GeometryCollection{
      geometries: features
    }
  end
end
