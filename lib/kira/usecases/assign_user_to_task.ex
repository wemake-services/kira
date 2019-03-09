defmodule Kira.Usecases.AssignUserToTask do
  @moduledoc """
  We need to assign free `User`s to the most important tasks.

  We mean `Issue` and `Code Review` by "tasks".
  Different tasks have different priorities.

  Is used as a cron job most of the times.
  """

  use Exop.Chain

  operation(Kira.Accounts.Services.AssignUserToTask)
  # => operation(Kira.Projects.Services.FindTaskToAssign)
  # => operation(Kira.Accounts.Queries.FindFreeDeveloper)
  # => operation(Kira.Accounts.Commands.AssignDeveloper)
  # operation(Kira.Accounts.Services.Notifications.NotifyAssignee)
end
