# Answers

## Q1 — Migrating from ingress-nginx to Gateway API with no downtime

- Inventory the ~40 existing Ingress objects, annotations, TLS secrets, controllers, paths, rewrites, authentication, and any nginx-specific behaviour. Identify application owners and define rollback criteria.
- Install a Gateway API implementation alongside ingress-nginx. Keep the existing Ingress controller serving production traffic while the new Gateway/HTTPRoute resources are introduced.
- Start with one low-risk service. Translate its Ingress into Gateway and HTTPRoute resources, validate routing, TLS, headers, timeouts, redirects, and observability, then expand in small batches.
- Run both paths in parallel and use health checks plus controlled traffic shifting where the chosen Gateway implementation supports it. Avoid changing DNS or the existing controller until the new route is proven.
- Common breakages are nginx-specific annotations that have no direct Gateway API equivalent, rewrite/regex differences, TLS configuration differences, default-backend behaviour, header handling, and controller-specific timeouts.
- During each batch, compare response codes, latency, logs, and application metrics. Keep the old Ingress definitions available for fast rollback.
- After all services are migrated and the observation window is clean, remove old Ingress resources/controller dependencies in a separate change.
