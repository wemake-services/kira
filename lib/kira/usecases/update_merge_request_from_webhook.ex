defmodule Kira.Usecases.UpdateMergeRequestFromWebhook do
  @moduledoc """
  We really want to have up-to-date information about a `MergeRequest`s.
  """

  use Exop.Chain

  operation(Kira.Projects.Commands.UpdateMergeRequest)
end
