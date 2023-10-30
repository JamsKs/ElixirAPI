defmodule MyModule do
  require Poison

  def decode_json_file(file_path) do
    with {:ok, file} <- File.open(file_path, [:read, :utf8]),
         {:ok, %{"order_id" => first_order_id} = first_order_data} <- read_json(file),
         {:ok, decoded_data} <- collect_data(file, first_order_id, first_order_data) do
      {:ok, decoded_data}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp read_json(file) do
    case IO.read(file, :line) do
      :eof ->
        {:error, "JSON file is empty"}
      line ->
        case Poison.decode(line) do
          {:ok, %{"order_id" => order_id} = data} ->
            {:ok, order_id, data}
          {:error, _} ->
            {:error, "Invalid JSON format in the file"}
        end
    end
  end

  defp collect_data(file, order_id, data) do
    case IO.read(file, :line) do
      :eof ->
        {:ok, %{order_id => data}}
      line ->
        case Poison.decode(line) do
          {:ok, %{"order_id" => new_order_id} = new_data} when new_order_id != order_id ->
            {:ok, Map.put(%{order_id => data}, new_order_id, new_data)}
          {:ok, _} ->
            collect_data(file, order_id, data)
          {:error, _} ->
            {:error, "Invalid JSON format in the file"}
        end
    end
  end
end
