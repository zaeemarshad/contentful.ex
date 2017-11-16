defmodule Contentful.Preview do
  @moduledoc """
  A HTTP client for Contentful Preview Endpoint.
  This module connects to the preview.contentful.com endpoint and requires the preview access token
  """

  use Contentful.Base, endpoint: "preview.contentful.com"
end
