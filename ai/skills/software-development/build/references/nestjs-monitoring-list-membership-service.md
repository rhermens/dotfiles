# NestJS monitoring-list membership service extraction

Use when multiple CQRS handlers perform the same monitoring-list membership side effects, including:

- removing organizations from a list by querying scoped organizations, unsetting `monitoringListId`, and publishing `OrganizationRemovedFromListEvent`;
- publishing membership transition events when an organization is assigned or moved between lists (`OrganizationRemovedFromListEvent` for the previous list + `OrganizationAddedToListEvent` for the target list, or no-op if unchanged).

## Pattern

1. Extract side-effect and event-construction logic into an injectable domain/application service in the owning module, e.g. `monitoring/services/monitoring-list-membership.service.ts`.
2. Inject the Mongoose `Organization` model and `EventBus` into the service, not into every handler that only delegates this operation.
3. Expose intention-revealing methods, for example:
   - `removeOrganizationsFromList(options)` for scoped removals;
   - `publishOrganizationListChange(options)` for one organization assignment/move side effects;
   - `createOrganizationListChangeEvents(options)` when a bulk handler needs to compose events before publishing.
4. Keep handler call sites explicit:
   - bulk replace/update passes `exceptRemoteIds` and the selected `monitoringListId`;
   - bulk delete passes selected `organizationIds` and the selected `monitoringListId`;
   - single monitor passes the current organization and target `monitoringListId`;
   - create/upsert organization passes the updated organization plus explicit `previousMonitoringListId`, because the returned document may already contain the new list.
5. Type removal options as a discriminated/union shape so callers cannot accidentally omit both selectors or pass both unless intended.
6. Register the service in the feature module providers. If handlers in another module need it, export the service from the owning module and import that module where needed.

## Query/update invariants

- Always scope reads by `clientId` and `monitoringListId` to preserve tenant/list isolation.
- Use the same found organizations as the event source so removal events reflect the previous membership.
- Unset with `{ $unset: { monitoringListId: '' } }` to match existing Mongoose conventions in this repo.
- Prefer updating only found IDs (`{ _id: { $in: organizations.map((o) => o._id) } }`) after the scoped read; this avoids publishing events for entities not actually selected.
- For list transitions, compare previous and target list IDs before emitting events; unchanged assignments are no-ops.
- If an upsert/update returned organization already has the target list, pass the separately captured previous list into the service. Do not infer previous state from the post-update entity.

## Tests

- Add a service spec that verifies exact query, update, and emitted `OrganizationRemovedFromListEvent` for both removal modes:
  - `$nin` / `exceptRemoteIds` replace cleanup;
  - `$in` / selected `organizationIds` deletion.
- Add service tests for transition event construction/publication:
  - no previous list → add event only;
  - previous list differs → remove + add events;
  - previous list equals target → no events;
  - explicit `previousMonitoringListId` overrides the organization's current field.
- Update handler specs to assert delegation to the service rather than duplicating service internals in handler tests.
- When service extraction crosses module boundaries, add/verify module exports/imports as part of build verification.
- Run targeted Jest for the service and all touched handlers. If a large combined targeted Jest invocation segfaults after individual suites start passing, split the same suite set into smaller `pnpm run test -- ... --runInBand` invocations and report both the runner crash and the passing split evidence.
- Run scoped ESLint on touched files, then full build/lint when feasible.
