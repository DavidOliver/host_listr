defmodule RepoStream do
  @moduledoc """
  https://github.com/elixir-lang/gen_stage/issues/150#issuecomment-335104778

  Module for Ecto and GenStage to work together when you want to use
  Repo.stream in conjunction with a GenStage subscriber or a Flow.
  """

  defmodule Producer do
    use GenStage

    defstruct [:demand, :pid]

    def start_link() do
      GenStage.start_link(__MODULE__, self())
    end

    def init(caller) do
      {:producer, %{
        demand: 0,
        pid: caller
      }, []}
    end

    def handle_call({:set_receiver, pid}, state) do
      {:reply, :ok, [], %{state | pid: pid}}
    end

    def handle_demand(d, state) do
      send state.pid, {:demand, d}

      {:noreply, [], %{state | demand: d}}
    end

    def handle_subscribe(_, _, _, state) do
      send state.pid, :ready
      {:automatic, state}
    end

    def handle_info({:supply, items}, state) do
      remaining_demand =
        (state.demand - length(items))
        |> :erlang.max(0)

      if remaining_demand > 0 do
        send state.pid, {:demand, remaining_demand}
      end

      {:noreply, items, %{state | demand: remaining_demand}}
    end

    def terminate(_, _state) do
      :shutdown
    end
  end

  @doc """
  Sets up a producer stage that produces the messages from a repo stream

  Returns the producer stage which you can use for flow stuff
  """
  def query_into_stage(query, repo) do
    # chunk_size = 500
    stream = repo.stream(query)

    pid = self()

    Task.async(fn ->
      repo.transaction(fn ->
        {:ok, producer} = __MODULE__.Producer.start_link()

        Process.send_after pid, {:release, producer}, 100

        forward(stream, producer)
      end)
    end)

    receive do
      {:release, prod} -> prod
    end
  end

  defp forward(stream, producer) do
    # type acc :: {acc :: list[any], demand :: positive_integer}
    stream
    |> Stream.transform(
      fn ->
        receive do
          :ready -> :ok
        end
        {[], 0}
      end,
      fn
        event, {[], 0} ->
          receive do
            {:demand, 1} ->
              send producer, {:supply, [event]}
              {[], {[], 0}}
            {:demand, d} ->
              {[], {[event], d}}
          end
        event, {acc, d} when d > length(acc) + 1 ->
          {[], {[event | acc], d}}
        event, {acc, d} when d == length(acc) + 1 ->
          send producer, {:supply, [event | acc]}
          {[], {[], 0}}
      end,
      fn {acc, _} ->
        if length(acc) > 0 do
          send producer, {:supply, acc}
        end
        GenStage.stop(producer)
      end
    )
    |> Stream.run()
  end
end
