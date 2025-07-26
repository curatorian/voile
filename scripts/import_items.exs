Mix.Task.run("app.start")

NimbleCSV.define(
  CSVParser,
  separator: ",",
  escape: "\"",
  escape_pattern: ~r/\\./
)

import Ecto.Query
alias Ecto.UUID
alias Voile.Repo
alias Voile.Catalog.Item

# Helpers
parse_int = fn
  val when val in [nil, ""] -> nil
  val -> String.to_integer(val)
end

parse_date = fn
  val when val in [nil, "", "0000-00-00 00:00:00"] ->
    NaiveDateTime.utc_now()

  val ->
    [date, time] = String.split(val, " ")
    NaiveDateTime.from_iso8601!(date <> "T" <> time)
end

# 🔗 Build biblio_id -> collection_id map from collections.old_biblio_id
biblio_map =
  from(c in Voile.Catalog.Collection, select: {c.old_biblio_id, c.id})
  |> Repo.all()
  |> Enum.into(%{}, fn {old_biblio_id, id} -> {parse_int.(to_string(old_biblio_id)), id} end)

IO.puts("🔗 Built biblio_id → collection_id map (#{map_size(biblio_map)} entries)")

# 4️⃣ Stream & import items.csv
stream =
  File.stream!("scripts/item.csv")
  |> CSVParser.parse_stream()
  |> Stream.map(fn row ->
    [
      _item_id,
      biblio_id,
      _call_number,
      _coll_type_id,
      item_code,
      inventory_code,
      _received_date,
      _supplier_id,
      _order_no,
      _location_id,
      _order_date,
      _item_status_id,
      site,
      _source,
      _invoice,
      _price,
      _price_currency,
      _invoice_date,
      input_date,
      last_update,
      _uid
    ] = row

    raw_uuid = UUID.generate()
    {:ok, id} = UUID.dump(raw_uuid)

    case Map.fetch(biblio_map, parse_int.(biblio_id)) do
      {:ok, coll_id} ->
        {:ok, collection_id} = UUID.dump(coll_id)

        {:ok,
         %{
           id: id,
           collection_id: collection_id,
           item_code: if(item_code == "", do: nil, else: item_code),
           inventory_code: if(inventory_code == "", do: nil, else: inventory_code),
           location: if(site == "", do: nil, else: site),
           status: "active",
           condition: "good",
           availability: "available",
           inserted_at: parse_date.(input_date),
           updated_at: parse_date.(last_update)
         }}

      :error ->
        IO.warn("⚠️ Skipped row with unmapped biblio_id: #{inspect(biblio_id)}")
        {:error, {:missing_biblio_id, biblio_id}}
    end
  end)

# Reduce while accumulating batches
{total_inserted, total_skipped, skipped_ids, pending_batch} =
  Enum.reduce(stream, {0, 0, [], []}, fn
    {:ok, item}, {inserted, skipped, skipped_ids, batch} when length(batch) < 499 ->
      {inserted, skipped, skipped_ids, [item | batch]}

    {:ok, item}, {inserted, skipped, skipped_ids, batch} ->
      Repo.insert_all(Item.__schema__(:source), Enum.reverse([item | batch]),
        on_conflict: :nothing
      )

      {inserted + length(batch) + 1, skipped, skipped_ids, []}

    {:error, {:missing_biblio_id, biblio_id}}, {inserted, skipped, skipped_ids, batch} ->
      {inserted, skipped + 1, [biblio_id | skipped_ids], batch}
  end)

# Insert any remaining items in the last batch
# Insert remaining batch
total_inserted =
  if pending_batch != [] do
    Repo.insert_all(Item.__schema__(:source), Enum.reverse(pending_batch), on_conflict: :nothing)
    total_inserted + length(pending_batch)
  else
    total_inserted
  end

# Print summary
IO.puts("✅ All done migrating items.")
IO.puts("📦 Total inserted: #{total_inserted}")
IO.puts("❌ Total skipped: #{total_skipped}")

if skipped_ids != [] do
  IO.puts("⚠️ Skipped biblio_ids (#{length(skipped_ids)}):")

  skipped_ids
  |> Enum.reverse()
  |> Enum.uniq()
  |> Enum.each(&IO.puts("- #{&1}"))
end
