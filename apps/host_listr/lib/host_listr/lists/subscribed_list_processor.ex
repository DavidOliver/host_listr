defmodule HostListr.Lists.SubscribedListProcessor do
  @moduledoc """
  """

  @localhost_hosts_with_dots ~w(0.0.0.0 localhost.localdomain)s

  def process(list_contents) when is_binary(list_contents) do
    list_contents
    |> split_lines()
    |> Enum.map(&uncomment_line/1)
    |> Enum.reject(&empty?/1)
    |> Enum.map(&parse_hosts_format/1)
    |> Enum.filter(&contains_dot?/1)
    |> Enum.map(&parse_url/1)
    |> Enum.reject(&localhost?/1)
    |> Enum.join("\n")
  end

  def process_stream(list_contents_stream) do
    list_contents_stream
    |> Stream.map(&uncomment_line/1)
    |> Stream.reject(&empty?/1)
    |> Stream.map(&parse_hosts_format/1)
    |> Stream.filter(&contains_dot?/1)
    |> Stream.map(&parse_url/1)
    |> Stream.reject(&localhost?/1)
    |> Enum.join("\n")
  end

  def process_flow(list_contents_stage) do
    list_contents_stage
    |> Flow.from_stages()
    |> Flow.map(&uncomment_line/1)
    |> Flow.reject(&empty?/1)
    |> Flow.map(&parse_hosts_format/1)
    |> Flow.filter(&contains_dot?/1)
    |> Flow.map(&parse_url/1)
    |> Flow.reject(&localhost?/1)
    |> Enum.join("\n")
  end

  defp split_lines(content) when is_binary(content) do
    content
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
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
