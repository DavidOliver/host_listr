defmodule HostListr.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias HostListr.Repo

  alias HostListr.Lists.{SubscribedList, SubscribedListProcessor, SubscribedListDownloader}

  @doc """
  Returns the list of subscribed_lists.

  ## Examples

      iex> list_subscribed_lists()
      [%SubscribedList{}, ...]

  """
  def list_subscribed_lists do
    SubscribedList
    |> select_subscribed_lists_basics()
    |> Repo.all()
  end

  @doc """
  Gets a single subscribed_list.

  Raises `Ecto.NoResultsError` if the Subscribed list does not exist.

  ## Examples

      iex> get_subscribed_list!(123)
      %SubscribedList{}

      iex> get_subscribed_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscribed_list!(id) do
    SubscribedList
    |> select_subscribed_lists_basics()
    |> Repo.get!(id)
  end

  @doc """
  Creates a subscribed_list.

  ## Examples

      iex> create_subscribed_list(%{field: value})
      {:ok, %SubscribedList{}}

      iex> create_subscribed_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscribed_list(attrs \\ %{}) do
    %SubscribedList{}
    |> SubscribedList.changeset_create(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subscribed_list.

  ## Examples

      iex> update_subscribed_list(subscribed_list, %{field: new_value})
      {:ok, %SubscribedList{}}

      iex> update_subscribed_list(subscribed_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscribed_list(%SubscribedList{} = subscribed_list, attrs) do
    subscribed_list
    |> SubscribedList.changeset_update(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SubscribedList.

  ## Examples

      iex> delete_subscribed_list(subscribed_list)
      {:ok, %SubscribedList{}}

      iex> delete_subscribed_list(subscribed_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscribed_list(%SubscribedList{} = subscribed_list) do
    Repo.delete(subscribed_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscribed_list changes.

  ## Examples

      iex> change_subscribed_list(subscribed_list)
      %Ecto.Changeset{source: %SubscribedList{}}

  """
  def change_subscribed_list(%SubscribedList{} = subscribed_list) do
    SubscribedList.changeset(subscribed_list, %{})
  end

  defp select_subscribed_lists_basics(query) do
    query
    |> from(select: [:id, :url, :inserted_at, :updated_at])
  end


  @doc """
  """
  def pull_subscribed_lists() do
    list_subscribed_lists()
    |> Enum.each(&pull_subscribed_list/1)
  end

  defp pull_subscribed_list(%SubscribedList{} = subscribed_list) do
    {:ok, response} = SubscribedListDownloader.get(subscribed_list.url)
    update_subscribed_list(subscribed_list, %{content: response.body})
  end


  @doc """
  """
  def process_list(id) do
    list = get_subscribed_list_content!(id)
    SubscribedListProcessor.process(list.content)
  end

  defp get_subscribed_list_content!(id) do
    SubscribedList
    |> from(select: [:content])
    |> Repo.get!(id)
  end


  # @doc """
  # """
  # def process_list_stream(id) do
  #   stream = stream_subscribed_list_content!(id)
  #   {:ok, processed_list_content} = Repo.transaction(fn() ->
  #     SubscribedListProcessor.process_stream(stream)
  #   end)
  #   processed_list_content
  # end

  # https://hexdocs.pm/ecto/Ecto.Repo.html#c:stream/2
  # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html#stream/4
  # defp stream_subscribed_list_content!(id) do
  #   query = subscribed_list_content_query(id)
  #   Repo.stream(query)
  # end


  @doc """
  """
  # Ecto 3.1 may make it possible to stream from an Ecto transaction to Flow.
  # https://elixirforum.com/t/repo-stream-flow-from-enumerable/16477
  # https://github.com/elixir-lang/gen_stage/issues/150
  # def process_list_flow(id) do
  #   stream = stream_subscribed_list_content!(id)
  #   {:ok, processed_list_content} = Repo.transaction(fn() ->
  #     SubscribedListProcessor.process_flow(stream)
  #   end)
  # end

  # In the meantime, we're using Moritz Schmale's (narrowtux) module
  # to "hack an Ecto stream into a GenStage producer".
  def process_list_flow(id) do
    pid =
      id
        |> subscribed_list_content_query()
        |> RepoStream.query_into_stage(HostListr.Repo)
    [pid]
    |> SubscribedListProcessor.process_flow()
  end


  # split on line break *and* remove comments?
  # |> select(fragment("split_part(regexp_split_to_table(content, '\\n'), '#', 1)"))
  defp subscribed_list_content_query(id) do
    SubscribedList
    |> select(fragment("regexp_split_to_table(content, '\\n')"))
    |> where(id: ^id)
  end


  def benchmark(id) do
    Benchee.run(
      %{
        "process_list"        => fn -> process_list(id) end,
        # "process_list_stream" => fn -> process_list_stream(id) end,
        "process_list_flow"   => fn -> process_list_flow(id) end,
      },
      parallel: 1,
      time: 1,
      memory_time: 1,
      console: [extended_statistics: true]
    )
    :ok
  end
end
