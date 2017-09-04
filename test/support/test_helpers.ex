defmodule Argonath.TestHelpers do
  alias Argonath.Repo

  def insert_api(attrs \\ %{}) do
    changes = Map.merge(
      %{
        backend_url: "http://localhost:4000",
        hosts: [],
        methods: [],
        name: "Some API",
        uris: []
      },
      attrs
    )

    %Argonath.API{}
    |> Argonath.API.changeset(changes)
    |> Repo.insert!()
  end

end
