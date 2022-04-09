defmodule Once.HTML.SecretControllerTest do
  use Once.ConnCase, async: false

  import Once.{Router.Helpers}
  alias Once.{Endpoint, Repo, Secret, TestHelper}

  test "GET /" do
    conn =
      build_conn()
      |> get(secret_path(Endpoint, :new))

    assert html_response(conn, 200) =~ "Share a Secret. Once"
  end

  test "POST /" do
    data = %{secret: %{plain_text: "hello, world."}}

    conn =
      build_conn()
      |> post(secret_path(Endpoint, :create, data))

    assert html_response(conn, 200) =~ "Your One Time Link"
    assert html_response(conn, 200) =~ "hello, world."
    assert length(Repo.all(Secret)) == 1
  end

  test "GET /gate/:slug/:key" do
    plain_text = "hello, world"

    %{secret: secret, secret_params: secret_params} =
      TestHelper.secret_from_plain_text(plain_text)

    assert Repo.one(from(s in Secret, select: count("*"))) == 1

    conn =
      build_conn()
      |> get(secret_path(Endpoint, :gate, secret.slug, secret_params.key))

    assert html_response(conn, 200) =~ "You Have a Secret!"
    refute html_response(conn, 200) =~ plain_text

    assert html_response(conn, 200) =~
             secret_path(Endpoint, :show, secret.slug, secret_params.key)
  end

  test "GET /gate/:slug/:key - with bad slug and key" do
    slug = "bad_slug"
    key = "bad_key"

    assert Repo.one(from(s in Secret, select: count("*"))) == 0

    conn =
      build_conn()
      |> get(secret_path(Endpoint, :gate, slug, key))

    assert html_response(conn, 200) =~ "You Have a Secret!"
    assert html_response(conn, 200) =~ secret_path(Endpoint, :show, slug, key)
  end

  test "GET /:slug/:key" do
    plain_text = "hello, world"

    %{secret: secret, secret_params: secret_params} =
      TestHelper.secret_from_plain_text(plain_text)

    conn =
      build_conn()
      |> get(secret_path(Endpoint, :show, secret.slug, secret_params.key))

    assert html_response(conn, 200) =~ "Here's a Secret"
    assert html_response(conn, 200) =~ plain_text
  end

  test "GET /:slug/:key - with a bad key" do
    plain_text = "hello, world"

    %{secret: secret} = TestHelper.secret_from_plain_text(plain_text)

    conn =
      build_conn()
      |> get(secret_path(Endpoint, :show, secret.slug, "bad key"))

    assert html_response(conn, 302) =~ "You are being"
    refute html_response(conn, 302) =~ plain_text
  end

  test "GET /:slug/:key - with a used key" do
    plain_text = "hello, world"

    %{secret: secret, secret_params: secret_params} =
      TestHelper.secret_from_plain_text(plain_text)

    build_conn()
    |> get(secret_path(Endpoint, :show, secret.slug, secret_params.key))

    conn_2 =
      build_conn()
      |> get(secret_path(Endpoint, :show, secret.slug, secret_params.key))

    assert html_response(conn_2, 302) =~ "You are being"
    refute html_response(conn_2, 302) =~ plain_text
  end
end
