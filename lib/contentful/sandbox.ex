defmodule Contentful.Sandbox do

  def __using__(_opts) do
    quote do
      use Agent

      def start_link do
        Agent.start_link(fn -> %{} end, name: __MODULE__)
      end

      def entries(space_id, access_token, params \\ %{}) do
        Agent.get(__MODULE__, &Map.get(&1, "entries"))
      end

      def set_entries(entries) do
        Agent.update(__MODULE__, &Map.put(&1, "entries", entries))
      end

      def entry(space_id, access_token, entry_id, params \\ %{}) do
        Agent.get(__MODULE__, &Map.get(&1, "entry"))
      end

      def set_entry(entry) do
        Agent.update(__MODULE__, &Map.put(&1, "entry", entry))
      end

      def asset(space_id, access_token, asset_id, params \\ %{}) do
        Agent.get(__MODULE__, &Map.get(&1, "asset"))
      end

      def set_asset(asset) do
        Agent.update(__MODULE__, &Map.put(&1, "asset", asset))
      end

      def assets(space_id, access_token, params \\ %{}) do
        Agent.get(__MODULE__, &Map.get(&1, "assets"))
      end

      def set_assets(assets) do
        Agent.update(__MODULE__, &Map.put(&1, "assets", assets))
      end

      def content_types(space_id, access_token, params \\ %{}) do
        Agent.get(__MODULE__, &Map.get(&1, "content_types"))
      end

      def set_content_types(content_types) do
        Agent.update(__MODULE__, &Map.put(&1, "content_types", content_types))
      end

      def content_type(space_id, access_token, content_type_id, params \\ %{}) do
        Agent.get(__MODULE__, &Map.get(&1, "content_type"))
      end

      def set_content_type(content_type) do
        Agent.update(__MODULE__, &Map.put(&1, "content_type", content_type))
      end

      def space(space_id, access_token) do
        Agent.get(__MODULE__, &Map.get(&1, "space"))
      end

      def set_space(space) do
        Agent.update(__MODULE__, &Map.put(&1, "space", space))
      end
    end
  end
end
