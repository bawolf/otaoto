defmodule Once.SecretTest do
  use Once.ModelCase

  alias Once.{ Secret, Repo }

  @valid_attrs %{ cipher_text: "abcdef123456" }
  @invalid_attrs %{}

  describe "When provided valid params" do
    test "should create a valid changeset" do
      changeset = Secret.changeset(%Secret{}, @valid_attrs)

      assert changeset.valid?
    end

    test "should generate an id and a slug" do
      changeset = Secret.changeset(%Secret{}, @valid_attrs)
      {:ok, secret } = Repo.insert(changeset)

      assert is_binary(secret.slug)
      assert String.contains?(secret.slug, "-")
      assert length(String.split(secret.slug, "-")) == String.to_integer(System.get_env("SLUG_LENGTH"))
    end
  end

  describe "when provided invalid params such as no cipher_text" do
    test "creates an invalid changeset " do
      changeset = Secret.changeset(%Secret{}, @invalid_attrs)

      refute changeset.valid?
    end
  end
end
