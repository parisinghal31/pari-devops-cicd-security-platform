package main

import rego.v1

# Policy: Container validation (Enterprise edition)

banned_tags := {"latest", "dev", "test", "nightly", "snapshot"}

deny contains msg if {
  input.kind == "Deployment"
  some container in input.spec.template.spec.containers
  container.securityContext.privileged == true
  msg := sprintf("Container '%s' must not run in privileged mode", [container.name])
}

deny contains msg if {
  input.kind == "Deployment"
  some container in input.spec.template.spec.containers
  not contains(container.image, ":")
  msg := sprintf("Container '%s' image '%s' must include an explicit version tag", [container.name, container.image])
}

deny contains msg if {
  input.kind == "Deployment"
  some container in input.spec.template.spec.containers
  parts := split(container.image, ":")
  tag := parts[count(parts) - 1]
  banned_tags[tag]
  msg := sprintf("Container '%s' uses banned image tag '%s'", [container.name, tag])
}
