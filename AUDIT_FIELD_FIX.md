# Audit Field Fix - Collection Create/Update

**Date:** 2026-10-20  
**Issue:** `create_collection/2` and `update_collection/3` were unconditionally overwriting audit fields with `user_id` argument (which defaults to nil), silently nullifying valid values from attrs.

## Problem

When calling `create_collection(attrs)` or `update_collection(collection, attrs)` without passing a `user_id`, the functions would:

1. Cast `created_by_id` and `updated_by_id` from attrs into the changeset ✅
2. Then immediately call `put_change(:created_by_id, nil)` ❌
3. Result: Valid user IDs from attrs were overwritten with nil

This affected downstream callers (like Atrium app) that passed audit fields in attrs but didn't use the `user_id` argument.

## Solution

Added `put_audit_field/3` helper function that implements the following logic:

```elixir
defp put_audit_field(changeset, field, user_id) do
  cond do
    # Explicit user_id provided - use it (overrides attrs)
    user_id != nil ->
      Ecto.Changeset.put_change(changeset, field, user_id)

    # No explicit user_id - keep what changeset has from attrs
    true ->
      changeset
  end
end
```

### Behavior

| Scenario | Result |
|----------|--------|
| `create_collection(%{created_by_id: user1_id})` | Uses `user1_id` from attrs ✅ |
| `create_collection(%{created_by_id: user1_id}, user2_id)` | Uses `user2_id` from argument (overrides) ✅ |
| `create_collection(%{})` | Both fields nil ✅ |
| `create_collection(%{}, user_id)` | Both fields set to `user_id` ✅ |

## Changes

### Files Modified

1. **`lib/voile/schema/catalog.ex`**
   - Added `put_audit_field/3` helper
   - Updated `create_collection/2` to use helper
   - Updated `update_collection/3` to use helper

2. **`test/voile/catalog_test.exs`**
   - Added 5 new tests covering all scenarios

### Tests Added

1. `create_collection/2 with created_by_id in attrs and no user_id keeps the attrs value`
2. `create_collection/2 with explicit user_id overrides attrs`
3. `create_collection/2 with no ids results in nil audit fields`
4. `update_collection/3 with updated_by_id in attrs and no user_id keeps the attrs value`
5. `update_collection/3 with explicit user_id overrides attrs`

All tests pass ✅

## Backward Compatibility

✅ **Fully backward compatible**
- Existing calls that pass `user_id` behave exactly as before
- Only changes behavior when `user_id` is nil (fixing the bug)
- No schema or migration changes
- No arity changes

## Impact

- Fixes production bug where CSV imports and external integrations create collections with NULL audit fields
- Atrium app can now pass audit fields in attrs without them being nullified
- Maintains expected behavior for callers that explicitly pass `user_id`
