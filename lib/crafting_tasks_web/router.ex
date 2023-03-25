defmodule CraftingTasksWeb.Router do
  use CraftingTasksWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/tasks", CraftingTasksWeb do
    pipe_through :api

    post "/sort", TaskController, :sort
    post "/script", TaskController, :script
  end
end
