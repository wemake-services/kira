defmodule KiraTest.Usecases.QueueIssueFromNoteTest do
  use Kira.DataCase
  use KiraTest.TeslaMock

  import KiraTest.Factory

  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction
  alias Kira.Usecases.QueueIssueFromNote
  alias KiraTest.Projects.Services.Reactions.Providers.GitlabReaction.Mock

  mock(Mock)

  describe "queue issue usecase" do
    setup do
      {:ok, issue: insert(:issue), note_iid: 123}
    end

    test "valid queue command", %{issue: issue, note_iid: note_iid} do
      issue_note_url =
        GitlabReaction.api_url() <>
          GitlabReaction.issue_note_reaction_url(issue, note_iid)

      Mock
      |> expect(:call, fn
        %{method: :post, url: ^issue_note_url}, _opts ->
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
