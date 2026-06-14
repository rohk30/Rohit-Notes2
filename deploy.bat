@echo off
echo Building Flutter web...
flutter build web --release
if %errorlevel% neq 0 (
  echo Flutter build failed. Aborting.
  exit /b %errorlevel%
)

echo Deploying to Firebase Hosting...
firebase deploy --only hosting
if %errorlevel% neq 0 (
  echo Firebase deploy failed.
  exit /b %errorlevel%
)

echo Done! Your app is live at https://rohit-notes.web.app
