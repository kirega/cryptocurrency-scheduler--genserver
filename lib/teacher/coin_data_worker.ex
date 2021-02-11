defmodule Teacher.CoinDataWorker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    schedule_coin_fetch()
    {:ok, state}
  end

  def handle_info(:coin_fetch, state) do
    price = coin_price()
    IO.inspect("current bitcoin price is #{price}")
    schedule_coin_fetch()
    {:noreply, Map.put(state, :btc, price)}
  end

  defp coin_price do
    "https://api.coincap.io/v2/assets/bitcoin"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("data")
    |> Map.get("priceUsd")
  end

  defp schedule_coin_fetch() do
    Process.send_after(self(), :coin_fetch, 5_000)
  end
end
