defmodule Argonath.ProxyController do
  use Argonath.Web, :controller

  @opts [timeout: :infinity, recv_timeout: :infinity]

  def execute(%Plug.Conn{assigns: %{argonath: %{api: %{backend_url: url}}}, method: method, body_params: %{xml: parsed}, req_headers: headers} = conn, _params) do
    headers = headers
    |> List.keyreplace("host", 0, {"host", url.host})
    |> List.keydelete("accept-encoding", 0)
    body = :xmerl.export([parsed], :xmerl_xml)
    |> List.flatten
    |> String.Chars.to_string
    request(conn, method, URI.to_string(url), body, headers, @opts)
  end

  def execute(%Plug.Conn{assigns: %{argonath: %{api: %{backend_url: url}}}, method: method, body_params: body, req_headers: headers} = conn, _params) do
    headers = headers
    |> List.keyreplace("host", 0, {"host", url.host})
    |> List.keydelete("accept-encoding", 0)
    request(conn, method, URI.to_string(url), Poison.encode!(body), headers, @opts)
  end

  defp request(conn, method, url, body, headers, opts) do
    case HTTPoison.request(method, url, body, headers, opts) do
      { :ok, response } ->
        conn
        |> put_resp_content_type(
          case List.keyfind(response.headers, "Content-Type", 0) do
            {"Content-Type", content_type} ->  content_type
            _ -> "text/plain"
          end
        )
        |> send_resp(response.status_code, response.body)
      { :error, error } ->
        case error do
          %HTTPoison.Error{reason: :etimedout} ->
            conn
            |> put_status(:bad_gateway)
            |> send_resp(500, "TIMEOUT")
          _ ->
            conn
            |> put_status(:bad_gateway)
            |> send_resp(500, "UNKNOWN")
        end

    end
  end
end
