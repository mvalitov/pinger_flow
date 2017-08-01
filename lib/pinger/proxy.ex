defmodule Pinger.Proxy do
  @derive {Poison.Encoder, except: [:ip]}
  defstruct url: nil, ip: nil, country_code: nil, group_id: nil, region_code: nil

  def save(proxy, conn) do
    json = Poison.encode!(proxy)
    {:ok, group_queue} = RedisUniqueQueue.create("proxy|groups|group_#{proxy.group_id}", conn)
    RedisUniqueQueue.push(group_queue, json)
    {:ok, country_queue} = RedisUniqueQueue.create("proxy|countries|#{proxy.country_code}", conn)
    RedisUniqueQueue.push(country_queue, json)
  end
end
