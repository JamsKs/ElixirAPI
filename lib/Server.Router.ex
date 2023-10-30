defmodule Server.Router do
  import Plug.Conn
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/insert" do
    params = fetch_query_params(conn)

    case GenServer.call(
           MyDbServer,
           {:insert, params.query_params["id"], params.query_params["value"]}
         ) do
      :table_is_not_up -> send_resp(conn, 500, "Table is not up")
      :key_not_valid -> send_resp(conn, 400, "Key is not valid")
      _ -> send_resp(conn, 200, "The element has successfully been added to the db")
    end
  end

  get "/get" do
    params = fetch_query_params(conn)

    case GenServer.call(
           MyDbServer,
           {:get, params.query_params["id"]}
         ) do
      :table_is_not_up -> send_resp(conn, 500, "Table is not up")
      :key_not_valid -> send_resp(conn, 400, "Key is not valid")
      [] -> send_resp(conn, 404, "The element does not exist in the db")
      [{key, value}] -> send_resp(conn, 200, "{#{key}: #{value}}")
    end
  end

  get "/delete" do
    params = fetch_query_params(conn)

    case GenServer.call(
           MyDbServer,
           {:delete, params.query_params["id"]}
         ) do
      :table_is_not_up -> send_resp(conn, 500, "Table is not up")
      :key_not_valid -> send_resp(conn, 400, "Key is not valid")
      _ -> send_resp(conn, 200, "The element has been succesfully deleted from the db")
    end
  end

  get "/update" do
    params = fetch_query_params(conn)

    case GenServer.call(
           MyDbServer,
           [{:update, params.query_params["id"], params.query_params["value"]}]
         ) do
      :table_is_not_up -> send_resp(conn, 500, "Table is not up")
      :key_not_valid -> send_resp(conn, 400, "Key is not valid")
      _ -> send_resp(conn, 200, "The element has successfully been updated to the db")
    end
  end

  get "/search" do
    params = fetch_query_params(conn)

    case Database.search(
           MyDbServer,
           [{params.query_params["id"], params.query_params["value"]}]
         ) do
      [] -> send_resp(conn, 404, "The element does not exist in the db")
      _ -> send_resp(conn, 200, "It works")
    end
  end

  match _ do
    send_resp(conn, 404, "Page Not Found")
  end
end
