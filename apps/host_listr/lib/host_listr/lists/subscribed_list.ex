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
    |> changeset_common(attrs)
  end

  @doc false
  def changeset_create(subscribed_list, attrs) do
    subscribed_list
    |> cast(attrs, [:url])
    |> changeset_common(attrs)
  end

  @doc false
  def changeset_update(subscribed_list, attrs) do
    subscribed_list
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> changeset_common(attrs)
  end

  @doc false
  def changeset_common(subscribed_list, _attrs) do
    subscribed_list
    |> validate_required([:url])
    |> validate_length(:url, max: 2048)
    |> unique_constraint(:url)
  end
end
