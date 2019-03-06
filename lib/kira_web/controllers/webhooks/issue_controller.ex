defmodule KiraWeb.Webhooks.IssueController do
  use KiraWeb, :controller

  alias Kira.Projects.Entities.Issue
  alias KiraWeb.Webhooks.{IssueWebhook, NoteWebhook}

  plug KiraWeb.Plugs.GitlabSecretHeader
  action_fallback KiraWeb.FallbackController

  def create(conn, webhook_data) do
    webhook = select_webhook_type(webhook_data)

    with {:ok, %{entity: %Issue{}}} <- webhook.perform_command(webhook_data) do
      send_resp(conn, 200, "")
    end
  rescue
    _ -> KiraWeb.FallbackController.call(conn, :error)
  end

  defp select_webhook_type(%{"object_kind" => "issue"}), do: IssueWebhook
  defp select_webhook_type(%{"object_kind" => "note"}), do: NoteWebhook
end
