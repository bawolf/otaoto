defmodule Once.AES do
  def encrypt(plain_text) do
    iv = new_iv
    key = new_key
    state = :crypto.stream_init(:aes_ctr, key, iv)

    { _state, cipher_text } = :crypto.stream_encrypt(state, to_string(plain_text))
    iv_cipher_text = iv <> cipher_text

    %{ cipher_text: iv_cipher_text |> Base.encode64,
       key: key |> Base.encode64 }
  end

  def decrypt(cipher_text_string, key_string) do
    case key_string |> Base.decode64 do
      { :ok, key } -> 
        case cipher_text_string |> Base.decode64 do
          { :ok, iv_cipher } -> decipher(iv_cipher, key)
          :error -> raise "Expected cipher text to be a base64 encoded string"
        end
      :error ->  raise "Expected key to be a base64 encoded string"
    end
  end

  defp decipher(iv_cipher, key) do
    <<iv::binary-16, cipher_text::binary>> = iv_cipher
    state = :crypto.stream_init(:aes_ctr, key, iv)

    { _state, plain_text } = :crypto.stream_decrypt(state, cipher_text)
    { :ok, plain_text }
  end

  defp new_key do
    :crypto.strong_rand_bytes(32)
  end

  defp new_iv do
    :crypto.strong_rand_bytes(16)
  end
end
