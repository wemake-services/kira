defmodule KiraTest.Usecases.SaveMergeRequestFromWebhookTest do
  use Kira.DataCase
  use KiraTest.TeslaMock

  import KiraTest.Factory

  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction
  alias Kira.Usecases.SaveMergeRequestFromWebhook
  alias KiraTest.Projects.Services.Reactions.Providers.GitlabReaction.Mock

  mock(Mock)

  describe "save merge request from webhook usecase" do
    setup do
      {:ok, project: insert(:project), user: insert(:user)}
    end

    test "valid merge_request webhook without assignee", %{
      project: project,
      user: user
    } do
      context = execute_command(project, user)

      assert_context(context, user, project)
      assert context.entity.assignee_id == nil
    end

    test "valid merge_request webhook with assignee", %{
      project: project,
      user: user
    } do
      context = execute_command(project, user, user.uid)

      assert_context(context, user, project)
      assert context.entity.assignee_id == user.id
    end

    defp execute_command(project, user, assignee_uid \\ nil) do
      merge_request = string_params_for(:merge_request)
      merge_request_iid = merge_request["iid"]

      base_url = GitlabReaction.api_url()

      merge_request_url =
        "#{base_url}/projects/#{project.uid}/merge_requests" <>
          "/#{merge_request_iid}/award_emoji"

      Mock
      |> expect(:call, fn
        %{method: :post, url: ^merge_request_url}, _opts ->
          {:ok, %Tesla.Env{status: 200}}
      end)

      {:ok, context} =
        SaveMergeRequestFromWebhook.run(
          project_uid: project.uid,
          author_uid: user.uid,
          assignee_uid: assignee_uid,
          attrs: merge_request
        )

      context
    end

    defp assert_context(context, project, user) do
      assert context.entity.id > 0
      assert context.entity.project_id == project.id
      assert context.entity.author_id == user.id
      assert context.entity.state == "opened"
    end
  end
end
