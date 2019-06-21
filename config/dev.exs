use Mix.Config

config :gotham,
  default_account: :account1,
  accounts: [
    {:account1, file_path: "./priv/dev.json"},
    {:account2, file_path: "./priv/dev.json"}
  ]
