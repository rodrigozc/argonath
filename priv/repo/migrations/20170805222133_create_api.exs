defmodule Argonath.Repo.Migrations.CreateAPI do
  use Ecto.Migration

  def change do
    create table(:apis) do
      add :name, :string
      add :hosts, {:array, :string}
      add :uris, {:array, :string}
      add :methods, {:array, :string}
      add :backend_url, :string

      timestamps()
    end

  end
end
