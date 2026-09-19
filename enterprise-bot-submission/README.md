# Enterprise Bot DevOps Take-Home

This repository implements the six requested parts of the exercise.

## Prerequisites

Docker, kind, kubectl, and Helm.

## Run

```bash
./setup.sh
```

The script creates/reuses the `demo` kind cluster, installs ingress-nginx, builds and loads the image, and installs Helm release `demo` in namespace `demo`. It is intended to be safe to run repeatedly.

## Verify

```bash
kubectl -n demo get deploy,pods,svc,ingress
curl --resolve demo.local:80:127.0.0.1 http://demo.local/
curl --resolve demo.local:80:127.0.0.1 http://demo.local/healthz
```

The root endpoint returns the configured `APP_NAME`, `VERSION`, and pod hostname.

## Resources

The service requests 50m CPU and 64Mi memory, with limits of 200m CPU and 128Mi memory. These are deliberately modest because the application is a small HTTP service with no CPU-heavy processing or large in-memory workload. Requests provide predictable scheduling while the limits cap accidental resource growth. In a real production deployment I would tune these numbers from CPU/memory telemetry rather than treating them as permanent values.

## Deliberately skipped

I kept the exercise focused on its requested local deployment. I did not add production extras such as persistent storage, external secret management, autoscaling, network policies, a service mesh, or a full CI/CD pipeline. The risk is that these omissions leave security, availability, and operational controls incomplete for a real production service.

## Production-ready follow-ups

- Use a private registry and image signing/scanning.
- Add CI linting, unit/integration tests, and vulnerability scanning.
- Add PodDisruptionBudget, HPA, NetworkPolicy, and stronger security policies where appropriate.
- Manage TLS and secrets through the platform's approved secret-management system.
- Add metrics, tracing, structured logs, alerts, and SLOs.
- Pin and regularly update all base images and controller dependencies.

## How I used AI

I used ChatGPT to help draft the Python service, Dockerfile, Helm templates, setup script, documentation, and to review the static Kubernetes manifests for likely defects. I still need to run the supplied lab locally, capture the real command output, and verify/fix any remaining defects before submitting.

## Part 4

The `lab/` directory preserves the supplied scenario and cluster-state files. The broken chart has been updated for defects that can be established directly from the supplied manifests. `FINDINGS.md` must be completed with real cluster output from `./scenario.sh verify` and the debugging session recording before submission.
