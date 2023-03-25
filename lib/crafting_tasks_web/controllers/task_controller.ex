defmodule CraftingTasksWeb.TaskController do
  use CraftingTasksWeb, :controller

  @moduledoc """
  Handle tasks manipulating
  """
  alias CraftingTasks.Sorter

  def sort(conn, params) do
    sorted =
      params
      |> Map.get( "tasks", [])
      |> Sorter.sort()

    json(conn, %{"tasks" => sorted})
  end
end
