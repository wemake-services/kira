defmodule KiraTest.Projects.Commands.UpdateIssueTest do
  use Kira.DataCase

  import KiraTest.Factory
  alias Kira.Projects.Commands.UpdateIssue

  describe "update issue command" do
    setup do
      {:ok, issue: insert(:issue)}
    end

    test "update issue for partial valid attrs", %{issue: issue} do
      {:ok, context} = UpdateIssue.run(
        assignee_uid: nil,
        attrs: %{"uid" => issue.uid, "weight" => 0}
      )

      assert context.entity.assignee_id == nil
      assert context.entity.weight == 0
      assert context.entity.state == "opened"
    end

    test "update issue's assignee", %{issue: issue} do
      assignee = insert(:user)
      {:ok, context} = UpdateIssue.run(
        assignee_uid: assignee.uid,
        attrs: %{"uid" => issue.uid}
      )

      assert context.entity.assignee_id == assignee.id
      assert context.entity.state == "opened"
    end
  end
end
