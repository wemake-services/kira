defmodule KiraTest.Projects.Commands.QueueIssueTest do
  use Kira.DataCase

  import KiraTest.Factory
  alias Kira.Projects.Commands.QueueIssue

  describe "queue issue command" do
    setup do
      {:ok, issue: insert(:issue)}
    end

    test "queues issue for valid attrs", %{issue: issue} do
      {:ok, context} = QueueIssue.run(issue_uid: issue.uid)

      assert context.entity.state == "queued"
    end

    test "queues issue twice" do
      issue = insert(:issue, %{state: "queued"})
      {:ok, context} = QueueIssue.run(issue_uid: issue.uid)

      assert context.entity.state == "queued"
    end
  end
end
