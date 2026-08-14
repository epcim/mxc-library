# Storage Service Stack

This directory contains cloud-native block storage engine declarations and automated backup drivers.

## 📦 Stack Components

* **`longhorn.cue`**: Distributed resilient block storage engine supplying read-write-once (RWO) or read-write-many (RWX) PVs for high-availability pods.

---

## 🛠️ Usage & Configuration

```cue
# Example cluster-home-mxc integration
package apps

import "github.com/epcim/mxc-library/stacks/storage"

apps: {
    longhorn: storage.#Longhorn & {
        // High-availability storage controllers
    }
}
```
