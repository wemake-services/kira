defmodule Kira.Usecases.SaveIssueFromWebhook do
  @moduledoc """
  We really want to have up-to-date information about new issues.
  """

  use Exop.Chain

  operation(Kira.Projects.Commands.CreateIssue)
  operation(Kira.Projects.Services.Reactions.IssueReaction)
end
