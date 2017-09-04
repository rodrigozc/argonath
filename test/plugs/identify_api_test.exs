defmodule Argonath.IdentifyAPITest do
  use Argonath.ConnCase

  @api01 %{name: "api01", hosts: ["argonath.io"], uris: ["/api"], methods: ["GET"], backend_url: "http://argonath.io/api"}
  @api02 %{name: "api02", hosts: ["argonath.io"], uris: ["/api"],                   backend_url: "http://argonath.io/api"}
  @api03 %{name: "api03", hosts: ["argonath.io"],                 methods: ["GET"], backend_url: "http://argonath.io/api"}
  @api04 %{name: "api04", hosts: ["argonath.io"],                                   backend_url: "http://argonath.io/api"}
  @api05 %{name: "api05",                         uris: ["/api"], methods: ["GET"], backend_url: "http://argonath.io/api"}
  @api06 %{name: "api06",                         uris: ["/api"],                   backend_url: "http://argonath.io/api"}
  @api07 %{name: "api07",                                         methods: ["GET"], backend_url: "http://argonath.io/api"}

  setup conn do
    insert_api(@api01)
    insert_api(@api02)
    insert_api(@api03)
    insert_api(@api04)
    insert_api(@api05)
    insert_api(@api06)
    insert_api(@api07)
    {:ok, conn}
  end

  test "Match all parameters" do
    conn = build_conn(:get, "/api")
    |> put_req_header("host", "argonath.io")
    |> Map.put(:host, "argonath.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.assigns.argonath.api.backend_url.authority == "argonath.io"
    assert conn.assigns.argonath.api.name == "api01"
  end

  test "Match host and uri" do
    conn = build_conn(:delete, "/api")
    |> put_req_header("host", "argonath.io")
    |> Map.put(:host, "argonath.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.assigns.argonath.api.backend_url.authority == "argonath.io"
    assert conn.assigns.argonath.api.name == "api02"
  end

  test "Match host and method" do
    conn = build_conn(:get, "/")
    |> put_req_header("host", "argonath.io")
    |> Map.put(:host, "argonath.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.assigns.argonath.api.backend_url.authority == "argonath.io"
    assert conn.assigns.argonath.api.name == "api03"
  end

  test "Match host" do
    conn = build_conn(:delete, "/")
    |> put_req_header("host", "argonath.io")
    |> Map.put(:host, "argonath.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.assigns.argonath.api.backend_url.authority == "argonath.io"
    assert conn.assigns.argonath.api.name == "api04"
  end

  test "Match uri and method" do
    conn = build_conn(:get, "/api")
    |> put_req_header("host", "another.io")
    |> Map.put(:host, "another.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.assigns.argonath.api.backend_url.authority == "argonath.io"
    assert conn.assigns.argonath.api.name == "api05"
  end

  test "Match uri" do
    conn = build_conn(:put, "/api")
    |> put_req_header("host", "another.io")
    |> Map.put(:host, "another.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.assigns.argonath.api.backend_url.authority == "argonath.io"
    assert conn.assigns.argonath.api.name == "api06"
  end

  test "Match method" do
    conn = build_conn(:get, "/")
    |> put_req_header("host", "another.io")
    |> Map.put(:host, "another.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.assigns.argonath.api.backend_url.authority == "argonath.io"
    assert conn.assigns.argonath.api.name == "api07"
  end

  test "API not found" do
    conn = build_conn(:put, "/")
    |> put_req_header("host", "another.io")
    |> Map.put(:host, "another.io")
    |> Argonath.IdentifyAPI.call(Argonath.Repo)
    assert conn.halted
    assert response(conn, 404)
  end

end
