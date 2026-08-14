# Changelog

## [Unreleased]

### Compatibility with MXC alpha topology

- Library stacks remain reusable `#AppCore` CUE definitions; no profile
  registry or package-path profile naming is required.
- One library application definition can be bound to multiple named deployment
  instances and clusters by the core `#TopologyAlpha` model.
- Application identity remains `appName`; deployment identity is derived from
  the instance map key through `name`, `instanceName`, and `appInstance`.
- Existing library adapter output remains unchanged.
- Cluster-centric catalogs can be derived by adapters without moving placement
  concerns into stack definitions.
- Deployment-specific reference and rollout validation remains an adapter or
  controller responsibility.

### Adoption requirements

- Publish and pin a CUE OCI version of `github.com/epcim/mxc` before replacing
  local development links or Git synchronization.
- Declare the published module dependency in `cue.mod/module.cue`.
- Continue using pass-through adapters that import active logic from
  `github.com/epcim/mxc/adapters/...` rather than copying it into this library.
