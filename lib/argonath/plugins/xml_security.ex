defmodule Argonath.Plugins.XMLSecurity do

  import Plug.Conn

  @behaviour Plug
  @behaviour Argonath.Behaviours.Plugin

  @alias 'wsse'
  @namespace :"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"

  @element_security '//wsse:Security'
  @element_username '//wsse:Username/text()'
  @element_password '//wsse:Password/text()'

  def config do
    %{xml_security: %{}}
  end

  def init([]), do: []

  def call(%Plug.Conn{body_params: %{xml: _xml}, assigns: %{argonath: %{api: %{plugins: %{xml_security: true}}}}} = conn, []) do
    conn
    |> parse_wssecurity
    |> authenticate
  end

  def call(conn, []), do: conn

  defp parse_wssecurity(conn) do
    case :xmerl_xpath.string(@element_security, conn.body_params.xml, [{:namespace, [{@alias, @namespace}]}]) do
      [security_header] ->
        [{:xmlText, _, _, _, username, :text}] = :xmerl_xpath.string(@element_username, security_header, [{:namespace, [{@alias, @namespace}]}])
        [{:xmlText, _, _, _, password, :text}] = :xmerl_xpath.string(@element_password, security_header, [{:namespace, [{@alias, @namespace}]}])
        conn
        |> assign(:wsusername, String.Chars.to_string(username))
        |> assign(:wspassword, String.Chars.to_string(password))
      [] ->
        conn
        |> halt
        |> send_resp(401, "WSSecurity not found")
    end
  end

  defp authenticate(%Plug.Conn{assigns: %{wsusername: "test", wspassword: "test"}} = conn) do
    conn
  end

  defp authenticate(conn) do
    conn
    |> halt
    |> send_resp(401, "Unauthorized")
  end

  defp remove_wssecurity(%Plug.Conn{body_params: %{xml: xml}}) do

  end

end
