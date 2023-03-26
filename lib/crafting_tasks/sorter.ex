defmodule CraftingTasks.Sorter do
  @moduledoc """
  Sorting algorithm
  """
  @spec sort(list()) :: list()
  def sort(tasks) do
    mapped_task =
      tasks
      |> Enum.map(fn task ->
        {task["name"], task}
      end)
      |> Enum.into(%{})

    deps = tasks |> Enum.map(fn task -> {task["name"], task["requires"] || []} end) |> Map.new()

    []
    |> sort_tasks(deps)
    |> Enum.map(fn task_name ->
      Map.get(mapped_task, task_name)
    end)
  end

  defp sort_tasks(result, deps) do
    len = deps |> Map.keys() |> length
    next = deps |> Map.keys() |> Enum.find(&Enum.empty?(deps[&1]))

    case {len, next} do
      {0, _} ->
        result

      {_, nil} ->
        raise "cannot find non dependent task"

      {_, task} ->
        new_result = result ++ [task]

        new_deps =
          deps
          |> Map.drop([task])
          |> Enum.map(fn {k, v} ->
            {k, Enum.filter(v, fn x -> !String.equivalent?(x, task) end)}
          end)
          |> Enum.into(%{})

        sort_tasks(new_result, new_deps)
    end
  end
end
