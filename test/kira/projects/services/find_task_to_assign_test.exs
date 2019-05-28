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
      issue = insert(:issue, %{project: project})

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity.id == issue.id
    end

    test "with multiple tasks to be assigned", %{project: project} do
      Enum.each(0..3, fn x ->
        insert(:issue, %{project: project})
      end)

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      project_issues =
        project
        |> Ecto.assoc(:issues)
        |> Repo.all()

      assert Enum.member?(project_issues, context.entity)
    end

    test "with existing tasks with assignees", %{project: project} do
      Enum.each(0..3, fn x ->
        insert(:issue, %{project: project, assignee: build(:user)})
      end)

      {:ok, context} = FindTaskToAssign.run(project_uid: project.uid)

      assert context.entity == nil
    end
  end
end
