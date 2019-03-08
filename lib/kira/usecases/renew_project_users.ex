defmodule Kira.Usecases.RenewProjectUsers do
  @moduledoc """
  We need to fetch all current `User`s who have an access for each `Project`.

  We later use these users to assign tasks and track activity.

  Is used as a cron job most of the times.
  """

  use Exop.Chain

  operation(Kira.Accounts.Services.RenewProjectUsers)
end
