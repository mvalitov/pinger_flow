defmodule Pinger.Worker do
    use GenStage
    require Logger
    alias Pinger.Group
    alias Pinger.Downloader
    alias Pinger.Settings
    alias Pinger.Proxy

    def start_link() do
        GenServer.start_link(__MODULE__, %{})
    end

    def init(state) do
        {:ok, conn} = Redix.start_link(host: Application.get_env(:pinger, :redis_host), port: Application.get_env(:pinger, :redis_port))
        schedule_work()
        {:ok, conn}
    end

    def handle_info(:work, conn) do
        groups = Group.enabled
        Logger.debug "#{inspect(self())} LOADER init #{inspect(groups)}"
        options = Settings.by_name("pinger")
        Logger.debug "#{inspect(self)} start parallel map"
        Parallel.pmap(groups, fn(group) -> run_flow(group, options.value["request"], conn) end)
        Logger.debug "#{inspect(self)} end parallel map"
        schedule_work() # Reschedule once more
        {:noreply, conn}
    end

    defp run_flow(group, options, conn) do
        Logger.debug "#{inspect(self)} start run flow"
        proxies = Downloader.download(group)
        |> generate_proxies(group.id)
        save_count(conn, length(proxies), group.id)
        proxies
        |> Flow.from_enumerable(stages: Application.get_env(:pinger, :stages), min_demand: Application.get_env(:pinger, :min_demand), max_demand: Application.get_env(:pinger, :max_demand))
        |> Flow.map(fn(p) -> ping(p, options) end)
        |> Flow.reject(fn(x) -> x == nil end)
        |> Flow.map(fn(p) -> save(p, conn) end)
        |> Flow.run
        Logger.debug "#{inspect(self)} end run flow"
    end

    defp generate_proxies list, id do
        for l <- list do
            %Proxy{group_id: id, url: l}
        end
    end

    defp save_count(conn, count, group_id) do
        Redix.command(conn, ["SET", "proxy|count|group_#{group_id}", count])
    end

    defp save(proxy, conn) do
        Logger.warn "#{inspect(self)} save #{inspect(proxy)}"
        Proxy.save(proxy, conn)
    end

    defp ping(proxy, options) do
        Logger.debug "#{inspect(self)} ping proxy #{proxy.url}"
        ip = Pinger.Request.ping([proxy: proxy.url, options: options])
        case ip do
        %HTTPoison.Error{} ->
            Logger.info "#{inspect(proxy)} is BAD"
            nil
        %{} -> %{proxy | ip: ip["ip"]["ip"], country_code: ip["ip"]["country_code"]}
        # %{} -> geo = lookup(ip) %{proxy | ip: ip, country_code: geo.country, region_code: geo.region}
        end
    end

    defp lookup(ip) do
        IP2Location.lookup(ip)
    end

    defp schedule_work() do
        Process.send(self(), :work, []) # In 5 sec
    end

end