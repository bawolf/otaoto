defmodule Once.SecretTest do
  use Once.ModelCase

  alias Once.{ Secret, Repo }

  @valid_attrs %{ cipher_text: "Np3iOnJMQZeFrMNIQsnxuyFRuoZDJ0jMy0l1nA==",
                  key: "xgX6qdOSQWJ8HWENp5mAhNNQXsVYOgznja8qKW2pQCk=" }

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
      assert length(String.split(secret.slug, "-")) == Application.get_env(:once, :slug_length)
    end
  end

  describe "when provided invalid params such as no cipher_text" do
    test "creates an invalid changeset " do
      invalid_attrs = %{ key: "xgX6qdOSQWJ8HWENp5mAhNNQXsVYOgznja8qKW2pQCk=" }
      changeset = Secret.changeset(%Secret{}, invalid_attrs)
      
      refute changeset.valid?
    end
  end

  describe "when provided invalid params such as no key" do
    test "creates an invalid changeset " do
      invalid_attrs = %{ cipher_text: "Np3iOnJMQZeFrMNIQsnxuyFRuoZDJ0jMy0l1nA==" }
      changeset = Secret.changeset(%Secret{}, invalid_attrs)
      
      refute changeset.valid?
    end
  end
end
