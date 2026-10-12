# Toiwet Farmers Group

Toiwet is a Flutter application for farmer, sheep, and veterinary workflows. Its login/register screen connects to the Flask API in `../backend`; the API creates an account when an email is new and authenticates it on later logins.

## Prerequisites

- Flutter SDK and a supported Flutter development target (Chrome for the web steps below)
- Docker Desktop with Docker Compose, for the backend and PostgreSQL

## Start the backend

From the repository root, configure and start the Flask API and database:

```powershell
Set-Location .\backend
Copy-Item .env.docker .env
```

Edit `backend/.env` before deployment. Set a strong `DB_PASSWORD` and `FLASK_SECRET_KEY`. The sample allows browser origins on ports 3000 and 8080, which are used in the local commands below.

```powershell
docker compose up --build -d
```

The API is available at `http://localhost:5000`. To stop the backend and database, run `docker compose down` from `backend/`.

## Run the Flutter web app

From the repository root:

```powershell
Set-Location .\toiwet_app
flutter pub get
flutter run -d chrome --web-port 3000 --dart-define="API_BASE_URL=http://localhost:5000"
```

`API_BASE_URL` is the backend origin, without the API route. The app appends `/api/register_or_login` for authentication. Supply it on every run/build that needs a backend URL; there is intentionally no localhost fallback.

For a different target, set the URL to an address reachable from that target. For example, an Android emulator usually reaches the host machine at `http://10.0.2.2:5000`; a physical device needs the host machine's LAN address and a reachable backend. For web, add the frontend's exact origin to the backend's comma-separated `ALLOWED_ORIGINS` in `backend/.env` if it is not already allowed.

## Build and run the web container

The production web image is built from `.devcontainer/Dockerfile`. Pass the API origin at build time:

```powershell
docker build -f .devcontainer/Dockerfile --build-arg API_BASE_URL=https://api.example.com -t toiwet-web .
docker run --rm -p 8080:80 toiwet-web
```

Replace `https://api.example.com` with the deployed API origin. Configure the backend's `ALLOWED_ORIGINS` to include the origin serving this web app. Use HTTPS for deployed environments.

The URL supplied with `--dart-define` or `--build-arg` is compiled into the client and is visible to users. Do not put passwords, tokens, or other secrets in it.
