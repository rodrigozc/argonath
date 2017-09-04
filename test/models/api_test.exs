defmodule Argonath.APITest do
  use Argonath.ModelCase

  alias Argonath.API

  @valid_attrs %{backend_url: "some content", hosts: [], methods: [], name: "some content", uris: []}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = API.changeset(%API{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = API.changeset(%API{}, @invalid_attrs)
    refute changeset.valid?
  end
end
