defmodule Kira.Projects.Queries.ProjectQueries do
  @moduledoc """
  Reading queries that do not modify state of `Project`s.
  """

  import Ecto.Query, warn: false
  alias Kira.Repo

  alias Kira.Projects.Entities.Project

  def get_project!(uid) do
    Project
    |> Repo.get_by!(uid: uid)
  end
end
