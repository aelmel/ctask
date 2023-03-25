import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crafting_tasks, CraftingTasksWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "P5SD08/NMSm/pe25TdoQvG+lS00Sm2CsYeeKkpuvVtJwDNJXZwN13K4ZySOt0+px",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
