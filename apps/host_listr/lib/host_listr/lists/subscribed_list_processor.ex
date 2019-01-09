defmodule HostListr.Lists.SubscribedListProcessor do
  @moduledoc """
  """

  @localhost_hosts_with_dots ~w(0.0.0.0 localhost.localdomain)s

  def process(list_contents) when is_binary(list_contents) do
    list_contents
    |> split_lines()
    |> Enum.map(&uncomment_line/1)
    |> Enum.reject(&extraneous?/1)
    |> Enum.map(&process_entry/1)
    |> Enum.reject(&localhost?/1)
    |> Enum.join("\n")
  end

  defp split_lines(blacklists_content) do
    blacklists_content
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
  end

  defp uncomment_line(line) when is_binary(line) do
    line
    |> String.split("#")
    |> List.first()
    |> String.trim()
  end

  defp extraneous?(entry) when is_binary(entry) do
    with false <- entry == "",
         true  <- String.contains?(entry, ".")
    do
      false
    else
      _ -> true
    end
  end

  defp process_entry(entry) when is_binary(entry) do
    entry
    |> parse_hosts_format()
    |> parse_url()
  end

  defp parse_hosts_format(entry) when is_binary(entry) do
    entry
    |> String.split(" ", trim: true)
    |> case do
         substrs when length(substrs) > 1 -> Enum.at(substrs, 1)
         str -> hd(str)
       end
  end

  defp parse_url(entry) when is_binary(entry) do
    entry
    |> normalise_url_protocol()
    |> URI.parse()
    |> uri_to_hostname()
  end

  defp normalise_url_protocol(entry) when is_binary(entry) do
    entry
    |> String.replace_prefix("https://", "")
    |> String.replace_prefix("http://", "")
    |> String.replace_prefix("", "//")
  end

  defp uri_to_hostname(%URI{:host => host}), do: host

  defp localhost?(hostname) when is_binary(hostname) do
    Enum.member?(@localhost_hosts_with_dots, hostname)
  end

end
