defmodule Contentful.Delivery do
  @moduledoc """
  A HTTP client for Contentful.
  This module contains the functions to interact with Contentful's read-only
  Content Delivery API and requires the delivery access token.
  """
  use Contentful.Base, endpoint: "cdn.contentful.com"
end
