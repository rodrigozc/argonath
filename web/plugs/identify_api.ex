defmodule Argonath.IdentifyAPI do
  import Plug.Conn
  import Ecto.Query
  alias Argonath.API

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(%Plug.Conn{host: host, request_path: uri, method: method} = conn, repo) do
    case repo.all from a in API, select: {a.name, a.backend_url}, where: ^host in a.hosts and ^uri in a.uris and ^method in a.methods, order_by: [a.hosts, a.uris, a.methods] do
      [{name, backend_url}|_] ->
        conn
        |> assign(:argonath, %{api: %{name: name, backend_url: URI.parse(backend_url), plugins: %{xml_security: true}}})
      _ ->
        case repo.all from a in API, select: {a.name, a.backend_url}, where: ^host in a.hosts and ^uri in a.uris and not ^method in a.methods, order_by: [a.hosts, a.uris, a.methods] do
          [{name, backend_url}|_] ->
            conn
            |> assign(:argonath, %{api: %{name: name, backend_url: URI.parse(backend_url), plugins: %{xml_security: true}}})
          _ ->
            case repo.all from a in API, select: {a.name, a.backend_url}, where: ^host in a.hosts and not ^uri in a.uris and ^method in a.methods, order_by: [a.hosts, a.uris, a.methods] do
              [{name, backend_url}|_] ->
                conn
                |> assign(:argonath, %{api: %{name: name, backend_url: URI.parse(backend_url), plugins: %{xml_security: true}}})
              _ ->
                case repo.all from a in API, select: {a.name, a.backend_url}, where: ^host in a.hosts and not ^uri in a.uris and not ^method in a.methods, order_by: [a.hosts, a.uris, a.methods] do
                  [{name, backend_url}|_] ->
                    conn
                    |> assign(:argonath, %{api: %{name: name, backend_url: URI.parse(backend_url), plugins: %{xml_security: true}}})
                  _ ->
                    case repo.all from a in API, select: {a.name, a.backend_url}, where: not ^host in a.hosts and ^uri in a.uris and ^method in a.methods, order_by: [a.hosts, a.uris, a.methods] do
                      [{name, backend_url}|_] ->
                        conn
                        |> assign(:argonath, %{api: %{name: name, backend_url: URI.parse(backend_url), plugins: %{xml_security: true}}})
                      _ ->
                        case repo.all from a in API, select: {a.name, a.backend_url}, where: not ^host in a.hosts and ^uri in a.uris and not ^method in a.methods, order_by: [a.hosts, a.uris, a.methods] do
                          [{name, backend_url}|_] ->
                            conn
                            |> assign(:argonath, %{api: %{name: name, backend_url: URI.parse(backend_url), plugins: %{xml_security: true}}})
                          _ ->
                            case repo.all from a in API, select: {a.name, a.backend_url}, where: not ^host in a.hosts and not ^uri in a.uris and ^method in a.methods, order_by: [a.hosts, a.uris, a.methods] do
                              [{name, backend_url}|_] ->
                                conn
                                |> assign(:argonath, %{api: %{name: name, backend_url: URI.parse(backend_url), plugins: %{xml_security: true}}})
                              _ ->
                                conn
                                |> halt
                                |> send_resp(404, "API NOT FOUND")
                            end
                        end
                    end
                end
            end
        end
    end
  end

end
