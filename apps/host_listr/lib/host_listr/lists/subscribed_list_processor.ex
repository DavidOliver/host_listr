defmodule HostListr.Lists.SubscribedListProcessor do
  @moduledoc """
  """

  @localhost_hosts_with_dots ~w(0.0.0.0 localhost.localdomain)s

  # text, potentially multi-line
  def process(hosts_source) when is_binary(hosts_source) do
    hosts_source
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Flow.from_enumerable()
    |> process_flow()
  end

  # stages
  def process(hosts_source) do
    hosts_source
    |> Flow.from_stages()
    |> process_flow()
  end

  defp process_flow(flow) do
    flow
    |> Flow.map(&uncomment_line/1)
    |> Flow.reject(&empty?/1)
    |> Flow.map(&parse_hosts_format/1)
    |> Flow.filter(&contains_dot?/1)
    |> Flow.map(&parse_url/1)
    |> Flow.reject(&localhost?/1)
    |> Enum.join("\n")
  end

  defp uncomment_line(line) when is_binary(line) do
    line
    |> String.split("#")
    |> List.first()
    |> String.trim()
  end

  defp empty?(line) when is_binary(line), do: line == ""
  defp contains_dot?(line) when is_binary(line), do: String.contains?(line, ".")

  defp parse_hosts_format(entry) when is_binary(entry) do
    entry
    |> String.split(" ", trim: true)
    |> case do
         substrs when length(substrs) > 1 -> Enum.at(substrs, 1)
         [str] -> str
         _ -> ""  # Still necessary? Remove to test with several blacklists.
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
  defp localhost?(_hostname), do: true  # what line is giving us nil here?
end
