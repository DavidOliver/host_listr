defmodule HostListrWeb.SubscribedListControllerTest do
  use HostListrWeb.ConnCase

  alias HostListr.Lists

  @create_attrs %{url: "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"}
  @invalid_attrs %{url: nil}

  def fixture(:subscribed_list) do
    {:ok, subscribed_list} = Lists.create_subscribed_list(@create_attrs)
    subscribed_list
  end

  describe "index" do
    test "lists all subscribed_lists", %{conn: conn} do
      conn = get(conn, Routes.subscribed_list_path(conn, :index))
      assert html_response(conn, 200) =~ "Subscribed lists"
    end
  end

  describe "new subscribed_list" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.subscribed_list_path(conn, :new))
      assert html_response(conn, 200) =~ "Add Subscribed list"
    end
  end

  describe "create subscribed_list" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.subscribed_list_path(conn, :create), subscribed_list: @create_attrs)
      assert redirected_to(conn) == Routes.subscribed_list_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.subscribed_list_path(conn, :create), subscribed_list: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add Subscribed list"
    end
  end

  describe "delete subscribed_list" do
    setup [:create_subscribed_list]

    test "deletes chosen subscribed_list", %{conn: conn, subscribed_list: subscribed_list} do
      conn = delete(conn, Routes.subscribed_list_path(conn, :delete, subscribed_list))
      assert redirected_to(conn) == Routes.subscribed_list_path(conn, :index)
    end
  end

  defp create_subscribed_list(_) do
    subscribed_list = fixture(:subscribed_list)
    {:ok, subscribed_list: subscribed_list}
  end
end
