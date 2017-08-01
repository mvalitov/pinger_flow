defmodule Pinger.Settings do
  use Ecto.Schema
  import Ecto.Query

  schema "settings" do
    field :name, :string
    field :value, :map
  end

  def by_name(name) do
    Pinger.Settings |> Pinger.Repo.get_by(name: name)
  end

end
