defmodule HostListrWeb.SubscribedListController do
  use HostListrWeb, :controller

  alias HostListr.Lists
  alias HostListr.Lists.SubscribedList

  def index(conn, _params) do
    subscribed_lists = Lists.list_subscribed_lists()
    render(conn, "index.html", subscribed_lists: subscribed_lists)
  end

  def new(conn, _params) do
    changeset = Lists.change_subscribed_list(%SubscribedList{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"subscribed_list" => subscribed_list_params}) do
    case Lists.create_subscribed_list(subscribed_list_params) do
      {:ok, subscribed_list} ->
        conn
        |> put_flash(:info, "#{subscribed_list.url} added.")
        |> redirect(to: Routes.subscribed_list_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    subscribed_list = Lists.get_subscribed_list!(id)
    render(conn, "show.html", subscribed_list: subscribed_list)
  end

  def delete(conn, %{"id" => id}) do
    subscribed_list = Lists.get_subscribed_list!(id)
    {:ok, subscribed_list} = Lists.delete_subscribed_list(subscribed_list)

    conn
    |> put_flash(:info, "#{subscribed_list.url} deleted.")
    |> redirect(to: Routes.subscribed_list_path(conn, :index))
  end
end
