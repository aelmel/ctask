defmodule CraftingTasksWeb.TaskController do
  use CraftingTasksWeb, :controller

  @moduledoc """
  Handle tasks manipulating
  """
  alias CraftingTasks.Sorter

  def sort(conn, params) do
    sorted =
      params
      |> Map.get("tasks", nil)
      |> Sorter.sort()

    json(conn, %{"tasks" => sorted})
  end

  def script(conn, params) do
    cmds =
      params
      |> Map.get("tasks", [])
      |> Sorter.sort()
      |> Enum.map(fn task -> Map.get(task, "command") end)

    script = Enum.join(["#!/usr/bin/env bash"] ++ cmds, "\n")
    text(conn, script)
  end
end
