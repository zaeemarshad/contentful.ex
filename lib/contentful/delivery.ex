defmodule Contentful.Delivery do
  @moduledoc """
  A HTTP client for Contentful.
  This module contains the functions to interact with Contentful's read-only
  Content Delivery API and requires the delivery access token.
  """
  @sandbox Application.get_env(:contentful, :sandbox, false)
  if !@sandbox do
    use Contentful.Base, endpoint: "cdn.contentful.com"
  else
    use Contentful.Sandbox
  end

end
