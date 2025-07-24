defmodule RinshanWeb.SheetSourceLive.FormComponent do
  use RinshanWeb, :live_component

  alias Rinshan.Imports

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage sheet_source records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sheet_source-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:sheet_id]} type="text" label="Sheet" />
        <.input field={@form[:year]} type="number" label="Year" />
        <.input
          field={@form[:tags]}
          type="select"
          multiple
          label="Tags"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input field={@form[:registry_range]} type="text" label="Registry range" />
        <.input field={@form[:games_range]} type="text" label="Games range" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Sheet source</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sheet_source: sheet_source} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Imports.change_sheet_source(sheet_source))
     end)}
  end

  @impl true
  def handle_event("validate", %{"sheet_source" => sheet_source_params}, socket) do
    changeset = Imports.change_sheet_source(socket.assigns.sheet_source, sheet_source_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"sheet_source" => sheet_source_params}, socket) do
    save_sheet_source(socket, socket.assigns.action, sheet_source_params)
  end

  defp save_sheet_source(socket, :edit, sheet_source_params) do
    case Imports.update_sheet_source(socket.assigns.sheet_source, sheet_source_params) do
      {:ok, sheet_source} ->
        notify_parent({:saved, sheet_source})

        {:noreply,
         socket
         |> put_flash(:info, "Sheet source updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_sheet_source(socket, :new, sheet_source_params) do
    case Imports.create_sheet_source(sheet_source_params) do
      {:ok, sheet_source} ->
        notify_parent({:saved, sheet_source})

        {:noreply,
         socket
         |> put_flash(:info, "Sheet source created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
