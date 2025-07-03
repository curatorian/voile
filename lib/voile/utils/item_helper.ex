defmodule Voile.Utils.ItemHelper do
  alias Ecto.UUID

  def generate_item_code(unit, type, collection_id, index) do
    unit = String.downcase(unit)
    type = String.downcase(type)
    index = String.pad_leading(index, 3, "0")

    "#{unit}-#{type}-#{collection_id}-#{index}"
  end

  def generate_inventory_code(unit, type, sequential_number) do
    padded_number = String.pad_leading("#{sequential_number}", 9, "0")
    "INV/#{unit}/#{type}/#{padded_number}"
  end

  def default_item_params(collection_id, location_id, index) do
    item_code = generate_item_code("Kandaga", "Book", collection_id, index)
    inventory_code = generate_inventory_code("Kandaga", "Book", index)

    %{
      "item_code" => item_code,
      "inventory_code" => inventory_code,
      "barcode" => UUID.generate(),
      "location" => Integer.to_string(location_id),
      "status" => "active",
      "condition" => "new",
      "availability" => "available"
    }
  end
end
