defmodule HostListr.ListsTest do
  use HostListr.DataCase

  alias HostListr.Lists

  describe "subscribed_lists" do
    alias HostListr.Lists.SubscribedList

    @valid_attrs %{content: "some content", url: "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"}
    @valid_create_attrs %{url: "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"}
    @invalid_create_attrs %{url: nil}
    @valid_update_attrs %{content: "updated content"}
    @invalid_update_attrs %{content: nil}

    def subscribed_list_fixture(attrs \\ %{}) do
      {:ok, subscribed_list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lists.create_subscribed_list()

      subscribed_list
    end

    test "list_subscribed_lists/0 returns all subscribed_lists" do
      subscribed_list = subscribed_list_fixture()
      assert Lists.list_subscribed_lists() == [subscribed_list]
    end

    test "get_subscribed_list!/1 returns the subscribed_list with given id" do
      subscribed_list = subscribed_list_fixture()
      assert Lists.get_subscribed_list!(subscribed_list.id) == subscribed_list
    end

    test "create_subscribed_list/1 with valid data creates a subscribed_list" do
      assert {:ok, %SubscribedList{} = subscribed_list} = Lists.create_subscribed_list(@valid_create_attrs)
      assert subscribed_list.url == @valid_create_attrs.url
    end

    test "create_subscribed_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_subscribed_list(@invalid_create_attrs)
    end

    test "update_subscribed_list/2 with valid data updates the subscribed_list" do
      subscribed_list = subscribed_list_fixture()
      assert {:ok, %SubscribedList{} = subscribed_list} = Lists.update_subscribed_list(subscribed_list, @valid_update_attrs)
      assert subscribed_list.content == @valid_update_attrs.content
    end

    test "update_subscribed_list/2 with invalid data returns error changeset" do
      subscribed_list = subscribed_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_subscribed_list(subscribed_list, @invalid_update_attrs)
      assert subscribed_list == Lists.get_subscribed_list!(subscribed_list.id)
    end

    test "delete_subscribed_list/1 deletes the subscribed_list" do
      subscribed_list = subscribed_list_fixture()
      assert {:ok, %SubscribedList{}} = Lists.delete_subscribed_list(subscribed_list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_subscribed_list!(subscribed_list.id) end
    end

    test "change_subscribed_list/1 returns a subscribed_list changeset" do
      subscribed_list = subscribed_list_fixture()
      assert %Ecto.Changeset{} = Lists.change_subscribed_list(subscribed_list)
    end
  end
end
