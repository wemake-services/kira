defmodule Kira.Usecases.CloseIssueFromWebhook do
  @moduledoc """
  We really want to have up-to-date information about new `Issue`s.

  This usecase coveres closed issues.
  User on Gitlab closes an original issue, we recieve a webhook,
  and mark the existing issue as closed. So it won't be processed.
  """

  use Exop.Chain

  operation(Kira.Projects.Commands.CloseIssue)
end
