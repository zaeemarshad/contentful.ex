defmodule Contentful.Base do
  require Logger

  alias Contentful.{IncludeResolver, Http}

  defmacro __using__(params) do
    unless endpoint = Keyword.get(params, :endpoint) do
      raise ArgumentError, "no endpoint was set"
    end

    quote bind_quoted: [endpoint: endpoint] do
      @endpoint endpoint

      def entries(space_id, access_token, params \\ %{}) do
        entries_url = "/spaces/#{space_id}/entries"

        with {:ok, body} <-
               contentful_request(
                 entries_url,
                 access_token,
                 Map.delete(params, "resolve_includes")
               ) do
          case params["resolve_includes"] do
            x when x in [false, nil] ->
              Map.fetch(body, "items")
            true ->
              new_items =
                with {:ok, items} <- Map.fetch(body, "items"),
                     {:ok, includes} <- Map.fetch(body, "includes") do
                  {:ok, IncludeResolver.resolve_includes(items, includes)}
                end
          end
        end
      end

      def entry(space_id, access_token, entry_id, params \\ %{}) do
        with {:ok, entries} <-
               entries(space_id, access_token, Map.merge(params, %{"sys.id" => entry_id})) do
          entries |> Enum.fetch(0)
        end
      end

      def asset(space_id, access_token, asset_id, params \\ %{}) do
        assets_url = "/spaces/#{space_id}/assets/#{asset_id}"

        contentful_request(assets_url, access_token, params)
      end

      def assets(space_id, access_token, params \\ %{}) do
        assets_url = "/spaces/#{space_id}/assets"

        with {:ok, body} <- contentful_request(assets_url, access_token, params) do
          Map.fetch(body, "items")
        end
      end

      def content_types(space_id, access_token, params \\ %{}) do
        content_types_url = "/spaces/#{space_id}/content_types"

        with {:ok, body} <- contentful_request(content_types_url, access_token, params) do
          Map.fetch(body, "items")
        end
      end

      def content_type(space_id, access_token, content_type_id, params \\ %{}) do
        content_type_url = "/spaces/#{space_id}/content_types/#{content_type_id}"

        contentful_request(content_type_url, access_token, params)
      end

      def space(space_id, access_token) do
        space_url = "/spaces/#{space_id}"

        contentful_request(space_url, access_token)
      end

      defp contentful_request(uri, access_token, params \\ %{}) do
        query = URI.encode_query(params)

        final_url =
          if query != "" do
            URI.to_string(%URI{path: uri, query: query})
          else
            URI.to_string(%URI{path: uri})
          end

        with {:ok, response} <-
               Http.get("#{@endpoint}#{final_url}", [
                 {"Authorization", "Bearer #{access_token}"}
               ]) do
          response.body
        end
      end
    end
  end
end
