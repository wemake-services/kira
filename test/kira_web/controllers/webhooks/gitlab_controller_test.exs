defmodule KiraWebTest.Webhooks.GitlabControllerTest do
  use KiraWeb.ConnCase

  import Tesla.Mock

  @invalid_attrs %{"uid" => nil}

  setup %{conn: conn} do
    # Just disable all HTTP calls:
    mock_global(fn _ -> %Tesla.Env{status: 200} end)

    token = Application.get_env(:kira, :gitlab)[:secret_header_value]
    conn = put_req_header(conn, "x-gitlab-token", token)

    {:ok, conn: conn}
  end

  describe "bad webhooks" do
    test "unauthed request is handled", %{conn: conn} do
      conn =
        post(
          delete_req_header(conn, "x-gitlab-token"),
          Routes.gitlab_path(conn, :create),
          @invalid_attrs
        )

      assert response(conn, 403)
    end

    @tag capture_log: true
    test "invalid data is handled", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
          @invalid_attrs
        )

      assert response(conn, 400)
    end
  end
end
