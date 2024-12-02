defmodule AshAuthExample.Accounts.User.Senders.SendMagicLinkEmail do
  @moduledoc """
  Sends a magic link email
  """

  use AshAuthentication.Sender
  use AshAuthExampleWeb, :verified_routes

  @impl true
  def send(user_or_email, token, opts) do
    # if you get a user, its for a user that already exists
    # if you get an email, the user does not exist yet
    # Example of how you might send this email
    # Swa.Accounts.Emails.send_magic_link_email(
    #   user_or_email,
    #   token
    # )

    email =
      case user_or_email do
        %{email: email} -> email
        email -> email
      end

    IO.puts("""
    Click this link to reset your password:

    #{url(~p"/auth/user/magic_link/?token=#{token}")}
    """)
  end
end
