defmodule KiraTest.Projects.Commands.CreateIssueTest do
  use Kira.DataCase

  import KiraTest.Factory
  alias Kira.Projects.Commands.CreateIssue

  describe "create issue command" do
    setup do
      {:ok, project: insert(:project), user: insert(:user)}
    end

    @invalid_attrs %{"missing" => "key"}
    @valid_attrs %{"uid" => 1, "iid" => 1, "state" => "opened"}
    @valid_full_attrs %{
      "uid" => 1,
      "iid" => 1,
      "state" => "opened",
      "due_date" => "2019-02-17",
      "weight" => 1
    }

    test "creates issue for valid attrs", %{project: project, user: user} do
      {:ok, context} =
        CreateIssue.run(
          attrs: @valid_attrs,
          project_uid: project.uid,
          author_uid: user.uid,
          assignee_uid: nil
        )

      assert context.entity.id > 0
      assert context.entity.project_id == project.id
      assert context.entity.author_id == user.id
      assert context.entity.assignee_id == nil
    end

    test "creates issue for full valid attrs", %{
      project: project,
      user: user
    } do
      {:ok, context} =
        CreateIssue.run(
          attrs: @valid_full_attrs,
          project_uid: project.uid,
          author_uid: user.uid,
          assignee_uid: user.uid
        )

      assert context.entity.id > 0
      assert context.entity.project_id == project.id
      assert context.entity.author_id == user.id
      assert context.entity.assignee_id == user.id
    end

    test "does not create issue for invalid attrs", %{
      project: project,
      user: user
    } do
      assert_raise Ecto.InvalidChangesetError, fn ->
        CreateIssue.run(
          attrs: @invalid_attrs,
          project_uid: project.uid,
          author_uid: user.uid,
          assignee_uid: nil
        )
      end
    end
  end
end
