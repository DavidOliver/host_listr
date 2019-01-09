defmodule HostListr.Lists.SubscribedList do
  use Ecto.Schema
  import Ecto.Changeset


  schema "subscribed_lists" do
    field :content, :binary
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(subscribed_list, attrs) do
    subscribed_list
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
  end

  @doc false
  def changeset_create(subscribed_list, attrs) do
    subscribed_list
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
  end

  @doc false
  def changeset_update(subscribed_list, attrs) do
    subscribed_list
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
