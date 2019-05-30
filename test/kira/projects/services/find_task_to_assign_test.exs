defmodule KiraTest.Projects.Services.FindTaskToAssignTest do
  use Kira.DataCase

  import KiraTest.Factory
  alias Kira.Projects.Services.FindTaskToAssign

  describe "find task to assign service" do
    setup do
      {:ok, project: insert(:project)}
    end

    test "with no task to be assigned", %{project: project} do
      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity == nil
    end

    test "with only one task to be assigned", %{project: project} do
      issue = insert(:issue, %{project: project, state: "queued"})

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity.id == issue.id
    end

    test "with multiple tasks to be assigned", %{project: project} do
      insert_list(3, :issue, %{project: project, state: "queued"})

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      project_issues =
        project
        |> Ecto.assoc(:issues)
        |> Repo.all()

      assert Enum.member?(project_issues, context.entity)
    end

    test "with differently weighed multiple tasks", %{project: project} do
      low_priority_issue = insert(:issue, %{project: project, state: "queued"})

      middle_priority_issue =
        insert(:issue, %{project: project, state: "queued", weight: 1})

      high_priority_issue =
        insert(:issue, %{project: project, state: "queued", weight: 9000})

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity.id == high_priority_issue.id
    end

    test "with existing tasks with assignees", %{project: project} do
      insert_list(3, :issue, %{
        project: project,
        state: "queued",
        assignee: insert(:user)
      })

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity == nil
    end

    test "with existing opened tasks", %{project: project} do
      insert_list(3, :issue, %{project: project})

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity == nil
    end

    test "with existing closed tasks", %{project: project} do
      insert_list(3, :issue, %{project: project, state: "closed"})

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity == nil
    end
  end
end
