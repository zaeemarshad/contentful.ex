defmodule Contentful.Http do
  use HTTPoison.Base

  @protocol "https"

  def process_url(url), do: "#{@protocol}://#{url}"

  def process_response_body(body) do
    case Poison.decode(body) do
      {:error, _} -> :error
      x -> x
    end
  end

  def process_request_headers(headers) do
    headers
    |> Keyword.put(:accept, "application/json")
    |> Keyword.put(:"User-Agent", "Contentful-Elixir")
  end
end
