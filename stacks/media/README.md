# Media Service Stack

This directory contains containerized media library managers and file stream processors.

## 📦 Stack Components

* **`emby.cue`**: Media organizer hosting streaming libraries with full hardware transcoding capability.
* **`silo.cue`**: Scalable secure object storage caching video and raw audio files locally.

---

## 🛠️ Usage & Configuration

```cue
# Example cluster-home-mxc integration
package apps

import "github.com/epcim/mxc-library/stacks/media"

apps: {
    emby: media.#Emby & {
        storage: {
            "config": { size: "20Gi" }
        }
    }
}
```
