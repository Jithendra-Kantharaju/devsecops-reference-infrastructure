package main

import rego.v1

# Reuses `containers` / `workload_kinds` defined in pod-security.rego
# (same package main).

# Reject the floating :latest tag, and reject images with no tag at all
# (which Kubernetes treats as :latest). The old check compared the whole
# image reference to the literal "latest", which never matched.

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	endswith(c.image, ":latest")
	msg := sprintf("%s/%s: container %q uses the :latest tag; pin an immutable tag/digest", [input.kind, input.metadata.name, c.name])
}

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	not contains(c.image, ":")
	not contains(c.image, "@sha256:")
	msg := sprintf("%s/%s: container %q has no image tag; pin an immutable tag/digest", [input.kind, input.metadata.name, c.name])
}

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	not c.resources.limits
	msg := sprintf("%s/%s: container %q must define resources.limits", [input.kind, input.metadata.name, c.name])
}

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	not c.livenessProbe
	msg := sprintf("%s/%s: container %q must define a livenessProbe", [input.kind, input.metadata.name, c.name])
}

deny contains msg if {
	input.kind in workload_kinds
	some c in containers
	not c.readinessProbe
	msg := sprintf("%s/%s: container %q must define a readinessProbe", [input.kind, input.metadata.name, c.name])
}
