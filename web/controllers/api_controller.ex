defmodule Argonath.APIController do
  use Argonath.Web, :controller

  alias Argonath.API

  def index(conn, _params) do
    apis = Repo.all(API)
    render(conn, "index.html", apis: apis)
  end

  def new(conn, _params) do
    changeset = API.changeset(%API{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"api" => api_params}) do
    changeset = API.changeset(%API{}, api_params)

    case Repo.insert(changeset) do
      {:ok, _api} ->
        conn
        |> put_flash(:info, "Api created successfully.")
        |> redirect(to: api_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    api = Repo.get!(API, id)
    render(conn, "show.html", api: api)
  end

  def edit(conn, %{"id" => id}) do
    api = Repo.get!(API, id)
    changeset = API.changeset(api)
    render(conn, "edit.html", api: api, changeset: changeset)
  end

  def update(conn, %{"id" => id, "api" => api_params}) do
    api_params
    |> Map.put_new("hosts", nil)
    |> Map.put_new("uris", nil)
    |> Map.put_new("methods", nil)
    api = Repo.get!(API, id)
    changeset = API.changeset(api, api_params)

    case Repo.update(changeset) do
      {:ok, api} ->
        conn
        |> put_flash(:info, "Api updated successfully.")
        |> redirect(to: api_path(conn, :show, api))
      {:error, changeset} ->
        render(conn, "edit.html", api: api, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    api = Repo.get!(API, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(api)

    conn
    |> put_flash(:info, "Api deleted successfully.")
    |> redirect(to: api_path(conn, :index))
  end
end
