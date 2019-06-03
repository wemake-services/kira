defmodule Kira.Usecases.CloseMergeRequestFromWebhook do
  @moduledoc """
  Up-to-date information about closed `MergeRequest`s.
  """

  use Exop.Chain

  operation(Kira.Projects.Commands.CloseMergeRequest)
end
