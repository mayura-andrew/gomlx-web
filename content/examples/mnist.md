---
title: "MNIST Classifier"
description: "Build and train a two-layer MLP on handwritten digits using GoMLX."
tags: ["vision", "beginner"]
weight: 1
---

{{< colab-badge url="https://colab.research.google.com/github/gomlx/gomlx/blob/main/examples/mnist/mnist.ipynb" >}}

---

A two-layer MLP trained on MNIST to ~98% accuracy. The best starting example for learning GoMLX — it uses the full stack: graph definition, a context for parameters, and the training loop.

## What you'll build

A multilayer perceptron that:
- Takes a flattened 28×28 grayscale image (784 floats) as input
- Passes it through two dense layers with ReLU activation
- Outputs 10 logits (one per digit class)
- Trains with Adam and cross-entropy loss to ~98% test accuracy in ~10k steps

## Full source

```go
package main

import (
    "fmt"
    "github.com/gomlx/gomlx/backends"
    "github.com/gomlx/gomlx/graph"
    "github.com/gomlx/gomlx/ml/context"
    "github.com/gomlx/gomlx/ml/layers"
    "github.com/gomlx/gomlx/ml/train"
    "github.com/gomlx/gomlx/ml/train/losses"
    "github.com/gomlx/gomlx/ml/train/metrics"
    "github.com/gomlx/gomlx/ml/train/optimizers"
    "github.com/gomlx/gomlx/examples/mnist"
)

// modelGraph defines the MLP architecture.
// GoMLX traces this function once and compiles it to XLA.
func modelGraph(ctx *context.Context, spec any, inputs []*graph.Node) []*graph.Node {
    x := inputs[0]                                           // [batch, 784]
    x = layers.Dense(ctx.In("hidden"), x, true, 128)        // [batch, 128]
    x = graph.Relu(x)
    x = layers.Dense(ctx.In("output"), x, true, 10)         // [batch, 10]
    return []*graph.Node{x}
}

func main() {
    // Load MNIST (downloads on first run, ~11 MB)
    trainDS, testDS := mnist.Load()

    manager := backends.New()
    ctx := context.New()

    trainer := train.NewTrainer(manager, ctx, modelGraph,
        losses.SparseCategoricalCrossEntropyLogits,
        optimizers.Adam(),
        train.EveryNSteps(200, func(loop *train.Loop, metrics []float32) error {
            fmt.Printf("step %d  loss=%.4f  acc=%.2f%%\n",
                loop.Step, metrics[0], metrics[1]*100)
            return nil
        }),
    )

    // Training loop
    loop := train.NewLoop(trainer)
    loop.RunSteps(trainDS, 10_000)

    // Evaluate on test set
    testMetrics := trainer.Eval(testDS)
    fmt.Printf("\nTest accuracy: %.2f%%\n", testMetrics["accuracy"]*100)
}
```

## Step-by-step walkthrough

### 1. The model function

```go
func modelGraph(ctx *context.Context, spec any, inputs []*graph.Node) []*graph.Node {
```

Every GoMLX model is a plain Go function with this signature. GoMLX calls it once to trace the computation graph, then compiles the trace to native code.

`ctx.In("hidden")` creates a named sub-scope so weight names stay unique: `hidden/weights`, `hidden/bias`, `output/weights`, `output/bias`.

### 2. Creating the trainer

```go
trainer := train.NewTrainer(manager, ctx, modelGraph,
    losses.SparseCategoricalCrossEntropyLogits,
    optimizers.Adam(),
    ...
)
```

`train.NewTrainer` wires together your model function, loss, and optimizer into a single object that handles the forward pass, loss computation, gradient calculation, and weight update — all on-device.

### 3. The training loop

```go
loop := train.NewLoop(trainer)
loop.RunSteps(trainDS, 10_000)
```

`RunSteps` pulls batches from `trainDS`, runs them through the trainer, and stops after 10,000 steps. The entire inner loop runs on the XLA backend — no Python, no host round-trips per step.

## Expected output

```
step 200   loss=0.4821  acc=86.50%
step 400   loss=0.2934  acc=91.80%
step 600   loss=0.2301  acc=93.40%
...
step 10000 loss=0.0614  acc=98.10%

Test accuracy: 97.94%
```

Training takes about 30 seconds on CPU, under 5 seconds on a GPU.

## Next steps

- Add dropout: `x = layers.Dropout(ctx, x, 0.2)` between the two dense layers
- Try a deeper network with 3–4 hidden layers
- Replace the MLP with a small CNN — see the [CIFAR-10 example](/examples/cifar/)
