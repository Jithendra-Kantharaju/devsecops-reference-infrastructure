package main

import rego.v1

rbac_kinds := {"Role", "ClusterRole"}

deny contains msg if {
	input.kind in rbac_kinds
	some rule in input.rules
	"*" in rule.verbs
	msg := sprintf("%s/%s: wildcard verbs ('*') are not allowed", [input.kind, input.metadata.name])
}

deny contains msg if {
	input.kind in rbac_kinds
	some rule in input.rules
	"*" in rule.resources
	msg := sprintf("%s/%s: wildcard resources ('*') are not allowed", [input.kind, input.metadata.name])
}

deny contains msg if {
	input.kind == "ClusterRoleBinding"
	input.roleRef.name == "cluster-admin"
	msg := sprintf("ClusterRoleBinding/%s: binding to cluster-admin is not allowed", [input.metadata.name])
}
