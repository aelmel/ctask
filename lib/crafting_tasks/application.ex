defmodule CraftingTasks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CraftingTasksWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CraftingTasks.PubSub},
      # Start the Endpoint (http/https)
      CraftingTasksWeb.Endpoint
      # Start a worker by calling: CraftingTasks.Worker.start_link(arg)
      # {CraftingTasks.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CraftingTasks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CraftingTasksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
