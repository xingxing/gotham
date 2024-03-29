use Mix.Config

config :gotham,
  default_account: :account1,
  gcp_client_imp: Gotham.GCPClient.Mox,
  accounts: [
    {:account1, file_path: "./priv/beta-credentials.json"},
    {:account2, file_path: "./priv/beta-credentials.json"}
  ]
