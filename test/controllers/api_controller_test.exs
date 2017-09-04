defmodule Argonath.APIControllerTest do
  use Argonath.ConnCase

  alias Argonath.API
  @valid_attrs %{backend_url: "some content", hosts: [], methods: [], name: "some content", uris: []}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing apis"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, api_path(conn, :new)
    assert html_response(conn, 200) =~ "New api"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, api_path(conn, :create), api: @valid_attrs
    assert redirected_to(conn) == api_path(conn, :index)
    assert Repo.get_by(API, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_path(conn, :create), api: @invalid_attrs
    assert html_response(conn, 200) =~ "New api"
  end

  test "shows chosen resource", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = get conn, api_path(conn, :show, api)
    assert html_response(conn, 200) =~ "Show api"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = get conn, api_path(conn, :edit, api)
    assert html_response(conn, 200) =~ "Edit api"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = put conn, api_path(conn, :update, api), api: @valid_attrs
    assert redirected_to(conn) == api_path(conn, :show, api)
    assert Repo.get_by(API, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = put conn, api_path(conn, :update, api), api: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit api"
  end

  test "deletes chosen resource", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = delete conn, api_path(conn, :delete, api)
    assert redirected_to(conn) == api_path(conn, :index)
    refute Repo.get(API, api.id)
  end
end
