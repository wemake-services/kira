defmodule Kira.Projects.Services.Reactions.IssueNoteReaction do
  @moduledoc """
  Leaves a reaction emoji on processed `Issue` notes.
  """

  use Exop.Operation

  alias Kira.Projects.Entities.Issue
  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction

  parameter(:entity, struct: Issue)
  parameter(:note_iid, type: :integer)

  def process(%{entity: entity, note_iid: note_iid} = params) do
    GitlabReaction.issue_note(entity, note_iid)
    params
  end
end
