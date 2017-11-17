defmodule Contentful.DeliveryTest do
  use ExUnit.Case
  alias Contentful.Delivery
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExVCR.Config, as: VCR

  @access_token "ACCESS_TOKEN"
  @space_id "z3aswf9egfi8"

  setup_all do
    HTTPoison.start()
    VCR.cassette_library_dir("fixture/vcr_cassettes/delivery")
    :ok
  end

  @tag timeout: 10000
  test "entries" do
    use_cassette "entries" do
      assert {:ok, entries} = Delivery.entries(@space_id, @access_token)
      assert is_list(entries)
    end

    use_cassette "entries-bad" do
      assert :error = Delivery.entries(@space_id, @access_token)
    end
  end

  @tag timeout: 10000
  test "search entry with includes" do
    use_cassette "single_entry_with_includes" do
      space_id = "if4k9hkjacuz"

      assert {:ok, entries} =
               Delivery.entries(space_id, @access_token, %{
                 "content_type" => "6pFEhaSgDKimyOCE0AKuqe",
                 "fields.slug" => "test-page",
                 "include" => "10"
               })

      assert is_list(entries)
    end
  end

  @tag timeout: 10000
  test "entry" do
    use_cassette "entry" do
      assert {:ok, entry} = Delivery.entry(@space_id, @access_token, "5JQ715oDQW68k8EiEuKOk8")

      assert is_map(entry["fields"])
    end
  end

  test "content_types" do
    use_cassette "content_types" do
      assert {:ok, types} = Delivery.content_types(@space_id, @access_token)
      first_content_type = types |> List.first()

      assert is_list(first_content_type["fields"])
    end
  end

  test "content_type" do
    use_cassette "content_type" do
      assert {:ok, content_type} =
               Delivery.content_type(@space_id, @access_token, "1kUEViTN4EmGiEaaeC6ouY")

      assert is_list(content_type["fields"])
    end
  end

  test "assets" do
    use_cassette "assets" do
      assert {:ok, assets} = Delivery.assets(@space_id, @access_token)
      first_asset = assets |> List.first()

      assert is_map(first_asset["fields"])
    end
  end

  test "asset" do
    use_cassette "asset" do
      assert {:ok, asset} = Delivery.asset(@space_id, @access_token, "2ReMHJhXoAcy4AyamgsgwQ")
      fields = asset["fields"]

      assert is_map(fields)
    end
  end

  test "space" do
    use_cassette "space" do
      assert {:ok, space} = Delivery.space(@space_id, @access_token)

      locales =
        space["locales"]
        |> List.first()

      assert locales["code"] == "en-US"
    end
  end
end
