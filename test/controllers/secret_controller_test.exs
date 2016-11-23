defmodule Once.SecretControllerTest do
  use Once.ConnCase, async: false

  alias Once.{ AES, Repo, Secret }

  test "GET /" do
    conn = get(build_conn, secret_path(build_conn, :new))
    assert html_response(conn, 200) =~ "The app for disposable secret sharing"
  end

  test "POST /" do
    conn = post(build_conn, secret_path(build_conn, :create, %{ secret: %{ plain_text: "hello, world."}}))

    assert html_response(conn, 200) =~ "Your secret is available at the link below"
    assert html_response(conn, 200) =~ "hello, world."
    assert length(Repo.all(Secret)) == 1
  end

  test "GET /:slug/:key" do
    plain_text = "hello, world"
    secret_params = AES.encrypt(plain_text)
    changeset = Secret.changeset(%Secret{}, secret_params)
    { :ok, secret } = Repo.insert(changeset)
    
    conn =  build_conn
    |> get(secret_path(build_conn, :show, secret.slug, secret_params.key))

    assert html_response(conn, 200) =~ "Here's a Secret"
    assert html_response(conn, 200) =~ plain_text
  end

  test "GET /:slug/:key - with a bad key" do
    plain_text = "hello, world"
    secret_params = AES.encrypt(plain_text)
    changeset = Secret.changeset(%Secret{}, secret_params)
    { :ok, secret } = Repo.insert(changeset)
    
    conn =  build_conn
    |> get(secret_path(build_conn, :show, secret.slug, "bad key"))

    assert html_response(conn, 302) =~ "You are being"
    refute html_response(conn, 302) =~ plain_text
  end

  test "GET /:slug/:key - with a used key" do
    plain_text = "hello, world"
    secret_params = AES.encrypt(plain_text)
    changeset = Secret.changeset(%Secret{}, secret_params)
    { :ok, secret } = Repo.insert(changeset)
    
    build_conn
    |> get(secret_path(build_conn, :show, secret.slug, secret_params.key))

    conn_2 =  build_conn
    |> get(secret_path(build_conn, :show, secret.slug, secret_params.key))

    assert html_response(conn_2, 302) =~ "You are being"
    refute html_response(conn_2, 302) =~ plain_text
  end
end
