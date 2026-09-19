# Tomorrow: final verification and submission checklist

## 1. Extract the draft and open a terminal

```bash
cd enterprise-bot-submission
```

## 2. Check tools

```bash
docker --version
kind --version
kubectl version --client
helm version
```

## 3. Run the main setup twice

```bash
./setup.sh
./setup.sh
```

Both runs must finish successfully.

## 4. Verify the service

```bash
kubectl -n demo get deploy,pods,svc,ingress
curl --resolve demo.local:80:127.0.0.1 http://demo.local/
curl --resolve demo.local:80:127.0.0.1 http://demo.local/healthz
```

## 5. Run the Part 4 lab and start recording BEFORE investigation

```bash
cd lab
script -q part4-session.log
./scenario.sh up
./scenario.sh verify
```

Then investigate failures with commands such as:

```bash
kubectl -n debug-lab get pods,deploy,jobs,events
kubectl -n debug-lab describe pod <problem-pod>
kubectl -n debug-lab logs <problem-pod>
kubectl auth can-i list pods -n debug-lab --as=system:serviceaccount:debug-lab:reporter
helm -n debug-lab get manifest debug-lab
```

Fix the remaining defects in `lab/broken-chart/`, rerun:

```bash
./scenario.sh up
./scenario.sh verify
```

Keep investigating until it says `ALL GREEN`.

Exit the recording with Ctrl-D. Then update `FINDINGS.md` with the REAL output from this session. Never invent output.

## 6. Review the final files

Top level must contain:

```text
setup.sh
README.md
ANSWERS.md
service/
chart/
lab/
```

`lab/cluster-state/` and `lab/scenario.sh` must remain unchanged from the handout.

## 7. Create a public Git repository and push the folder

Use your GitHub/GitLab account. Then from the repository folder:

```bash
git init
git add .
git commit -m "initial DevOps take-home implementation"
git branch -M main
git remote add origin <YOUR_PUBLIC_REPOSITORY_URL>
git push -u origin main
```

Make sure the repository is public and the submitted link opens without login.

## 8. Final check

Open the public repository in a browser and verify that `README.md`, `ANSWERS.md`, `service/`, `chart/`, `lab/FINDINGS.md`, and `lab/part4-session.log` are present.
