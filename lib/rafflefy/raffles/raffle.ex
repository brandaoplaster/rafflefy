defmodule Rafflefy.Raffles.Raffle do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "raffles" do
    field :status, Ecto.Enum, values: [:upcoming, :open, :closed]
    field :description, :string
    field :prize, :string
    field :ticket_price, :integer
    field :image_path, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(raflle, attrs) do
    raflle
    |> cast(attrs, [:prize, :description, :ticket_price, :status, :image_path])
    |> validate_required([:prize, :description, :ticket_price, :status, :image_path])
    |> validate_number(:ticket_price, greater_than_or_equal_to: 1)
    |> validate_length(:description, min: 10)
  end
end
