# Internal publisher request

`.publisher/request.json` is an owner-controlled trigger used to copy a verified binary from a short-lived, allow-listed HTTPS source into a stable public path.

Required fields:

- `schemaVersion`: 1
- `sourceUrl`
- `sourceSha256`
- `destination`
- optional `archive: "zip"`
- optional `extract`
- optional `outputSha256`

The workflow rejects path traversal, non-HTTPS URLs, and sources outside the allow-list.
