// vim: set ts=2 sw=2 et :
package schema

// mxc's own schema package internally imports these two sub-packages
// (mxc/module/schema/cue-imports.cue) without a version tag, since that is
// an internal self-import inside the mxc module. mxc-library never imports
// them directly, so `cue mod tidy` here has no reference to link them to the
// github.com/epcim/mxc@v0 dependency already declared in cue.mod/module.cue.
// CUE has no Go-style blank import, so each import needs its own name and a
// reference to keep the "imported and not used" check happy.
import (
	depsAlpha "github.com/epcim/mxc/schema/alpha"
	depsExternal "github.com/epcim/mxc/schema/external"
)

_depsAlpha:    depsAlpha
_depsExternal: depsExternal
