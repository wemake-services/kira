defmodule KiraTest.Accounts.Queries.FindFreeDeveloperTest do
  use Kira.DataCase

  import KiraTest.Factory
  alias Kira.Accounts.Queries.FindFreeDeveloper

  describe "find task to assign service" do
    setup do
      {:ok, project: insert(:project)}
    end

    test "with no users on project", %{project: project} do
      insert_list(2, :user)
      {:ok, context} = FindFreeDeveloper.run(project_uid: project.uid)

      assert context.users == []
    end

    test "with a user and without issues", %{project: project} do
      expected_user_id = insert_free_developer(project)

      {:ok, context} = FindFreeDeveloper.run(project_uid: project.uid)

      actual_user_ids = context.users |> Enum.map(fn u -> u.id end)

      assert actual_user_ids == [expected_user_id]
    end

    test "with a user and unassigned issues", %{project: project} do
      expected_user_id = insert_free_developer(project)
      insert_list(3, :issue, %{project: project, assignee: nil})

      {:ok, context} = FindFreeDeveloper.run(project_uid: project.uid)

      actual_user_ids = context.users |> Enum.map(fn u -> u.id end)

      assert actual_user_ids == [expected_user_id]
    end

    test "with multiple users and unassigned issues", %{project: project} do
      expected_user_ids = insert_free_developers(3, project)
      insert_list(3, :issue, %{project: project, assignee: nil})

      {:ok, context} = FindFreeDeveloper.run(project_uid: project.uid)

      actual_user_ids =
        context.users |> Enum.map(fn u -> u.id end) |> Enum.sort()

      assert actual_user_ids == expected_user_ids
    end

    test "with a busy user", %{project: project} do
      insert_busy_developer(project)

      {:ok, context} = FindFreeDeveloper.run(project_uid: project.uid)

      assert context.users == []
    end

    test "with multiple busy users", %{project: project} do
      insert_busy_developers(2, project)

      {:ok, context} = FindFreeDeveloper.run(project_uid: project.uid)

      assert context.users == []
    end

    test "with both busy and free users, with unassigned tasks", %{
      project: project
    } do
      expected_user_ids = insert_free_developers(2, project)
      insert_busy_developers(2, project)
      insert_list(3, :issue, %{project: project, assignee: nil})

      {:ok, context} = FindFreeDeveloper.run(project_uid: project.uid)

      actual_user_ids =
        context.users |> Enum.map(fn u -> u.id end) |> Enum.sort()

      assert actual_user_ids == expected_user_ids
    end

    defp insert_free_developer(project) do
      insert(:user, projects: [project]).id
    end

    defp insert_free_developers(count, project) do
      1..count
      |> Enum.map(fn _ -> insert_free_developer(project) end)
    end

    defp insert_busy_developer(project) do
      user = insert(:user, projects: [project])
      insert(:issue, project: project, assignee: user)
      user.id
    end

    defp insert_busy_developers(count, project) do
      1..count
      |> Enum.map(fn _ -> insert_busy_developer(project) end)
    end
  end
end
