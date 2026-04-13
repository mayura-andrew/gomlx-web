---
title: "Installation"
lead: "Get GoMLX running in your Go project in under five minutes."
weight: 1
---

## Requirements

Before installing GoMLX, make sure you have the following:

- **Go 1.21 or later** — GoMLX uses generics and newer standard library features
- **A C compiler** (gcc or clang) — required to build the XLA bindings
- **Optional: CUDA 12+** — for NVIDIA GPU acceleration

You can verify your Go version with:

```bash
go version
# go version go1.21.5 linux/amd64
```

## Install via go get

GoMLX is a standard Go module. Add it to your project with:

```bash
go get github.com/gomlx/gomlx@latest
```

This pulls in the core library, the default CPU backend, and all sub-packages. The first build will take a minute or two because it compiles the XLA runtime — subsequent builds are cached.

{{< callout type="tip" >}}
On Linux, the XLA shared library is downloaded as a pre-built binary. On macOS, it is compiled from source. If you see a long compile step, this is expected.
{{< /callout >}}

## Verify the installation

Create a `main.go` in a fresh directory and paste this:

```go
package main

import (
    "fmt"
    "github.com/gomlx/gomlx/backends"
    "github.com/gomlx/gomlx/graph"
)

func main() {
    manager := backends.New()
    result := graph.Compile(manager, func(g *graph.Graph) *graph.Node {
        a := graph.Const(g, []float32{1, 2, 3})
        b := graph.Const(g, []float32{4, 5, 6})
        return graph.Add(a, b)
    }).Call()
    fmt.Println(result) // Tensor[float32: 3] = [5 7 9]
}
```

Run it:

```bash
go run main.go
# Tensor[float32: 3] = [5 7 9]
```

If you see the tensor output, GoMLX is installed and working correctly.

## GPU support (NVIDIA)

To enable GPU acceleration, install the CUDA backend:

```bash
go get github.com/gomlx/gomlx/backends/cuda@latest
```

Then import it as a side-effect in your `main.go`:

```go
import (
    _ "github.com/gomlx/gomlx/backends/cuda" // registers CUDA backend
    "github.com/gomlx/gomlx/backends"
)

func main() {
    manager := backends.New() // automatically uses GPU if available
    // ...
}
```

{{< callout type="note" >}}
GoMLX selects the best available backend automatically: GPU > CPU. You can force a specific backend with `backends.NewWithName("cpu")` or `backends.NewWithName("cuda")`.
{{< /callout >}}

## Running examples with Gonb (Jupyter for Go)

Many GoMLX examples are written as Gonb notebooks — the Go equivalent of Jupyter. To run them locally:

```bash
# Install Gonb
go install github.com/janpfeifer/gonb@latest
gonb --install

# Launch JupyterLab
jupyter lab
```

Then open any `.ipynb` file from the [examples directory](https://github.com/gomlx/gomlx/tree/main/examples) in JupyterLab.

{{< callout type="tip" >}}
All examples also have an "Open in Colab" link if you prefer not to set up Jupyter locally.
{{< /callout >}}

## Troubleshooting

**`cgo: C compiler not found`**
Install gcc: `sudo apt install build-essential` (Ubuntu) or `xcode-select --install` (macOS).

**`undefined: backends.New`**
Make sure you are on Go 1.21+. Run `go version` to confirm.

**`CUDA backend not found`**
Verify CUDA 12 is installed with `nvcc --version`. The CUDA toolkit must be on your `PATH`.

**Build is very slow on first run**
This is normal — XLA is being compiled. Subsequent builds use the cache and are fast.
