default: ornith qwen3.6 qwen3.8

ornith: .ornith
.ornith:
	env OLLAMA_HOST=192.168.4.33:11434 ollama create cline-ornith:9b-bf16 -f ornith/Modelfile

qwen3.6: .qwen3.6
.qwen3.6:
	env OLLAMA_HOST=192.168.4.33:11434 ollama create cline-qwen3.6:35b -f qwen3.6/Modelfile

qwen3.8: .qwen3.8
.qwen3.8:
	env OLLAMA_HOST=192.168.4.33:11434 ollama create cline-qwen3.8:27b -f qwen3.8/Modelfile
