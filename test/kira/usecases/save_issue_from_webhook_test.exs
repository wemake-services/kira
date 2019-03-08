defmodule KiraTest.Usecases.SaveIssueFromWebhookTest do
  use Kira.DataCase

  import Mox
  import KiraTest.Factory

  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction
  alias Kira.Usecases.SaveIssueFromWebhook
  alias KiraTest.Projects.Services.Reactions.Providers.GitlabReaction.Mock

  describe "save issue from webhook usecase" do
    setup :verify_on_exit!

    setup do
      Application.put_env(:tesla, :adapter, Mock)

      {:ok, project: insert(:project)}
    end

    test "valid issue webhook", %{project: project} do
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
          attrs: issue
        )

      assert context.entity.state == "opened"
    end
  end
end
