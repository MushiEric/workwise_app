Title: ci: upload coverage to Codecov in analyze_and_test job

Summary
- Adds a Codecov upload step to the existing `analyze_and_test` GitHub Actions job so test coverage (`coverage/lcov.info`) is reported to Codecov after unit/widget tests run.

What changed
- Modified `.github/workflows/ci.yml`:
  - Uploads `coverage/lcov.info` as an artifact (existing).
  - Adds `codecov/codecov-action@v4` step to send coverage to Codecov (new).
  - `CODECOV_TOKEN` is read from repository secrets when required.

Why
- Provides continuous coverage visibility and enables coverage gating / PR comments from Codecov.
- Complements the already-added APK build and optional Sentry release upload.

Testing
- `flutter analyze` and `flutter test` already run in the workflow; unit tests added earlier passed locally.
- Feature branch `ci/add-codecov` pushed to remote; CI will run on PR.

Security / Secrets
- (Optional) Add `CODECOV_TOKEN` as a repo secret for private coverage uploads. Public repos can often upload without a token.

Checklist
- [x] CI workflow updated
- [x] Tests and analyzer run in workflow
- [x] Branch pushed: `ci/add-codecov`
- [ ] Add `CODECOV_TOKEN` to repo secrets (if private repo)
- [ ] Merge PR and confirm Codecov reports appear

Suggested reviewers
- @MushiEric (owner)
- @devops or CI maintainer

Suggested labels
- `ci`, `chore`, `tests`

Notes for maintainer
- If you want Codecov PR comments, configure Codecov project settings and provide `CODECOV_TOKEN` (if required).