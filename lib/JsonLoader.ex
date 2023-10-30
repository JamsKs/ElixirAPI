defmodule JsonLoader do
  require Logger

  defp extract_and_insert_orders(database, list_of_maps) do
    # Enum.map(list_of_maps, fn map ->
    #   GenServer.call(database, {:insert, map["id"], map})
    # end)
    Stream.chunk_every(list_of_maps, 20)
    |> Task.async_stream(fn chunk ->
      Enum.map(chunk, fn map ->
        GenServer.call(database, {:insert, map["id"], map})
      end)
    end, max_concurrency: 50, timeout: :infinity)
    |> Stream.filter(& !is_nil(elem(&1, 1)))
    |> Enum.map(& elem(&1, 1))
    |> List.flatten()
  end

  def load_to_database(database, json_file) do
    with {:ok, json_data} <- File.read(json_file),
         {:ok, order_data} <- Poison.decode(json_data) do
      data = extract_and_insert_orders(database, order_data)
    end
  end
end
