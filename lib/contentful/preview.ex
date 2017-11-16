defmodule Contentful.Preview do
  @moduledoc """
  A HTTP client for Contentful Preview Endpoint.
  This module connects to the preview.contentful.com endpoint and requires the preview access token
  """

  @sandbox Application.get_env(:contentful, :sandbox, false)
  if !@sandbox do
    use Contentful.Base, endpoint: "preview.contentful.com"
  else
    use Contentful.Sandbox
  end
end
