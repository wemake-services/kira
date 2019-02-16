defmodule Kira.Projects.Usecases.SaveIssueFromWebhook do
  use Exop.Chain

  operation(Kira.Projects.Commands.CreateIssue)
  operation(Kira.Projects.Services.Reaction)
end
