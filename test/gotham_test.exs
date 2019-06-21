defmodule GothamTest do
  use ExUnit.Case

  describe("get_account_name/1") do
    test "when account name has been setted" do
      Process.put(Gotham, :account_a)
      assert Gotham.get_account_name() == :account_a
    end

    test "otherwise use default account name" do
      Application.put_env(:gotham, :default_account, :account_b)
      assert Gotham.get_account_name() == :account_b
    end

    test "raise an exception when can not get an acccount name" do
      Application.put_env(:gotham, :default_account, nil)

      assert_raise Gotham.MissingAccountName, "Can not fond account name", fn ->
        Gotham.get_account_name()
      end
    end
  end

  describe "put_account_name/1" do
    test "when account name is an atom" do
      assert Gotham.put_account_name(:account1)
      assert Process.get(Gotham) == :account1
    end

    test "when account name is not an atom" do
      assert_raise ArgumentError, "account_name must be an atom", fn ->
        Gotham.put_account_name("account_b")
      end
    end
  end

  describe "with_account_name/2" do
    test "normal case" do
      assert Process.get(Gotham) == nil

      Gotham.with_account_name(:account2, fn ->
        assert Process.get(Gotham) == :account2
      end)

      assert Process.get(Gotham) == nil
    end
  end

  describe "get_profile/0" do
    test "normal case" do
      Process.put(Gotham, :account1)

      assert Gotham.get_profile() ==
               {:ok,
                %{
                  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
                  auth_uri: "https://accounts.google.com/o/oauth2/auth",
                  client_email: "xin@fake_project.iam.gserviceaccount.com",
                  client_id: "10989873626373787747",
                  client_x509_cert_url:
                    "https://www.googleapis.com/robot/v1/metadata/x509/cayman-inbex-test%40pxn-staging-env.iam.gserviceaccount.com",
                  private_key:
                    "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC4OdjdWwXEps7d\nkPtO6GfsV9q3g0chGHDbBs+jTD3/+CfSxF0/KGvyZNE3DEsyIC8VyxQj0jbgxosU\nri1lEzTE8RBi7KcL5vbJbNj2QRGedyE3hyn99Beb9Ouj31oTNSZIdjwgOu0ZAgBc\naUuchTcARMYt+NdgO9DmRbJ9CfhXCCD7rbU1sXRhRU5Iz61lrLN4r2gVqBKJanyZ\nQ198XIrgv0gtzh4gwOVCgy+V4QyQMwNfCBdZ78+YWL8Klm8UK8zCuKwYZaGqM4D+\nhVQCvJGe9c6MOWcwhGpTaBA0Xc20kopB9s7gbTqVtyLJob9Wri9f8U+7UPCXXV5I\nyHgDnDazAgMBAAECggEAAfv3UCix33f3TkKg1MwJpWkea4buo+/W2fZ1fXu51CAf\nEoM9T1JfW9NU0TN4DxzlY0dOoHvv9XvKGx4SdYuRFcfzQmwhLaWfdU0CObZMbdFK\nNy4Dxa9yaXHfYmtY3nOTZJ8iFPb+nj9R1xbmfLTwD20CEexhVnM8Rq99mNFrYTfA\nIGhb16+9q4jwXnS9+cvsXFs1f+hxDIAUnAfDSxaoXFkO+9T9f9un5XPWvEfq+k0O\nH/KUjCG2cWR9oDF5kLrLv5eNNMEtrtUSzcy6QDPNmJ2wV9RY2w1apxs7tzzvJXem\nWblEb+Rd2/iV4CuKX2cCpdnZvFEYc5RfAw4B289KqQKBgQDy6IJtR5fHzs990XK0\nM/iHru6oCRhjncZucmDbaif5ow65vjVZRtKk68t+iFMyh1z9vP+U+4Qv3mICrFKf\nqX4dt0gGXr6FimhMiW3bKH+c/VnMgZEPuaw/HRTDeLEIPwue+E1vervRIaNco93g\nyGbd8VRhGFfYUq3qzObVS8/oyQKBgQDCJ615xjhliG21ORNFK/AN5dwD21wYALXB\nQ3gnzqRLOA9hUsyRC3W40vig67oA34lDZ4NUnusmWC+uO4MlVrNjW0F8dr0Uh34s\nQ1xvyURWmychkc0kQIMMfL49IuMdCqnx8v2/S+PDT2lZvGC7ndQFenZ9PGFiKGla\nqwPaBb+dmwKBgQC9vF38bBqjqOgsGAkntxyfJ0YlnQ0e6qOPq+n6GT5mYTZkYa2c\nMZTh24jVKjkKU++QBywAPEIxfdxCyEW1jxgCsCIjT6gz+Tuk5QgZUtXzU3XsJxyf\nEuH3XojUcpadoVk7cCpUNKM2JLdM6naqWP74x8OoH/Kl91b/+9MmspQQ+QKBgQCN\n4NbI/QvrTkX1Py8QxinWzhj4DI2A0MwA3Z/pXvz6Jo4+rXXlrD0rgafEWF4FE1TI\nF9WFudfWnmzBYqXUXEYcnev92vsTDGcjgWO/RZGVxC1VP6lsC2R4dJPEM0FJ0Kgd\nsVayOu/Goro2pA0ALTZphnMd00jKpQNQCVZ4NOkwbwKBgGjRWeh2jg4ouIdJ0MIs\nZyi8pgNuwb4X8wazUmJ0RId3EmyNBo2FvU6i1WGMneShbATxOK5je6qZCSBdAYMi\n4lKQrdE4PpOwvlR6oUffENMjtd2DZBFPq2khJ7Zpsf5CVlTRaA8F8fldhRZxW1Wc\nSxn9tnYtYSj2v4hz5GfqP7au\n-----END PRIVATE KEY-----\n",
                  private_key_id: "46900d88664ebba4eb08f745b365254e2b0625ab",
                  project_id: "fake_project",
                  token_source: :oauth_jwt,
                  token_uri: "https://oauth2.googleapis.com/token",
                  type: "service_account"
                }}
    end
  end
end
