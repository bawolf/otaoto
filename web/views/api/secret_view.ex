defmodule Once.API.SecretView do
  use Once.Web, :view

  def render("create.json", %{secret: secret}) do
    %{secret: render_one(secret, Once.API.SecretView, "secret.json", as: :secret)}
  end

  def render("show.json", %{plain_text: plain_text}) do
    %{plain_text: plain_text}
  end

  def render("secret.json", %{secret: secret}) do
    %{key: secret.key, slug: secret.slug, link: secret.link}
  end

  def render("errors.json", %{messages: messages}) do
    %{errors: messages}
  end
end
