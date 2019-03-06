defmodule KiraTest.Usecases.QueueIssueFromNoteTest do
  use Kira.DataCase

  import Mox
  import KiraTest.Factory

  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction
  alias Kira.Usecases.QueueIssueFromNote
  alias KiraTest.Projects.Services.Reactions.Providers.GitlabReaction.Mock

  describe "queue issue usecase" do
    setup :verify_on_exit!

    setup do
      Application.put_env(:tesla, :adapter, Mock)

      {:ok, issue: insert(:issue), note_iid: 123}
    end

    test "valid queue command", %{issue: issue, note_iid: note_iid} do
      issue_note_url = GitlabReaction.issue_note_reaction_url(issue, note_iid)

      Mock
      |> expect(:call, fn
        %{method: :post, url: "https://gitlab.com/api/v4" <> ^issue_note_url},
        _opts ->
          {:ok, %Tesla.Env{status: 200}}
      end)

      {:ok, context} =
        QueueIssueFromNote.run(
          project_uid: issue.project.uid,
          issue_uid: issue.uid,
          note_text: "@kira-bot queue",
          note_iid: note_iid
        )

      assert context.entity.state == "queued"
    end

    test "invalid queue command", %{issue: issue, note_iid: note_iid} do
      result =
        QueueIssueFromNote.run(
          project_uid: issue.project.uid,
          issue_uid: issue.uid,
          note_text: "Some random text",
          note_iid: note_iid
        )

      assert result == {:interrupt, :idempotence}
    end
  end
end
