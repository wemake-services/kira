defmodule KiraWeb.Webhooks.PipelineWebhook do
  @moduledoc """
  Parses and processes `Pipeline` webhooks.
  """

  alias Kira.Common.TimeUtils
  alias Kira.Usecases

  def perform_command(webhook_data) do
    webhook_data
    |> select_command()
    |> apply(:run, [structure_payload(webhook_data)])
  end

  defp select_command(_), do: Usecases.SavePipelineFromWebhook

  defp structure_payload(webhook_data) do
    %{
      "object_kind" => "pipeline",
      "project" => %{"id" => project_uid},
      "user" => %{
        "username" => author_username
      },
      "object_attributes" => %{
        "id" => pipeline_uid,
        "ref" => pipeline_ref,
        "tag" => pipeline_tag,
        "sha" => pipeline_sha,
        "status" => pipeline_status,
        "detailed_status" => pipeline_detailed_status,
        "created_at" => pipeline_origin_timestamp,
        "finished_at" => pipeline_finish_timestamp
      }
    } = webhook_data

    [
      project_uid: project_uid,
      author_username: author_username,
      attrs: %{
        "uid" => pipeline_uid,
        "ref" => pipeline_ref,
        "tag" => pipeline_tag,
        "sha" => pipeline_sha,
        "status" => pipeline_status,
        "detailed_status" => pipeline_detailed_status,
        "origin_timestamp" => pipeline_origin_timestamp,
        "finish_timestamp" => pipeline_finish_timestamp
      }
    ]
  end
end
