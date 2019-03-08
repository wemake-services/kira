defmodule KiraTest.Usecases.RenewProjectUsersTest do
  use Kira.DataCase

  import Mox
  import KiraTest.Factory
  import Tesla.Mock, only: [json: 1]

  alias Kira.Accounts.Entities.User
  alias Kira.Accounts.Services.Providers.GitlabUsers
  alias Kira.Usecases.RenewProjectUsers
  alias KiraTest.Accounts.Services.Providers.GitlabUsers.Mock

  setup :verify_on_exit!

  setup do
    Application.put_env(:tesla, :adapter, Mock)

    :ok
  end

  describe "renew project users usecase, no existing users" do
    setup do
      {:ok, project: insert(:project)}
    end

    test "initial fetch", %{project: project} do
      project_url =
        GitlabUsers.api_url() <> GitlabUsers.in_project_url(project)

      user1 = string_params_for(:user) |> rename_id()
      user2 = string_params_for(:user) |> rename_id()

      Mock
      |> expect(:call, fn
        %{method: :get, url: ^project_url}, _opts ->
          {:ok, json([user1, user2])}
      end)

      {:ok, context} = RenewProjectUsers.run([])

      assert length(context) == 1

      [%User{uid: uid1}, %User{uid: uid2}] = hd(context).participants
      assert uid1 == user1["id"]
      assert uid2 == user2["id"]
    end
  end

  describe "renew project users usecase, existing users in project" do
    setup do
      {:ok, project: build(:project) |> project_with_users() |> insert()}
    end

    test "completely replace users", %{project: project} do
      project_url =
        GitlabUsers.api_url() <> GitlabUsers.in_project_url(project)

      user1 = string_params_for(:user) |> rename_id()

      Mock
      |> expect(:call, fn
        %{method: :get, url: ^project_url}, _opts ->
          {:ok, json([user1])}
      end)

      {:ok, context} = RenewProjectUsers.run([])

      assert length(context) == 1

      [%User{uid: uid1}] = hd(context).participants
      assert uid1 == user1["id"]
    end

    test "partially replace users", %{project: project} do
      project_url =
        GitlabUsers.api_url() <> GitlabUsers.in_project_url(project)

      new_user = string_params_for(:user) |> rename_id()

      existing_user =
        project.participants
        |> Enum.at(0)
        |> Jason.encode!()
        |> Jason.decode!()
        |> rename_id()

      Mock
      |> expect(:call, fn
        %{method: :get, url: ^project_url}, _opts ->
          {:ok, json([existing_user, new_user])}
      end)

      {:ok, context} = RenewProjectUsers.run([])

      assert length(context) == 1

      [%User{uid: uid1}, %User{uid: uid2}] = hd(context).participants

      assert uid1 == Enum.at(project.participants, 0).uid
      assert uid2 == new_user["id"]
    end

    test "append users", %{project: project} do
      project_url =
        GitlabUsers.api_url() <> GitlabUsers.in_project_url(project)

      new_user = string_params_for(:user) |> rename_id()

      users =
        project.participants
        |> Jason.encode!()
        |> Jason.decode!()
        |> Enum.map(&rename_id/1)

      Mock
      |> expect(:call, fn
        %{method: :get, url: ^project_url}, _opts ->
          # credo:disable-for-next-line Credo.Check.Refactor.AppendSingleItem
          {:ok, json(users ++ [new_user])}
      end)

      {:ok, context} = RenewProjectUsers.run([])

      assert length(context) == 1

      [%User{uid: uid1}, %User{uid: uid2}, %User{uid: uid3}] =
        hd(context).participants

      assert uid1 == Enum.at(project.participants, 0).uid
      assert uid2 == Enum.at(project.participants, 1).uid
      assert uid3 == new_user["id"]
    end
  end

  defp rename_id(%{"uid" => uid} = item), do: Map.put(item, "id", uid)
  defp rename_id(%{uid: uid} = item), do: Map.put(item, :id, uid)
end
