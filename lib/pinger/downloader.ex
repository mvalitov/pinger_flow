defmodule Pinger.Downloader do
  require Logger
  @request_options [timeout: 30_000_000,
      recv_timeout: 30_000_000,
      connect_timeout: 30_000_000,
      hackney: [pool: false]]

  def download(group) do
    Logger.debug "#{inspect(self())} Download new proxy list, link #{group.url}"
    %HTTPoison.Response{body: body} = HTTPoison.get!(group.url, [], @request_options)
    prefix = "#{group.scheme}://"
    String.split(body, "\n")
    |> Enum.map(fn(x) -> prefix <> String.trim(x) end)
  end

end
