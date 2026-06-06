package main

import rego.v1

# ---------------------------------------------------------------------------
# Shared helpers. These are reused by deployment-security.rego (same package).
# They pull the pod spec from a bare Pod OR from a workload template so the
# rules actually fire on Deployments/DaemonSets/StatefulSets (the old policy
# only matched kind == "Pod", so it never evaluated anything in this repo).
# ---------------------------------------------------------------------------

workload_kinds := {"Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "Job"}

pod_spec := input.spec if input.kind == "Pod"
pod_spec := input.spec.template.spec if input.kind == "Deployment"
pod_spec := input.spec.template.spec if input.kind == "DaemonSet"
pod_spec := input.spec.template.spec if input.kind == "StatefulSet"

containers contains c if some c in pod_spec.containers

# ---------------------------------------------------------------------------
# Security-context rules
# ---------------------------------------------------------------------------

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	not c.securityContext.runAsNonRoot
	msg := sprintf("%s/%s: container %q must set securityContext.runAsNonRoot=true", [input.kind, input.metadata.name, c.name])
}

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	c.securityContext.allowPrivilegeEscalation != false
	msg := sprintf("%s/%s: container %q must set allowPrivilegeEscalation=false", [input.kind, input.metadata.name, c.name])
}

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	not c.securityContext.readOnlyRootFilesystem
	msg := sprintf("%s/%s: container %q must set readOnlyRootFilesystem=true", [input.kind, input.metadata.name, c.name])
}

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	not c.securityContext.capabilities.drop
	msg := sprintf("%s/%s: container %q must drop capabilities (drop: [ALL])", [input.kind, input.metadata.name, c.name])
}

warn contains msg if {
	input.kind in workload_kinds
	not pod_spec.securityContext.seccompProfile
	msg := sprintf("%s/%s: a seccompProfile (RuntimeDefault) is recommended", [input.kind, input.metadata.name])
}
