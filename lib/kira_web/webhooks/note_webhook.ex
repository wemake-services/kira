defmodule KiraWeb.Webhooks.NoteWebhook do
  @moduledoc """
  Parses and processes note webhooks.
  """

  alias Kira.Usecases

  def perform_command(webhook_data) do
    %{
      "object_attributes" => %{
        "noteable_type" => noteable_type
      }
    } = webhook_data

    noteable_type
    |> select_command()
    |> apply(:run, [structure_payload(webhook_data)])
  end

  # TODO: change usecase to just try to find commands
  defp select_command("Issue"), do: Usecases.QueueIssueFromNote

  defp structure_payload(webhook_data) do
    # TODO: match on different `noteable_type`s
    %{
      "object_kind" => "note",
      "project_id" => project_uid,
      "object_attributes" => %{
        "noteable_type" => "Issue",
        "id" => note_iid,
        "note" => note_text,
        "noteable_id" => issue_uid
      }
    } = webhook_data

    [
      project_uid: project_uid,
      issue_uid: issue_uid,
      note_text: note_text,
      note_iid: note_iid
    ]
  end
end
