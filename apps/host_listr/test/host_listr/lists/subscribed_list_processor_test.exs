defmodule HostListr.Lists.SubscribedListProcessorTest do
  use HostListr.DataCase

  # alias HostListr.Lists
  # alias HostListr.Lists.SubscribedList
  import HostListr.Lists.SubscribedListProcessor

  describe "subscribed_list processor process" do
    test "hostname" do
      assert process("example.com") == "example.com"
    end

    test "hostnames separated by multiple line breaks" do
      assert process("1.com\n\n2.com") == "1.com\n2.com"
    end

    test "hostname with leading and trailing whitespace" do
      assert process(" example.com   ") == "example.com"
    end

    test "hostname appended with comment" do
      assert process("example.com # comment") == "example.com"
    end

    test "IPv4 hosts entry" do
      assert process("0.0.0.0 example.com") == "example.com"
    end

    test "IPv4 hosts entry with multiple spaces between address and hostname" do
      assert process("0.0.0.0   example.com") == "example.com"
    end

    test "IPv4 hosts entry with shorthand address '0'" do
      assert process("0 example.com") == "example.com"
    end

    test "IPv4 hosts entry appended with comment" do
      assert process("0.0.0.0 example.com #[Comment]") == "example.com"
    end

    test "IPv6 hosts entry with shorthand address '::'" do
      assert process(":: example.com") == "example.com"
    end

    test "URL including http protocol" do
      assert process("http://example.com") == "example.com"
    end

    test "URL including https protocol and subdomain" do
      assert process("https://subdomain.example.com") == "subdomain.example.com"
    end

    test "URL including http protocol and username and password" do
      assert process("http://username:password@example.com") == "example.com"
    end
  end

  describe "subscribed_list processor reject" do
    test "localhost" do
      assert process("localhost") == ""
    end
  end
end
