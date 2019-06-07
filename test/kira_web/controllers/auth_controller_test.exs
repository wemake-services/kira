defmodule KiraWeb.AuthControllerTest do
  use KiraWeb.ConnCase

  import KiraTest.Factory
  alias Kira.{Repo, Accounts.Entities.User}

  @ueberauth_auth %{
    credentials: %{token: "johnsnowdoknownothing"},
    info: %{
      email: "john.snow@knewnothing.com",
      nickname: "john.snow",
      name: "John Show"
    },
    provider: :github,
    uid: 259_250
  }

  test "redirects user to github for authentication", %{conn: conn} do
    conn = get(conn, "/auth/github?scope=user")
    assert redirected_to(conn, 302)
  end

  test "creates user from github info", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/github/callback")

    users =
      User
      |> Repo.all()

    assert Enum.count(users) == 1

    assert json_response(conn, 200) == %{
             "user" => %{
               "access_level" => nil,
               "email" => "john.snow@knewnothing.com",
               "expires_at" => nil,
               "state" => "active",
               "uid" => 259_250,
               "username" => "john.snow"
             }
           }
  end

  test "find and return user from github email", %{conn: conn} do
    user =
      insert(:user, %{
        email: "john.snow@knewnothing.com",
        expires_at: nil,
        access_level: nil
      })

    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/github/callback")

    users =
      User
      |> Repo.all()

    assert Enum.count(users) == 1

    assert json_response(conn, 200) == %{
             "user" => %{
               "access_level" => nil,
               "email" => "john.snow@knewnothing.com",
               "expires_at" => nil,
               "state" => "active",
               "uid" => 259_250,
               "username" => "john.snow"
             }
           }
  end
end
