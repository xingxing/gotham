
<p align="center">
  <img width="230" height="230" src="https://user-images.githubusercontent.com/120734/60244733-9a01ef80-98ed-11e9-91cd-54e0b864f82f.png" alt="gotham city">
</p>


[![CircleCI](https://circleci.com/gh/xingxing/gotham/tree/master.svg?style=svg)](https://circleci.com/gh/xingxing/gotham/tree/master)

# Gotham

*Support multiple GCP service account*

Google + Auth + Batman = Gotham

[](https://user-images.githubusercontent.com/120734/60244733-9a01ef80-98ed-11e9-91cd-54e0b864f82f.png)

## Installation

1. Add Gotham to you mix.exs
```elixir
def deps do
  [
    {:gotham, "~> 0.1.0"}
  ]
end
```

2. Configure service accounts
```elixir
config :gotham,
  default_account: :account1,
  accounts: [
    {:account1, file_path: "path/to/google/json/creds.json"},
    {:account2, file_path: "path/to/google/json/creds.json"}
  ]
```

## Usage

```elixir
# Use default account
{:ok, token} = Gotham.for_scope("https://www.googleapis.com/auth/pubsub")

%Gotham.Token{
  project_id: "test",
  access_token: "TOKEN",
  account_name: :account1,
  expire_at: 1561090622,
  scope: "https://www.googleapis.com/auth/pubsub",
  token_type: "Bearer"
}

# Change acocunt

Gotham.put_account_name(:account2)
Gotham.for_scope("https://www.googleapis.com/auth/pubsub")

{:ok,
 %Gotham.Token{
   project_id: "test",
   access_token: "TOKEN",
   account_name: :account2,
   expire_at: 1561092261,
   scope: "https://www.googleapis.com/auth/pubsub",
   token_type: "Bearer"
 }}

# Run a function with a specific account

Gotham.with_account_name(:account2, fn ->
  Gotham.for_scope("https://www.googleapis.com/auth/pubsub")
end)

{:ok,
 %Gotham.Token{
   project_id: "test",
   access_token: "TOKEN",
   account_name: :account2,
   expire_at: 1561092261,
   scope: "https://www.googleapis.com/auth/pubsub",
   token_type: "Bearer"
 }}
```
