# System completions
if [ -r /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# kubectl
if command -v kubectl >/dev/null; then
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k
fi

# helm
if command -v helm >/dev/null; then
    source <(helm completion bash)
    complete -o default -F __start_helm h
fi