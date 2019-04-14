defmodule KiraTest.Usecases.SaveIssueFromWebhookTest do
  use Kira.DataCase
  use KiraTest.TeslaMock

  import KiraTest.Factory

  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction
  alias Kira.Usecases.SaveIssueFromWebhook
  alias KiraTest.Projects.Services.Reactions.Providers.GitlabReaction.Mock

  mock(Mock)

  describe "save issue from webhook usecase" do
    setup do
      {:ok, project: insert(:project), user: insert(:user)}
    end

    test "valid issue webhook with assignee", %{
      project: project,
      user: user
    } do
      context = execute_command(project, user, user.uid)

      assert context.entity.id > 0
      assert context.entity.project_id == project.id
      assert context.entity.author_id == user.id
      assert context.entity.assignee_id == user.id
      assert context.entity.state == "opened"
    end

    test "valid issue webhook without assignee", %{
      project: project,
      user: user
    } do
      context = execute_command(project, user)

      assert context.entity.id > 0
      assert context.entity.project_id == project.id
      assert context.entity.author_id == user.id
      assert context.entity.assignee_id == nil
      assert context.entity.state == "opened"
    end

    defp execute_command(project, user, assignee_uid \\ nil) do
      issue = string_params_for(:issue)
      issue_iid = issue["iid"]

      base_url = GitlabReaction.api_url()

      issue_url =
        "#{base_url}/projects/#{project.uid}/issues/#{issue_iid}/award_emoji"

      Mock
      |> expect(:call, fn
        %{method: :post, url: ^issue_url}, _opts ->
          {:ok, %Tesla.Env{status: 200}}
      end)

      {:ok, context} =
        SaveIssueFromWebhook.run(
          project_uid: project.uid,
          author_uid: user.uid,
          assignee_uid: assignee_uid,
          attrs: issue
        )

      context
    end
  end
end
