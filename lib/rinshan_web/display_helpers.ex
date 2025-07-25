defmodule RinshanWeb.DisplayHelpers do
  alias Rinshan.Players.Player

  defp get_rating(%Player{sanma_rating_sigma: sigma, sanma_rating_mu: mu}, mode)
       when mode in [3, :sanma],
       do: {mu, sigma}

  defp get_rating(%Player{yonma_rating_sigma: sigma, yonma_rating_mu: mu}, mode)
       when mode in [4, :yonma],
       do: {mu, sigma}

  def display_skill(%Player{} = player, mode), do: display_skill(get_rating(player, mode))

  def display_skill({mu, sigma}) when is_nil(mu) or is_nil(sigma), do: nil

  def display_skill(rating) do
    rating
    |> Openskill.ordinal()
    |> Kernel.*(100)
    |> round()
    |> Integer.to_string()
    |> then(&(&1 <> if(elem(rating, 1) > 7.5, do: "?", else: "")))
  end
end
