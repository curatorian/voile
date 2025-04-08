defmodule VoileWeb.UserLoginLive do
  use VoileWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="max-w-7xl mx-auto flex flex-col items-center">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <div class="flex flex-col gap-8 items-center lg:flex-row lg:gap-36">
        <.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
        <div>
          <%= if @current_user === nil do %>
            <.button phx-click="google_auth">
              Login with Google
            </.button>
          <% else %>
            <.button disabled>
              Logout
            </.button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def handle_event("google_auth", _params, socket) do
    {:noreply, redirect(socket, to: "/auth/google")}
  end
end
