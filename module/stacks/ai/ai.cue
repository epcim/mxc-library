// vim: set ts=2 sw=2 et :
package ai

import (
	_dify "github.com/epcim/mxc-library/stacks/ai/dify"
	_litellm "github.com/epcim/mxc-library/stacks/ai/litellm"
	_mcp "github.com/epcim/mxc-library/stacks/ai/mcp"
	_open_webui "github.com/epcim/mxc-library/stacks/ai/open-webui:open_webui"
	_qdrant "github.com/epcim/mxc-library/stacks/ai/qdrant"
)

#LiteLLM:   _litellm.#LiteLLM
#OpenWebUI: _open_webui.#OpenWebUI
#Qdrant:    _qdrant.#Qdrant
#Dify:      _dify.#Dify
#McpFetch:  _mcp.#McpFetch
#McpTime:   _mcp.#McpTime
#McpGit:    _mcp.#McpGit
