defmodule Voile.Schema.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Accounts.UserRole

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :username, :string
    field :identifier, :integer
    field :email, :string
    field :fullname, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :current_password, :string, virtual: true, redact: true
    field :confirmed_at, :utc_datetime
    field :user_type, :string
    field :user_image, :string
    field :social_media, :map, type: :jsonb
    field :groups, {:array, :string}
    field :node_id, :integer
    field :last_login, :utc_datetime
    field :last_login_ip, :string

    belongs_to :user_roles, UserRole

    field :twitter, :string, virtual: true
    field :facebook, :string, virtual: true
    field :linkedin, :string, virtual: true
    field :instagram, :string, virtual: true
    field :website, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :username,
      :identifier,
      :email,
      :fullname,
      :user_type,
      :user_role,
      :password,
      :confirmed_at,
      :user_type,
      :user_image,
      :groups,
      :node_id,
      :twitter,
      :facebook,
      :linkedin,
      :instagram,
      :website,
      :last_login,
      :last_login_ip
    ])
    |> put_social_media
    |> validate_length(:username, min: 3, max: 30)
    |> validate_username(opts)
    |> validate_email(opts)
    |> validate_password(opts)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_username(changeset, opts) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, min: 3, max: 30)
    |> maybe_validate_username_unique(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Voile.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  defp maybe_validate_username_unique(changeset, opts) do
    if Keyword.get(opts, :validate_username, true) do
      changeset
      |> unsafe_validate_unique(:username, Voile.Repo, message: "Username has already been taken")
      |> unique_constraint(:username)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Voile.Schema.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    changeset = cast(changeset, %{current_password: password}, [:current_password])

    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  defp put_social_media(changeset) do
    twitter = get_field(changeset, :twitter)
    facebook = get_field(changeset, :facebook)
    linkedin = get_field(changeset, :linkedin)
    instagram = get_field(changeset, :instagram)
    website = get_field(changeset, :website)

    social_media = %{
      "twitter" => twitter,
      "facebook" => facebook,
      "linkedin" => linkedin,
      "instagram" => instagram,
      "website" => website
    }

    put_change(changeset, :social_media, social_media)
  end
end
