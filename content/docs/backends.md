---
weight: 80
title: "Backends & Highlights"
---
### Backends

GoMLX is a friendly "intermediary ML API", that hosts a common API and a library of ML layers and such. But per-se it doesn't execute any computation: it relies on different backends to compile and execute the computation on very different hardware.

There is a common backend interface (currently in `github.com/gomlx/gomlx/backends`, but it will soon go to its own repo), and 3 different implementations:

   1. **`xla`**: [OpenXLA](https://github.com/openxla/xla) backend for CPUs, GPUs, and TPUs. State-of-the-art as these things go, but only static-shape.
      For linux/amd64, linux/arm64 (CPU) and darwin/arm64 (CPU) for now. Using the [go-xla](https://github.com/gomlx/go-xla) Go version of the APIs.
   2. **`go`**: a pure Go backend (no C/C++ dependencies): slower but very portable (compiles to WASM/Windows/etc.): 
      * SIMD support is underway (see [SIMD for Go](https://github.com/golang/go/issues/73787) and under-development [go-highway](https://github.com/ajroetker/go-highway)); 
      * **🚀 NEW 🚀**: added support for some **fused operations** and for some types of quantization, greatly improving performance
        in some cases.
      * See also [GoMLX compiled to WASM to power the AI for a game of Hive](https://janpfeifer.github.io/hiveGo/www/hive/)
      * Dynamic shape support planned (maybe mid-2026).
   3. **🚀 NEW 🚀** **[go-darwinml](https://github.com/gomlx/go-darwinml)**: Go bindings to Apple's CoreML supporting Metal acceleration, MLX, and any backend DarwinOS related. 

### Highlights

* Converting ONNX models to GoMLX with [onnx-gomlx](https://github.com/gomlx/onnx-gomlx): both as an alternative for `onnxruntime` (leveraging XLA),
  but also to further fine-tune models. See also [go-huggingface](https://github.com/gomlx/go-huggingface) to easily download ONNX model files from HuggingFace.
* [Docker "gomlx_jupyterlab"](https://hub.docker.com/r/janpfeifer/gomlx_jupyterlab) with integrated JupyterLab and [GoNB](https://github.com/janpfeifer/gonb) (a Go kernel for Jupyter notebooks)
* Autodiff: automatic differentiation—only gradients for now, no jacobian.
* Context: automatic variable management for ML models.
* ML layers library with some of the most popular machine learning "layers": FFN layers,  
  various activation functions, layer and batch normalization, convolutions, pooling, dropout, Multi-Head-Attention
  (for transformer layers), LSTM, KAN (B-Splines, [GR-KAN/KAT networks](https://arxiv.org/abs/2409.10594), Discrete-KAN, PiecewiseLinear KAN),
  PiecewiseLinear (for calibration and normalization), various regularizations,
  FFT (reverse/differentiable), learnable rational functions (both for activations and [GR-KAN/KAT networks](https://arxiv.org/abs/2409.10594)),
  VNN (Vector Neural Networks) for SO(3)-Equivariant/Invariant layers, etc.
* Training library, with some pretty-printing. Including plots for Jupyter notebook, using [GoNB, a Go Kernel](https://github.com/janpfeifer/gonb).
  * Also, various debugging tools: collecting values for particular nodes for plotting, simply logging  the value
    of nodes during training, stack-trace of the code where nodes are created.
* `gomlx_checkpoints`, the command line tool to inspect checkpoints of train(-ing) models, **generate plots**
  with loss and arbitrary evaluation metrics using Plotly.
  See [example of training session](https://gomlx.github.io/gomlx/notebooks/gomlx_checkpoints_plot_example.html),
  with the effects of a learning rate change during the training.
  It also allows plotting different models together, to compare their evolution.
* SGD and Adam (AdamW and Adamax) optimizers.
* Various losses and metrics.
* Pre-Trained models to use: InceptionV3 (image model), many more from HuggingFace using [onnx-gomlx](https://github.com/gomlx/onnx-gomlx).
  See also [go-huggingface](https://github.com/gomlx/go-huggingface) to easily download ONNX model files from HuggingFace. 
* Read Numpy arrays into GoMLX tensors -- see package `github.com/gomlx/gomlx/pkg/core/tensors/numpy`.
* (**Experimental**) Support static linking of PJRT: slower to build the Go program, but deploying it doesn't require installing a PJRT plugin in the machine you are deploying it. It requires you to compile your own static PJRT plugin from XLA sources.
  Use `go build --tags=pjrt_cpu_static` or include `import _ "github.com/gomlx/gomlx/backends/xla/cpu/static"`.
* **Auto-installation of XLA PJRT plugins** (for CPU, GPU and TPUs; Linux and Macs)
  in the user'slocal lib directory (`$HOME/.local/lib` in Linux and `$HOME/Library/Application Support/XLA` in Mac).
  It can be disabled by setting `GOMLX_NO_AUTO_INSTALL` or programmatically by 
  calling `xla.EnableAutoInstall(false)`).
* **Distributed Execution** (across multiple GPUs or TPUs) with little hints from the user.
  One only needs to configure a distributed dataset, and the trainer picks up from there.
  See code change in [UCI-Adult demo](https://github.com/gomlx/gomlx/blob/main/examples/adult/demo/main.go#L222). **Experimental**, 
  pls report any issues and help us improve it.
