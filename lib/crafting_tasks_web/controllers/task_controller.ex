defmodule CraftingTasksWeb.TaskController do
  use CraftingTasksWeb, :controller
  @moduledoc """
  Handle tasks manipulating
  """
  alias CraftingTasks.Sorter

  def sort(conn, params) do
    tasks = Map.get(params, "tasks")
    Sorter.sort(tasks)

    json(conn, %{})
  end


end
