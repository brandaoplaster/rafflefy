defmodule Rafflefy.Repo.Migrations.CreateRaffles do
  use Ecto.Migration

  def change do
    create table(:raffles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :prize, :string
      add :description, :text
      add :ticket_price, :integer
      add :status, :string
      add :image_path, :string

      timestamps(type: :utc_datetime)
    end
  end
end
