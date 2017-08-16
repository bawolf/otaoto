defmodule Once.API.SecretControllerTest do
  use Once.ConnCase, async: false

  import Once.{Router.Helpers}
  alias Once.{Endpoint, Repo, Secret, TestHelper}

  test "POST /api/create" do
    data = %{secret: %{plain_text: "hello, world."}}

    conn =
      build_conn()
      |> post(api_secret_path(Endpoint, :create, data))

    keys = 
      json_response(conn, :created)["secret"]
      |> Map.keys

    assert "key" in keys
    assert "link" in keys
    assert "slug" in keys
    assert length(Repo.all(Secret)) == 1
  end

  test "GET /api/show/:slug/:key" do
    plain_text = "hello, world"

    %{secret: secret, secret_params: secret_params} = 
      TestHelper.secret_from_plain_text(plain_text)

    assert Repo.one(from s in Secret, select: count("*")) == 1
    
    conn = 
      build_conn()
      |> get(api_secret_path(Endpoint, :show, secret.slug, secret_params.key))

    assert json_response(conn, :ok)["plain_text"] == plain_text
    assert Repo.one(from s in Secret, select: count("*")) == 0
  end

  test "GET /api/show/:slug/:key - with a bad key" do
    plain_text = "hello, world"

    %{secret: secret} = 
      TestHelper.secret_from_plain_text(plain_text)
    
    conn = 
      build_conn()
      |> get(api_secret_path(Endpoint, :show, secret.slug, "bad_key"))

    assert json_response(conn, :not_found)["errors"] == ["This link has expired or never existed"]
  end

  test "GET /api/show/:slug/:key - with a used key" do
    plain_text = "hello, world"

    %{secret: secret} = 
      TestHelper.secret_from_plain_text(plain_text)
    
    build_conn()
    |> get(api_secret_path(Endpoint, :show, secret.slug, "bad_key"))

    conn_2 = 
      build_conn()
      |> get(api_secret_path(Endpoint, :show, secret.slug, "bad_key"))

    assert json_response(conn_2, :not_found)["errors"] == ["This link has expired or never existed"]
  end
end
