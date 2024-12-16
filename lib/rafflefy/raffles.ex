defmodule Rafflefy.Raffles do
  import Ecto.Query

  alias Rafflefy.Raffles.Raffle
  alias Rafflefy.Repo

  def list_raffles do
    Repo.all(Raffle)
  end

  def get_raffle(id) do
    case Ecto.UUID.cast(id) do
      {:ok, uuid} -> Repo.get(Raffle, uuid)
      :error -> nil
    end
  end

  def featured_raffles(raffle) do
    Raffle
    |> where(status: :open)
    |> where([r], r.id != ^raffle.id)
    |> order_by(desc: :ticket_price)
    |> limit(3)
    |> Repo.all()
  end

  def filter_raffles do
    Raffle
    |> where(status: :closed)
    |> order_by(:prize)
    |> Repo.all()
  end
end
