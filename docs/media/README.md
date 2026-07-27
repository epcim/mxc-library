# Media Service Stack

This directory contains containerized home-entertainment servers and secure media cache systems.

---

## 📦 Stack Components

* **`emby.cue`**: Multimedia library host organizing movies, television shows, and audio libraries.
* **`silo.cue`**: Resilient object storage caching heavy media files locally for quick access.

---

## 🚀 GPU Passthrough & Transcoding

To configure hardware acceleration for Emby streams on nodes with Intel/Nvidia graphics cards, the container is launched with elevated hardware capabilities:
```cue
package apps

import "github.com/epcim/mxc-library/stacks/media"

apps: {
    emby: media.#Emby & {
        context: controllers: main: containers: main: {
            securityContext: {
                privileged: true
            }
        }
    }
}
```
This enables direct device node access to `/dev/dri` inside the container for frictionless hardware transcoding!
