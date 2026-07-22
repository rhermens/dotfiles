# NestJS monitoring-list membership service extraction

Use when multiple CQRS handlers perform the same membership-removal side effect: query organizations scoped by `clientId` + `monitoringListId`, unset `monitoringListId`, and publish `OrganizationRemovedFromListEvent`.

## Pattern

1. Extract the side-effect sequence into an injectable domain/application service in the owning module, e.g. `monitoring/services/monitoring-list-membership.service.ts`.
2. Inject the Mongoose `Organization` model and `EventBus` into the service, not into every handler that only delegates this operation.
3. Expose one intention-revealing method, e.g. `removeOrganizationsFromList(options)`.
4. Keep handler call sites explicit:
   - bulk replace/update passes `exceptRemoteIds` and the selected `monitoringListId`;
   - bulk delete passes selected `organizationIds` and the same selected `monitoringListId`.
5. Type the options as a discriminated/union shape so callers cannot accidentally omit both selectors or pass both unless intended.
6. Register the service in the feature module providers.

## Query/update invariants

- Always scope reads by `clientId` and `monitoringListId` to preserve tenant/list isolation.
- Use the same found organizations as the event source so removal events reflect the previous membership.
- Unset with `{ $unset: { monitoringListId: '' } }` to match existing Mongoose conventions in this repo.
- Prefer updating only found IDs (`{ _id: { $in: organizations.map((o) => o._id) } }`) after the scoped read; this avoids publishing events for entities not actually selected.

## Tests

- Add a service spec that verifies the exact query, update, and emitted `OrganizationRemovedFromListEvent` for both modes:
  - `$nin` / `exceptRemoteIds` replace cleanup;
  - `$in` / selected `organizationIds` deletion.
- Update handler specs to assert delegation to the service rather than duplicating service internals in handler tests.
- Run targeted Jest for the service and both handlers, scoped ESLint on touched files, then full build/lint when feasible.
