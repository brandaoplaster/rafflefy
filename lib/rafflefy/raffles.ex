defmodule Rafflefy.Raffles do
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
    list_raffles()
    |> List.delete(raffle)
  end
end
