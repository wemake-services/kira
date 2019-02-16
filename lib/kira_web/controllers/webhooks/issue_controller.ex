defmodule KiraWeb.Webhooks.IssueController do
  use KiraWeb, :controller

  alias Kira.Projects.Entities.Issue

  alias KiraWeb.Webhooks.IssueController.Requests

  # plug PlugRequireHeader, headers: [auth_token: "X-Gitlab-Token"]
  action_fallback KiraWeb.FallbackController

  def create(conn, webhook_data) do
    with {:ok, %{entity: %Issue{}}} <- Requests.perform_command(webhook_data) do
      send_resp(conn, 200, "")
    end
  end
end

defmodule KiraWeb.Webhooks.IssueController.Requests do
  alias Kira.Projects.Usecases

  def perform_command(webhook_data) do
    %{
      "object_attributes" => %{
        "action" => action
      }
    } = webhook_data

    action
    |> select_command
    |> apply(:run, [structure_payload(webhook_data)])
  end

  defp select_command("open"), do: Usecases.SaveIssueFromWebhook
  defp select_command("closed"), do: Commands.CreateIssue

  defp structure_payload(webhook_data) do
    %{
      "object_kind" => "issue",
      "project" => %{"id" => project_uid},
      "object_attributes" => %{
        "id" => issue_uid,
        "iid" => issue_iid
      }
    } = webhook_data

    [
      project_uid: project_uid,
      attrs: %{"uid" => issue_uid, "iid" => issue_iid}
    ]
  end
end
