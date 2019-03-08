defmodule Kira.Projects.Services.Reactions.Providers.GitlabReaction do
  @moduledoc """
  HTTP client to award emojies to all possible kinds of Gitlab content.

  Uses smart retry and timeout policy. Works syncronously.
  For async version use:

    Task.start(fn -> GitlabReaction.issue(some_issue) end)

  This is something this module should not care about.
  """

  use Kira.Common.Gitlab.Client

  @reaction "ok_hand"

  plug Tesla.Middleware.Query, name: @reaction
  plug Tesla.Middleware.Timeout, timeout: 3000
  plug Tesla.Middleware.Retry

  # URL API:

  def issue_reaction_url(issue) do
    "#{issue_path(issue)}/award_emoji"
  end

  def issue_note_reaction_url(issue, note_iid) do
    "#{issue_path(issue)}/notes/#{note_iid}/award_emoji"
  end

  # HTTP API:

  def issue(issue) do
    post!(issue_reaction_url(issue), [])
  end

  def issue_note(issue, note_iid) do
    post!(issue_note_reaction_url(issue, note_iid), [])
  end

  # Private:

  defp issue_path(issue) do
    "/projects/#{issue.project.uid}/issues/#{issue.iid}"
  end
end
