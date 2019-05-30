defmodule KiraWeb.Webhooks.MergeRequestWebhook do
  @moduledoc """
  Parses and processes `MergeRequest` webhooks.
  """

  alias Kira.Common.TimeUtils
  alias Kira.Usecases

  # TODO: behaviour
  def perform_command(webhook_data) do
    %{
      "object_attributes" => %{
        "action" => action
      }
    } = webhook_data

    action
    |> select_command()
    |> apply(:run, [structure_payload(webhook_data)])
  end

  # TODO: remove from queue on closed
  # TODO: add support of other possible actions, which are close, merge, reopen
  defp select_command("open"), do: Usecases.SaveMergeRequestFromWebhook
  defp select_command("update"), do: Usecases.UpdateMergeRequestFromWebhook

  defp structure_payload(webhook_data) do
    %{
      "object_kind" => "merge_request",
      "project" => %{"id" => project_uid},
      "object_attributes" => %{
        "id" => mr_uid,
        "iid" => mr_iid,
        "assignee_id" => mr_assignee_uid,
        "author_id" => mr_author_uid,
        # "head_pipeline_id": mr_pipeline_uid,

        "state" => mr_state,
        "merge_status" => mr_merge_status,
        "source_branch" => mr_source_branch,
        "work_in_progress" => mr_work_in_progress,
        "created_at" => mr_origin_timestamp
      }
    } = webhook_data

    [
      project_uid: project_uid,
      assignee_uid: mr_assignee_uid,
      author_uid: mr_author_uid,
      attrs: %{
        "uid" => mr_uid,
        "iid" => mr_iid,
        "state" => mr_state,
        "merge_status" => mr_merge_status,
        "source_branch" => mr_source_branch,
        "work_in_progress" => mr_work_in_progress,
        "origin_timestamp" =>
          TimeUtils.from_gitlab_timeformat!(mr_origin_timestamp)
      }
    ]
  end
end
