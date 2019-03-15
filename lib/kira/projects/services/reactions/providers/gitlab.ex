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

  def merge_request_reaction_url(merge_request) do
    "#{merge_request_path(merge_request)}/award_emoji"
  end

  # HTTP API:

  def issue(issue) do
    post!(issue_reaction_url(issue), [])
  end

  def issue_note(issue, note_iid) do
    post!(issue_note_reaction_url(issue, note_iid), [])
  end

  def merge_request(merge_request) do
    post!(merge_request_reaction_url(merge_request), [])
  end

  # Private:

  defp project_path(project) do
    "/projects/#{project.uid}"
  end

  defp issue_path(issue) do
    "#{project_path(issue.project)}/issues/#{issue.iid}"
  end

  defp merge_request_path(merge_request) do
    "#{project_path(merge_request.project)}/merge_requests/#{merge_request.iid}"
  end
end
