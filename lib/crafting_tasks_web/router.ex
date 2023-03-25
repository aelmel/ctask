defmodule CraftingTasksWeb.Router do
  use CraftingTasksWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CraftingTasksWeb do
    pipe_through :api

    post "/sort", TaskController, :sort
  end
end
