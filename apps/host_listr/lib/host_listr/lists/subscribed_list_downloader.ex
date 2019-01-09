defmodule HostListr.Lists.SubscribedListDownloader do
  use Tesla

  def get(url) when is_binary(url) do
    get(url)
  end
end
