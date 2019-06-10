defmodule KiraWeb.AuthControllerTest do
  use KiraWeb.ConnCase

  import KiraTest.Factory

  alias Kira.{Accounts.Entities.User, Repo}

  @ueberauth_auth %{
    credentials: %{token: "johnsnowdoknownothing"},
    extra: %{
      raw_info: %{
        user: %{
          "email" => "john.snow@knewnothing.com",
          "username" => "john.snow",
          "name" => "John Show",
          "id" => 21,
          "state" => "active"
        }
      }
    }
  }

  test "redirects user to gitlab for authentication", %{conn: conn} do
    conn = get(conn, "/auth/gitlab?scope=user")
    assert redirected_to(conn, 302)
  end

  test "creates user from gitlab info", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/gitlab/callback")

    users =
      User
      |> Repo.all()

    assert Enum.count(users) == 1

    assert json_response(conn, 200) == %{
             "user" => %{
               "access_level" => nil,
               "expires_at" => nil,
               "email" => "john.snow@knewnothing.com",
               "state" => "active",
               "uid" => 21,
               "username" => "john.snow"
             }
           }
  end

  test "find and return user from gitlab email", %{conn: conn} do
    insert(:user, %{
      email: "john.snow@knewnothing.com",
      expires_at: nil,
      access_level: nil
    })

    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/gitlab/callback")

    users =
      User
      |> Repo.all()

    assert Enum.count(users) == 1

    assert json_response(conn, 200) == %{
             "user" => %{
               "access_level" => nil,
               "expires_at" => nil,
               "email" => "john.snow@knewnothing.com",
               "state" => "active",
               "uid" => 21,
               "username" => "john.snow"
             }
           }
  end
end
