# Vault (Secrets Management)

Two integration options are provided. Pick ONE.

## Option A — Vault Agent Injector (used by deployment-secure.yaml)

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault -n vault --create-namespace -f vault-values.yaml

# Enable Kubernetes auth + store the app config
kubectl exec -n vault vault-0 -- sh -c '
  vault auth enable kubernetes || true
  vault kv put secret/tic-tac-toe/config datadog-api-key=YOUR_KEY
  vault policy write tic-tac-toe - <<POLICY
  path "secret/data/tic-tac-toe/*" { capabilities = ["read"] }
POLICY
  vault write auth/kubernetes/role/tic-tac-toe \
    bound_service_account_names=tic-tac-toe \
    bound_service_account_namespaces=default \
    policies=tic-tac-toe ttl=1h'
```

The injector then mounts the secret at `/vault/secrets/app-config` in the pod.

## Option B — External Secrets Operator (external-secret.yaml)

Syncs a Vault key into the native `datadog-secret` the OTel collector reads,
so you never hand-create that secret. Install ESO, then `kubectl apply -f external-secret.yaml`.

## CI/CD

Pipeline secrets are pulled from Vault with `hashicorp/vault-action` in
`.github/workflows/pipeline.yml` instead of being stored as plain GitHub secrets.
