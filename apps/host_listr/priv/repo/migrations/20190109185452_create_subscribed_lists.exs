defmodule HostListr.Repo.Migrations.CreateSubscribedLists do
  use Ecto.Migration

  def change do
    create table(:subscribed_lists) do
      add :url, :string, null: false, size: 2048
      add :content, :binary

      timestamps()
    end

    create unique_index(:subscribed_lists, [:url])
  end
end
