defmodule HostListr.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias HostListr.Repo

  alias HostListr.Lists.SubscribedList

  @doc """
  Returns the list of subscribed_lists.

  ## Examples

      iex> list_subscribed_lists()
      [%SubscribedList{}, ...]

  """
  def list_subscribed_lists do
    Repo.all(SubscribedList)
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
  def get_subscribed_list!(id), do: Repo.get!(SubscribedList, id)

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
end