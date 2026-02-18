# Project API responses

This document lists the response shapes the app expects (and the datasource is tolerant to) for the Projects endpoints.

## GET /get-projects
Accepted response shapes (all treated as a list of project objects):

1) Plain array

[
  { "id": 1, "name": "Website Redesign", "progress": 42, ... },
  { "id": 2, "name": "Mobile App", "progress": 7, ... }
]

2) Wrapped under `data` (common Laravel / API Resource wrapper)

{ "status": true, "data": [ { ... }, { ... } ] }

3) Wrapped under `projects` / `items` / `records` / `payload`

{ "projects": [ { ... }, { ... } ] }

4) Nested wrapper: `data` contains `projects`

{ "status": true, "data": { "projects": [ { ... } ] } }

5) String payload (server returned JSON string)

"[{ \"id\": 1, \"name\": \"X\" }]"

6) HTML or other non-JSON

- Detected and rejected. Datasource will throw a `ServerException('Server returned HTML...')`.

---

## GET /projects/{id}
Accepted shapes (treated as a single project object):

- Plain object: `{ "id": 1, "name": "..." }`
- Wrapped: `{ "data": { "id": 1, ... } }`
- Wrapped as `project`: `{ "project": { ... } }`
- Stringified JSON containing any of the above

---

## GET /projects/{id}/tasks
Accepted shapes (treated as a list of task objects):

- Plain array
- `{ "data": [ ... ] }`
- `{ "tasks": [ ... ] }`
- `{ "data": { "tasks": [ ... ] } }`
- Stringified JSON containing any of the above

---

## Troubleshooting
- If the app reports "Invalid response format" or "Server returned HTML":
  - Confirm `ApiConstant.baseUrl` is correct (contains `/api` if backend expects it).
  - Check backend responses in Postman and compare the top-level key names — if your API uses a custom wrapper (e.g. `projects`, `payload`) notify the app so we can add a specific parser.
  - If backend returns HTML for an API route, check server routing and that the request URL is correct (404 pages often return HTML).

## How the datasource behaves
- The datasource tries to be tolerant: it checks for multiple common envelope keys (`data`, `projects`, `items`, `records`, `payload`, `tasks`) and will attempt to JSON-decode string responses.
- If none of the accepted shapes match, a `ServerException` is thrown with a descriptive message to help debugging.
