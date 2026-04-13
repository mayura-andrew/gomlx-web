---
title: "Examples developed using GoMLX"
description: "A collection of examples, models, and tutorials built using the GoMLX framework."
---


* **🚀 NEW 🚀** [KaLM-Gemma3 12B parameters](https://github.com/gomlx/go-huggingface/tree/main/examples/kalmgemma3): Tencent's top-ranked sentence encoder
  for RAGs, using [go-huggingface](https://github.com/gomlx/go-huggingface/) to load the model and tokenizer, and **GoMLX** to execute it.
* **🚀 NEW 🚀** [Gemma 3 270M](https://github.com/gomlx/gomlx/tree/main/examples/gemma3): Demonstrates ONNX-converted
  text generation (LLM) using the [onnx-community/gemma-3-270m-it-ONNX](https://huggingface.co/onnx-community/gemma-3-270m-it-ONNX) 
  model with GoMLX. 
  It uses the [`gomlx/onnx-gomlx`](https://github.com/gomlx/onnx-gomlx) package to convert the model, and [`gomlx/go-huggingface`](https://github.com/gomlx/go-huggingface) to download the model and run the tokenizer.
* **🚀 NEW 🚀** [GPT-2](https://github.com/gomlx/gomlx/tree/main/examples/gpt2): Demonstrates text generation using the
  new (experimental) transformer and generator packages.
* **🚀 NEW 🚀** [BERT-base-NER](https://github.com/gomlx/gomlx/tree/main/examples/BERT-base-NER): A BERT-base model fine-tuned
  for Named Entity Recognition. It's also an ONNX-converted model from the [dslim/bert-base-NER model](https://huggingface.co/dslim/bert-base-NER) on HuggingFace.
* **🚀 NEW 🚀** [MixedBread Reranker v1](https://github.com/gomlx/gomlx/tree/main/examples/mxbai-rerank): A cross-encoder reranking 
  example. See [HuggingFace MixedBread Reranker v1 page](https://huggingface.co/mixedbread-ai/mxbai-rerank-base-v1).
  It uses the [`gomlx/onnx-gomlx`](https://github.com/gomlx/onnx-gomlx) package to convert the model, and [`gomlx/go-huggingface`](https://github.com/gomlx/go-huggingface) to download the model and run the tokenizer.

* [Adult/Census model](https://gomlx.github.io/gomlx/notebooks/uci-adult.html)
* [How do KANs learn?](https://gomlx.github.io/gomlx/notebooks/kan_shapes.html)
* [Cifar-10 demo](https://gomlx.github.io/gomlx/notebooks/cifar.html)
* [MNIST demo (library and command-line only)](https://github.com/gomlx/gomlx/tree/main/examples/mnist)
* [Dogs & Cats classifier demo](https://gomlx.github.io/gomlx/notebooks/dogsvscats.html)
* [IMDB Movie Review demo](https://gomlx.github.io/gomlx/notebooks/imdb.html)
* [Diffusion model for Oxford Flowers 102 dataset (generates random flowers)](https://github.com/gomlx/gomlx/blob/main/examples/oxfordflowers102/OxfordFlowers102_Diffusion.ipynb)
* [Flow Matching Study Notebook](https://gomlx.github.io/gomlx/notebooks/flow_matching.html) based on Meta's ["Flow Matching Guide and Code"](https://ai.meta.com/research/publications/flow-matching-guide-and-code/).
* [GNN model for OGBN-MAG (experimental)](https://github.com/gomlx/gomlx/blob/main/examples/ogbnmag/ogbn-mag.ipynb)
* Last, a trivial [synthetic linear model](https://github.com/gomlx/gomlx/blob/main/examples/linear/linear.go), for those curious to see a barebones simple model.
* Neural Style Transfer 10-year Celebration: [see a demo written using GoMLX](https://github.com/janpfeifer/styletransfer/blob/main/demo.ipynb) of the [original paper](https://arxiv.org/abs/1508.06576).
* [Triplet Losses](https://github.com/gomlx/gomlx/blob/main/ml/train/losses/triplet.go): various negative sampling strategies as well as various distance metrics.
* [AlphaZero AI for the game of Hive](https://github.com/janpfeifer/hiveGo/): It uses a trivial GNN to evaluate
  positions on the board. It includes a [WASM demo (runs GoMLX in the browser!)](https://janpfeifer.github.io/hiveGo/www/hive/) and a command-line UI to test your skills!
