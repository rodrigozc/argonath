defmodule Argonath.PageControllerTest do
  use Argonath.ConnCase

  test "GET /argonath/ui", %{conn: conn} do
    conn = get conn, "/argonath/ui"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
