defmodule Teacher.CoinDataWorker do
  use GenServer

  def start_link(args) do
    id = Map.get(args, :id)
    GenServer.start_link(__MODULE__, args, name: id)
  end

  def init(state) do
    schedule_coin_fetch()
    {:ok, state}
  end

  def handle_info(:coin_fetch, state) do
    updated_state =
      state
      |> Map.get(:id)
      |> coin_data()
      |> update_state(state)

    if updated_state[:price] != state[:price] do
      IO.inspect("current #{updated_state[:name]} price is #{updated_state[:price]}")
    end

    schedule_coin_fetch()
    {:noreply, updated_state}
  end

  defp update_state(%{"id" => name, "priceUsd" => price}, existing_state) do
    Map.merge(existing_state, %{name: name, price: price})
  end

  defp coin_data(id) do
    "https://api.coincap.io/v2/assets/#{id}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("data")
  end

  defp schedule_coin_fetch() do
    Process.send_after(self(), :coin_fetch, 5_000)
  end
end
