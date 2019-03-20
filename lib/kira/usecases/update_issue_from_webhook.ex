defmodule Kira.Usecases.UpdateIssueFromWebhook do
  @moduledoc """
  We really want to have up-to-date information about new `Issue`s.

  This usecase coveres updates to the `Issue`.
  We are interested in only some parts of modifications.
  So, this action might not actually update anything.
  """

  use Exop.Chain

  operation(Kira.Projects.Commands.UpdateIssue)
end
