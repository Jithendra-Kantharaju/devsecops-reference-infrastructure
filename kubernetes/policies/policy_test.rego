package main

import rego.v1

# Run with: opa test kubernetes/policies/

_secure_container := {
	"name": "app",
	"image": "ghcr.io/org/app:1.2.3",
	"resources": {"limits": {"cpu": "500m", "memory": "512Mi"}},
	"livenessProbe": {"httpGet": {"path": "/", "port": 80}},
	"readinessProbe": {"httpGet": {"path": "/", "port": 80}},
	"securityContext": {
		"runAsNonRoot": true,
		"allowPrivilegeEscalation": false,
		"readOnlyRootFilesystem": true,
		"capabilities": {"drop": ["ALL"]},
	},
}

_deployment(container) := {
	"kind": "Deployment",
	"metadata": {"name": "demo"},
	"spec": {"template": {"spec": {
		"securityContext": {"seccompProfile": {"type": "RuntimeDefault"}},
		"containers": [container],
	}}},
}

test_secure_deployment_passes if {
	count(deny) == 0 with input as _deployment(_secure_container)
}

test_latest_tag_denied if {
	bad := json.patch(_secure_container, [{"op": "replace", "path": "/image", "value": "ghcr.io/org/app:latest"}])
	count(deny) > 0 with input as _deployment(bad)
}

test_run_as_root_denied if {
	bad := json.patch(_secure_container, [{"op": "remove", "path": "/securityContext/runAsNonRoot"}])
	count(deny) > 0 with input as _deployment(bad)
}

test_missing_limits_denied if {
	bad := json.patch(_secure_container, [{"op": "remove", "path": "/resources/limits"}])
	count(deny) > 0 with input as _deployment(bad)
}

test_wildcard_verb_denied if {
	role := {"kind": "ClusterRole", "metadata": {"name": "r"}, "rules": [{"verbs": ["*"], "resources": ["pods"]}]}
	count(deny) > 0 with input as role
}
