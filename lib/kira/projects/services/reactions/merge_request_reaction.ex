defmodule Kira.Projects.Services.Reactions.MergeRequestReaction do
  @moduledoc """
  Leaves a reaction emoji on processed `MergeRequest`s.
  """

  use Exop.Operation

  alias Kira.Projects.Entities.MergeRequest
  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction

  parameter(:entity, struct: MergeRequest)

  def process(%{entity: entity} = params) do
    GitlabReaction.merge_request(entity)
    params
  end
end
