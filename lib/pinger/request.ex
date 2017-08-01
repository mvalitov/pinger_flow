defmodule Pinger.Request do
  require Logger
  def ping(params) do
    url = params[:url] || "https://ip.nf/me.json"
    proxy = case params[:proxy] do
      nil -> raise "Proxy is nil"
      _-> params[:proxy]
    end
    uri = URI.parse(proxy)
    options =
      case uri.scheme do
        "socks5" -> default_params(params[:options]["timeout"]) ++ [proxy: {:socks5, String.to_charlist(uri.host), uri.port}]
        _-> default_params(params[:options]["timeout"]) ++ [proxy: String.to_charlist(proxy)]
      end
    try do
      case HTTPoison.request(:get, String.to_charlist(url), "", [], options) do
        {:ok, response} ->
          %HTTPoison.Response{body: body, headers: list, status_code: integer} = response
          Poison.Parser.parse!(body)
        {:error, reason} ->
          reason
      end
    rescue
      error -> %HTTPoison.Error{}
    end
  end

# timeout in milliseconds
  defp default_params(timeout \\ 5) do
    [ssl: [verify: :verify_none],
    timeout: timeout*1000,
    recv_timeout: timeout*1000,
    connect_timeout: timeout*1000,
    hackney: [pool: false, insecure: true]]
  end

end
