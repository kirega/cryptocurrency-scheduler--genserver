defmodule Teacher.CoinData do
  def fetch(id) do
    "https://api.coincap.io/v2/assets/#{id}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("data")
  end
end
