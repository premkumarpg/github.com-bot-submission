# Findings — Part 4 debug lab

**Important:** the four causes below are established from the supplied manifests. The Symptom sections intentionally require real output from the candidate's own cluster; do not submit invented output. Defects 5 and 6 must be established from the cluster evidence tomorrow.

## Defect 1 — Gateway backend URL

**Symptom** (paste actual output from your cluster):

PASTE ACTUAL `./scenario.sh verify` / gateway evidence here.

**Cause:** `gateway.env.BACKEND_URL` points at `backend.default.svc`, while the backend Service is installed in `debug-lab`.

**Fix:** Changed the URL to `http://backend.debug-lab.svc:8080`, so the gateway resolves the Service in the lab namespace.

**How I found it:** Inspect the gateway environment and compare its hostname with the namespace in which `scenario.sh` installs the release. Confirm with cluster DNS/gateway `/status` output.

## Defect 2 — Reporter RBAC binding

**Symptom:**

PASTE ACTUAL `kubectl auth can-i ...` and/or reporter evidence here.

**Cause:** The RoleBinding grants the `reporter-read` Role to the `default` ServiceAccount, but the reporter Deployment explicitly runs as the `reporter` ServiceAccount.

**Fix:** Changed the RoleBinding subject from `default` to `reporter` in the same namespace.

**How I found it:** Compare `serviceAccountName` in the reporter Deployment with the RoleBinding subject, then verify with `kubectl auth can-i list pods -n debug-lab --as=system:serviceaccount:debug-lab:reporter`.

## Defect 3 — Migration Job restart policy

**Symptom:**

PASTE ACTUAL Helm/Kubernetes Job output here.

**Cause:** The Job pod uses `restartPolicy: Always`; Jobs require `Never` or `OnFailure`.

**Fix:** Changed the Job pod restart policy to `Never`.

**How I found it:** Inspect the Job install error/status and then the rendered `migrate-job.yaml`; the pod template's restart policy is invalid for a Job.

## Defect 4 — Metrics CPU exceeds the LimitRange

**Symptom:**

PASTE ACTUAL metrics admission/status output here.

**Cause:** Metrics requests 2 CPU and limits 4 CPU, but `cluster-state/limits.yaml` sets a per-container maximum of 1 CPU.

**Fix:** Reduced the metrics request to 500m and limit to 1 CPU, staying below the namespace maximum while retaining explicit resources.

**How I found it:** Compare the metrics resource values with the namespace LimitRange and confirm the resulting pod/admission status with `kubectl describe` and events.

## Defect 5

**Symptom:**

PASTE REAL CLUSTER OUTPUT HERE.

**Cause:** Determine from the cluster evidence; do not guess.

**Fix:** Record the minimal chart change and why it fixes the observed root cause.

**How I found it:** Record the exact diagnostic commands and reasoning.

## Defect 6

**Symptom:**

PASTE REAL CLUSTER OUTPUT HERE.

**Cause:** Determine from the cluster evidence; do not guess.

**Fix:** Record the minimal chart change and why it fixes the observed root cause.

**How I found it:** Record the exact diagnostic commands and reasoning.

## Evidence rule

Before investigating, run `script -q part4-session.log` and then execute the investigation commands. The final `FINDINGS.md` must contain actual output from that session.
