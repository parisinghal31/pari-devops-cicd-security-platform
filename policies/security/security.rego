package main

import rego.v1

# Policy: Security validation

deny contains msg if {
  input.kind == "Deployment"
  some container in input.spec.template.spec.containers
  container.securityContext.runAsUser == 0
  msg := sprintf("Container '%s' must not run as root (UID 0)", [container.name])
}

deny contains msg if {
  input.kind == "Deployment"
  some container in input.spec.template.spec.containers
  not container.securityContext.runAsNonRoot
  not container.securityContext.runAsUser
  msg := sprintf("Container '%s' must set runAsNonRoot=true or runAsUser>0", [container.name])
}

deny contains msg if {
  input.kind == "Deployment"
  some container in input.spec.template.spec.containers
  container.securityContext.allowPrivilegeEscalation == true
  msg := sprintf("Container '%s' must not allow privilege escalation", [container.name])
}
