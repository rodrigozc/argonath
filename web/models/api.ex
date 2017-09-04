defmodule Argonath.API do
  use Argonath.Web, :model

  schema "apis" do
    field :name, :string
    field :hosts, {:array, :string}
    field :uris, {:array, :string}
    field :methods, {:array, :string}
    field :backend_url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :hosts, :uris, :methods, :backend_url])
    |> validate_required([:name, :hosts, :uris, :methods, :backend_url])
  end
end
