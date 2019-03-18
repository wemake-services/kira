defmodule KiraWeb.Webhooks.GitlabController do
  use KiraWeb, :controller
  require Logger

  alias KiraWeb.Webhooks.{
    IssueWebhook,
    MergeRequestWebhook,
    NoteWebhook,
    PipelineWebhook
  }

  plug KiraWeb.Plugs.GitlabSecretHeader
  action_fallback KiraWeb.FallbackController

  def create(conn, webhook_data) do
    webhook = select_webhook_type(webhook_data)

    with {:ok, %{entity: _entity}} <- webhook.perform_command(webhook_data) do
      send_resp(conn, 200, "")
    end
  rescue
    # TODO: error handling should be improved, add Sentry
    err ->
      Logger.error(Exception.format(:error, err, __STACKTRACE__))
      KiraWeb.FallbackController.call(conn, :error)
  end

  defp select_webhook_type(%{"object_kind" => "issue"}), do: IssueWebhook
  defp select_webhook_type(%{"object_kind" => "note"}), do: NoteWebhook
  defp select_webhook_type(%{"object_kind" => "pipeline"}), do: PipelineWebhook

  defp select_webhook_type(%{"object_kind" => "merge_request"}),
    do: MergeRequestWebhook
end
