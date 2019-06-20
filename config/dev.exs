use Mix.Config

config :gotham,
  default_account: :account1,
  accounts: [
    {:account1, file_path: "/Users/xingxing/PXN/counter/priv/gcp/beta-credentials.json"},
    {:account2, file_path: "/Users/xingxing/PXN/counter/priv/gcp/beta-credentials.json"}
  ]
