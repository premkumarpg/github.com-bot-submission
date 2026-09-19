#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLUSTER=demo
NAMESPACE=demo
IMAGE="enterprise-bot/demo-service:0.1.0"

command -v docker >/dev/null || { echo "docker is required" >&2; exit 1; }
command -v kind >/dev/null || { echo "kind is required" >&2; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required" >&2; exit 1; }
command -v helm >/dev/null || { echo "helm is required" >&2; exit 1; }

if ! kind get clusters | grep -qx "$CLUSTER"; then
  cat > /tmp/kind-demo-config.yaml <<'EOF'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF

  kind create cluster --name "$CLUSTER" --config /tmp/kind-demo-config.yaml
fi

kubectl cluster-info --context "kind-$CLUSTER" >/dev/null

# Install/reconcile ingress-nginx. The manifest is safe to apply repeatedly.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/kind/deploy.yaml
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller --timeout=180s

docker build -t "$IMAGE" "$ROOT_DIR/service"
kind load docker-image "$IMAGE" --name "$CLUSTER"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install demo "$ROOT_DIR/chart" \
  --namespace "$NAMESPACE" \
  --set image.repository=enterprise-bot/demo-service \
  --set image.tag=0.1.0 \
  --wait \
  --timeout 180s

echo
helm status demo -n "$NAMESPACE"

echo
cat <<EOF
Setup complete. Verify with:
  kubectl -n $NAMESPACE get deploy,pods,svc,ingress
  curl --resolve demo.local:80:127.0.0.1 http://demo.local/
  curl --resolve demo.local:80:127.0.0.1 http://demo.local/healthz
EOF
