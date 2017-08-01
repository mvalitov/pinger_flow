defmodule Pinger.Group do
  use Ecto.Schema
  import Ecto.Query

  schema "groups" do
    field :name, :string
    field :enabled, :boolean
    field :comment, :string
    field :url, :string
    field :scheme, :string
    field :instable, :boolean
    field :reloadable, :boolean
    field :reload_frequency, :integer
  end

  def enabled do
    Pinger.Group |> Ecto.Query.where(enabled: true) |> Pinger.Repo.all
  end
end
