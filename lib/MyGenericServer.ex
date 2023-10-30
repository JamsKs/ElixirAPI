defmodule MyGenericServer do
  def loop({callback_module, server_state}) do
    receive do
      {:cast, request} ->
        loop({callback_module, callback_module.handle_cast(request, server_state)})

      {:call, from, request} ->
        {response, state} = callback_module.handle_call(request, server_state)
        send(from, response)
        loop({callback_module, state})
        # {:credit, x} ->
        #   loop({callback_module, server_state + x})

        # {:debit, x} ->
        #   loop({callback_module, server_state - x})

        # {:get, x} ->
        #   send(x, server_state)
        #   loop({callback_module, server_state})
    end
  end

  def cast(process_pid, request) do
    send(process_pid, {:cast, request})
  end

  def call(process_pid, request) do
    send(process_pid, {:call, self(), request})

    receive do
      server_state -> server_state
    end
  end

  def start_link(callback_module, server_initial_state) do
    your_process_pid = spawn_link(fn -> loop({callback_module, server_initial_state}) end)
    {:ok, your_process_pid}
  end
end
