# Secrets Configuration Model: Current go.d PR vs Telegraf Secretstores

## TL;DR

- Current go.d PR model is **inline reference resolution** (`${...}`) with no separate store definitions.
- Telegraf model is **store-instance based** (`[[secretstores.<type>]]` + `@{store_id:key}`).
- For users:
  - go.d is simpler in config syntax, but often requires service-level env/file wiring.
  - Telegraf is better when teams need multiple store instances of the same type and store-level operations.

## 1) How users configure secrets

| Topic | Current go.d PR (netdata) | Telegraf secretstores |
|---|---|---|
| Primary model | Put **reference placeholders** directly in collector config values (not secret values) | Define secret stores first, then reference them |
| Reference syntax | `${provider:...}` | `@{store_id:key}` |
| Store declaration | No separate store blocks | Required: `[[secretstores.<provider>]]` with `id` |
| Multiple stores of same provider | Not explicit as store objects; effectively one auth context per provider per process | Yes, native (multiple `[[secretstores.<type>]]` with different IDs) |
| Config complexity for user | Lower at first | Higher at first, but clearer store boundaries |
| Auth/credential setup location | Commonly process-level env/files for Netdata service (plus metadata in cloud runtimes) | Mostly store-specific config blocks, plus provider/runtime context where needed |
| systemd host setup effort | Usually requires env file + unit override + restart | Usually done in Telegraf config (store blocks); less reliance on systemd env wiring |

### Example: current go.d PR

```yaml
jobs:
  - name: app
    user: "${env:APP_USER}"
    password: "${aws-sm:myapp/db-secret#password}"
    api_token: "${vault:secret/data/app#token}"
```

### What "put reference placeholders directly in config values" means

- You replace plain-text values in collector config with `${...}` placeholders.
- You do **not** define reusable `secret store` objects in collector config.
- This does **not** automatically provision credentials for Netdata; you still must make auth material available to the Netdata process (env/files/metadata).
- The config file stores the **placeholder string** (for example `${aws-sm:myapp/db#password}`), not the resolved secret value.

### Plain-text secret risk (important)

- If a user writes `password: "myrealpassword"` in config, that is plain text and readable to anyone who can read the file.
- Safe usage is `password: "${...}"` so the file contains only a reference.
- Note: secret **sources** still need protection:
  - env files (for systemd deployments)
  - mounted secret files
  - vault tokens/credentials used by the Netdata process

### Critical operational requirement (systemd deployments)

For many real deployments, current go.d model needs process-level setup before refs work:

1. Create an env file (example: `/etc/netdata/secrets.env`) with required variables.
2. Add `EnvironmentFile=/etc/netdata/secrets.env` in a systemd drop-in (`systemctl edit netdata`).
3. Restart Netdata (`systemctl restart netdata`).
4. Verify variables reached process environment (e.g. `/proc/<pid>/environ` check).

Without this, users hit errors like:
- `environment variable 'X' is not set`
- `VAULT_ADDR environment variable is not set`
- `AWS region not set`

### Example: Telegraf

```toml
[[secretstores.vault]]
  id = "vault_prod"
  address = "https://vault.example.com"
  mount_path = "kv"
  secret_path = "prod/app"
  engine = "kv-v2"
  [secretstores.vault.approle]
    role_id = "..."
    secret = "..."

[[secretstores.vault]]
  id = "vault_stage"
  address = "https://vault-stage.example.com"
  mount_path = "kv"
  secret_path = "stage/app"
  engine = "kv-v2"
  [secretstores.vault.approle]
    role_id = "..."
    secret = "..."

[[inputs.http]]
  password = "@{vault_prod:db_password}"
```

## 2) What users get (operationally)

| Capability | Current go.d PR | Telegraf secretstores |
|---|---|---|
| Built-in cloud secret-manager fetch | Yes (`aws-sm`, `azure-kv`, `gcp-sm`, `vault`, plus `env/file/cmd`) | Different set (`vault`, `googlecloud`, `oauth2`, `http`, `os`, `systemd`, `docker`, `jose`) |
| Dynamic token-like re-resolution | No (resolved at config apply/job creation) | Yes for selected stores (dynamic resolver behavior) |
| Secret store CRUD/list CLI | No dedicated store CLI | Yes (`telegraf secrets list/get/set`) |
| Readback safety (`dyncfg get`-style) | Returns unresolved refs (no resolved value leakage) | N/A equivalent here; model is linked secrets in config layer |
| Per-store auth boundary | Limited (provider auth usually process env/metadata context) | Strong (each store instance has its own config/id) |
| Operational dependence on service env wiring | High on non-cloud hosts using env-based auth | Lower for many cases because credentials can be tied to store config blocks |

## 3) Pros and cons by approach

| Approach | Pros | Cons |
|---|---|---|
| Current go.d PR (inline `${...}`) | Very easy reference syntax; no store boilerplate; explicit per-field secret source; fast migration path | No first-class multi-store objects; no store CLI; no dynamic re-fetch lifecycle; **operational setup often required for Netdata process env/files (env file + systemd override + restart)** |
| Telegraf secretstores (`[[secretstores.*]]`) | Clear store boundaries; multiple stores per type; store-level operations; dynamic behavior for some providers | More config to write/maintain; more moving parts; references depend on store IDs |

## 4) Important nuance about authentication

- Telegraf is **not purely config-only auth**.
- Many stores use config, but some still rely on runtime environment/context (e.g., systemd credentials directory env var, platform keyrings, cloud runtime identity).
- Current go.d PR intentionally relies on env vars / metadata endpoints for cloud auth paths.

## 5) Practical decision guidance

| If your users mainly need... | Better fit now |
|---|---|
| Simple inline secret references in collector config | Current go.d PR model |
| Multiple independent store instances of same provider type | Telegraf-style model |
| Built-in cloud manager refs without store setup blocks | Current go.d PR model |
| Store inventory / get / set workflows from CLI | Telegraf-style model |

## 6) Bottom line for this merge

- Merging current go.d PR is reasonable for immediate user value and low config friction.
- For systemd users, document and communicate setup burden clearly: refs alone are not enough; Netdata service environment must be prepared.
- If later needed, store-instance architecture can be added internally without breaking existing `${...}` interface (as an additive model).
