defmodule Once.AESTest do
  use Once.ConnCase

  alias Once.AES

  describe ".encrypt" do
    test "should return nil if no plain text is provided" do
      assert AES.encrypt(nil)
    end

    test "should generate an cipher text and a key if plain text is provided" do
      message = "Hello, World"

      map = AES.encrypt(message)

      assert is_binary(map.cipher_text)
      assert is_binary(map.key)
      refute map.cipher_text == message
      assert AES.decrypt(map.cipher_text, map.key) == {:ok, message }
    end
  end
# 
  describe ".decrypt" do
    test "a matching and base64 encoded key and cipher text produce a message" do
      cipher_text = "Np3iOnJMQZeFrMNIQsnxuyFRuoZDJ0jMy0l1nA=="
      key = "xgX6qdOSQWJ8HWENp5mAhNNQXsVYOgznja8qKW2pQCk="

      {:ok, result } = AES.decrypt(cipher_text, key)

      assert is_binary(result)
      assert result == "Hello, World"
    end

    test "a key that is not a base 64 encoded string raises an error" do
      cipher_text = "Np3iOnJMQZeFrMNIQsnxuyFRuoZDJ0jMy0l1nA=="
      key = "bad-string"

      assert_raise RuntimeError, "Expected key to be a base64 encoded string", fn ->
        AES.decrypt(cipher_text, key)
      end
    end

    test "a cipher text that is not a base 64 encoded string raises an error" do
      cipher_text = "bad-cipher-text"
      key = "xgX6qdOSQWJ8HWENp5mAhNNQXsVYOgznja8qKW2pQCk="

      assert_raise RuntimeError, "Expected cipher text to be a base64 encoded string", fn ->
        AES.decrypt(cipher_text, key)
      end
    end

    test "base64 encoded keys and cipher_text that are NOT compatible return :ok and a bit string" do
      cipher_text = "Np3iOnJMQZeFrMNIQsnxuyFRuoZDJ0jMy0l1nA=="
      key = "0DuPHPWl/3Yq5F4BH2Zw7uwD9Ao9xdsmEaBv3hTVOO4="

      {:ok, result } = AES.decrypt(cipher_text, key)

      assert is_binary(result)
      refute result == "Hello, World"
    end
  end
end
