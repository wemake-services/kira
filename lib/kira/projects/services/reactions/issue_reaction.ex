defmodule Kira.Projects.Services.Reactions.IssueReaction do
  @moduledoc """
  Leaves a reaction emoji on processed issues.
  """

  use Exop.Operation

  alias Kira.Projects.Entities.Issue
  alias Kira.Projects.Services.Reactions.Providers.GitlabReaction

  parameter(:entity, struct: Issue)

  def process(%{entity: entity} = params) do
    GitlabReaction.issue(entity)
    params
  end
end
