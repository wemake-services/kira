defmodule Kira.Usecases.SaveMergeRequestFromWebhook do
  @moduledoc """
  We really want to have up-to-date information about new `MergeRequest`s.
  """

  use Exop.Chain

  operation(Kira.Projects.Commands.CreateMergeRequest)
  operation(Kira.Projects.Services.Reactions.MergeRequestReaction)
end
