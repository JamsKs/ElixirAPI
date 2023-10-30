defmodule MyDbServer do
  require Logger

  use GenServer

  def start_link(_data) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_data) do
    table = :ets.new(:test_table, [:named_table, read_concurrency: true])
    Logger.warn("Process Started")
    {:ok, table}
  end

  def error_gestion(key, table) do
    cond do
      :ets.info(table) == :undefined -> :table_is_not_up
      key in [nil, ""] -> :key_not_valid
      true -> :ok
    end
  end

  def handle_call({:insert, key, value}, _from, table) do
    case error_gestion(key, table) do
      :table_is_not_up ->
        {:reply, :table_is_not_up, table}

      :key_not_valid ->
        {:reply, :key_not_valid, table}

      :ok ->
        :ets.insert(table, {key, value})
        {:reply, :ok, table}
    end
  end

  def handle_call({:get, key}, _from, table) do
    case error_gestion(key, table) do
      :table_is_not_up -> {:reply, :table_is_not_up, table}
      :key_not_valid -> {:reply, :key_not_valid, table}
      :ok -> {:reply, :ets.lookup(table, key), table}
    end
  end

  def handle_call({:update, key, value}, _from, table) do
    # case lookup, and insert if found
    case error_gestion(key, table) do
      :table_is_not_up ->
        {:reply, :table_is_not_up, table}

      :key_not_valid ->
        {:reply, :key_not_valid, table}

      :ok ->
        case :ets.lookup(table, key) do
          [{^key, _pid}] ->
            :ets.insert(table, {key, value})
            {:reply, :ok, table}

          [] ->
            {:reply, :tables_non_existant, table}
        end
    end
  end

  def handle_call({:delete, key}, _from, table) do
    case error_gestion(key, table) do
      :table_is_not_up ->
        {:reply, :table_is_not_up, table}

      :key_not_valid ->
        {:reply, :key_not_valid, table}

      :ok ->
        :ets.delete(table, key)
        {:reply, :ok, table}
    end
  end

  def handle_call({:search, criterias}, _from, table) do
    cond do
      :ets.info(table) == :undefined -> {:reply, :table_is_not_up, table}
      true ->
        res = :ets.tab2list(table)
        |> Task.async_stream(fn {_, map} ->
          res = Enum.map(criterias, fn {key, value} ->
            case map[key] do
              ^value -> map
              _ -> nil
            end
          end)
          |> Enum.filter(& !is_nil(&1))
          if (res == []), do: nil, else: map
        end)
        |> Stream.filter(& !is_nil(elem(&1, 1)))
        |> Enum.map(& elem(&1, 1)) # on vire le :ok de {:ok, return}
        {:reply, res, table}
    end
  end
end


defmodule Database do
  def search(database, criterias) do
    GenServer.call(database, {:search, criterias})
  end
end
