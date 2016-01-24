defmodule ExHeos.Util do
  alias Nerves.SSDPClient

  @target "urn:schemas-denon-com:device:ACT-Denon:1"

  def discover(nodes) when nodes |> map_size > 0 do
    nodes
    |> Enum.filter(fn (device) ->
      case device do
        {_, %{server: "LINUX UPnP/1.0 Denon ACT/" <> _}} -> true
        _ -> false
      end
    end)
    |> discover
  end
  def discover(devices) when devices |> length > 0, do: {:ok, devices}
  def discover(_), do: {:error, "Could not find any HEOS devices."}
  def discover(), do: SSDPClient.discover([target: @target]) |> discover
end
