defmodule Kira.Projects.Queries.IssueQueries do
  @moduledoc """
  The Issues context.
  """

  import Ecto.Query, warn: false
  alias Kira.Repo

  alias Kira.Projects.Entities.{Project, Issue}
end
