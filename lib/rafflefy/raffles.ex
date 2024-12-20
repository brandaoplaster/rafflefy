defmodule Rafflefy.Raffles do
  import Ecto.Query

  alias Rafflefy.Raffles.Raffle
  alias Rafflefy.Repo

  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

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

  def filter_raffles(params) do
    Raffle
    |> with_status(params["status"])
    |> search_by(params["q"])
    |> sort(params["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(open closed upcoming) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [r], ilike(r.prize, ^"%#{q}%"))
  end

  defp sort(query, "prize") do
    order_by(query, :prize)
  end

  defp sort(query, "ticket_price_desc") do
    order_by(query, desc: :ticket_price)
  end

  defp sort(query, "ticket_price_asc") do
    order_by(query, asc: :ticket_price)
  end

  defp sort(query, _), do: order_by(query, :id)
end
