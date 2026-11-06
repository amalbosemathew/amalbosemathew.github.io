# Encryption at rest (Layer 1)

The site **source** is stored in this repository as encrypted blobs under
`secure/*.age`. Plaintext HTML/CSS/JS is **not** committed. The site is
decrypted at deploy time by GitHub Actions and published to GitHub Pages.

## What this protects (and what it does not)

- **Protected:** reading the source by browsing this GitHub repository. The repo
  contains ciphertext only.
- **NOT protected:** the live website. A public site must send runnable
  HTML/JS/CSS to every visitor's browser, so anyone visiting
  `https://amalbosemathew.github.io/` can still view-source and read it.
  Encryption at rest hides the repo source, not the deployed page.

## Tools

- [age](https://github.com/FiloSottile/age) v1.3.2 — file encryption.
- Local binaries live in `tools/age/` (git-ignored). CI installs its own `age`.

## Keys

- **Private key:** `~/.age/portfolio-key.txt` (line starting `AGE-SECRET-KEY-1...`).
  Lives only on your machine and in the GitHub Actions secret `AGE_PRIVATE_KEY`.
  **Never commit it.**
- **Public key (recipient):** stored in `age-recipients.txt` (safe to commit).
  Used to encrypt. Cannot decrypt.

Current recipient:
`age1czmf75hddh8wl7l3p7l6qp2y5jxwpeyyyemyxfszgq0vg506uveqr6fl77`

## Daily workflow

Edit content:

```powershell
# 1. Decrypt into the repo root so you can edit/run the site
powershell -ExecutionPolicy Bypass -File scripts/decrypt.ps1

# 2. Edit index.html / data.js / styles.css etc. as usual

# 3. Re-encrypt before committing
powershell -ExecutionPolicy Bypass -File scripts/encrypt.ps1

# 4. Commit ONLY the encrypted blobs (plaintext is git-ignored)
git add secure age-recipients.txt
git commit -m "Update content"
git push
```

Pushing to `main` triggers `.github/workflows/deploy.yml`, which decrypts and
deploys to Pages.

## One-time GitHub setup

1. **Add the private key as a secret**
   - Repo → Settings → Secrets and variables → Actions → New repository secret
   - Name: `AGE_PRIVATE_KEY`
   - Value: the full contents of `~/.age/portfolio-key.txt`
     (include the `AGE-SECRET-KEY-1...` line).

2. **Set Pages source to GitHub Actions**
   - Repo → Settings → Pages → Build and deployment → Source: **GitHub Actions**.

## Rotating the key

1. `tools/age/age-keygen.exe -o ~/.age/portfolio-key.txt` (overwrites).
2. Put the new public key in `age-recipients.txt`.
3. Re-run `scripts/encrypt.ps1`, commit `secure/` + `age-recipients.txt`.
4. Update the `AGE_PRIVATE_KEY` Actions secret with the new private key.

## Recovery

If you lose the private key, the `secure/*.age` blobs **cannot be decrypted** —
there is no backdoor. Keep a secure backup of `~/.age/portfolio-key.txt`
(password manager or offline storage).
