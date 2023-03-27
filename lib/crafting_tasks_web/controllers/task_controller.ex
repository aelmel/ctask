defmodule CraftingTasksWeb.TaskController do
  use CraftingTasksWeb, :controller

  @moduledoc """
  Handle tasks manipulating
  """
  alias CraftingTasks.Sorter

  def action(conn, _) do
    args = [conn, conn.params]

    case Map.get(conn.params, "tasks") do
      nil -> conn |> put_status(:bad_request) |> json(%{"error" => "no task key"}) |> halt()
      [] -> apply(__MODULE__, action_name(conn), args)
      [_ | _] -> apply(__MODULE__, action_name(conn), args)
      _ -> conn |> put_status(:bad_request) |> json(%{"error" => "expected list"}) |> halt()
    end
  end

  def sort(conn, params) do
    try do
      sorted =
        params
        |> Map.get("tasks", nil)
        |> Sorter.sort()

      json(conn, %{"tasks" => sorted})
    rescue
      e ->
        conn
        |> put_status(:bad_request)
        |> json(%{"error" => e.message})
    end
  end

  def script(conn, params) do
    try do
      cmds =
        params
        |> Map.get("tasks", [])
        |> Sorter.sort()
        |> Enum.map(fn task -> Map.get(task, "command") end)

      script = Enum.join(["#!/usr/bin/env bash"] ++ cmds, "\n")
      text(conn, script)
    rescue
      e ->
        conn
        |> put_status(:bad_request)
        |> json(%{"error" => e.message})
    end
  end
end
