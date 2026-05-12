package main

import rego.v1

# Policy: Deployment validation

deny contains msg if {
  input.kind == "Deployment"
  not input.spec.replicas
  msg := sprintf("Deployment '%s' must define spec.replicas", [input.metadata.name])
}

deny contains msg if {
  input.kind == "Deployment"
  input.spec.replicas < 1
  msg := sprintf("Deployment '%s' must have at least 1 replica", [input.metadata.name])
}

deny contains msg if {
  input.kind == "Deployment"
  not input.metadata.namespace
  msg := sprintf("Deployment '%s' must specify a namespace", [input.metadata.name])
}

deny contains msg if {
  input.kind == "Deployment"
  input.metadata.namespace == "default"
  msg := sprintf("Deployment '%s' must not use the 'default' namespace", [input.metadata.name])
}

deny contains msg if {
  input.kind == "Deployment"
  some container in input.spec.template.spec.containers
  not container.resources.limits
  msg := sprintf("Container '%s' must define resource limits", [container.name])
}
