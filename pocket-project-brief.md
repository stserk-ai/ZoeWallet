# Pocket — Teen Wallet App: Project Brief

## What it is
A personal finance app for my 14-year-old daughter (iPhone 11, iOS 16.4+) to track
allowance, savings goals, and chores. Built as a web app first, no native app store
needed for now.

## Current state
A working prototype already exists: `teen-wallet.html`
- Single-file React app (React 18 + Babel via CDN, no build step)
- Uses `window.storage` (get/set with `shared: true`) to persist data
- Features already built:
  - Balance + transaction history (deposits/spending)
  - Savings goals with progress bar ("jar fill") and "add to goal"
  - Chores checklist that pays out automatically when checked
  - Parent view toggle (unlocks "add funds"; daughter's view can only log
    spending or earn via chores)

## What I want to do next (in this order)
1. **Test locally** — open and click through the current prototype, refine
   features/design as needed
2. **Host it** — get it on a real URL (e.g. GitHub Pages, Vercel, Netlify —
   something free and simple) since "Add to Home Screen" and push notifications
   require a real hosted URL, not a local file
3. **Test as a web app on my Android phone first** (parent testing) — via
   Chrome "Add to Home Screen," no APK needed for this step
4. **Test on her iPhone 11** — same hosted URL, Add to Home Screen via Safari
   share sheet, then test notifications

## Notifications needed
- **Chore reminders** — e.g. daily at a set time (local/scheduled notification)
- **Goal milestones** — celebrate when a savings goal hits 100% (can be purely
  in-app, doesn't need push)
- Confirmed iOS 16.4+ supports home-screen web app push notifications, but only
  if the app was added to the home screen and opened from there (not from a
  regular Safari tab)

## Explicitly deferred / not needed right now
- Native iOS app via Apple Developer account / TestFlight — decided against for
  now due to $99/year cost and 90-day TestFlight renewal cycle
- Android APK — not needed since she has an iPhone, not Android (I have Android,
  for my own parent-side testing only, and Add to Home Screen via Chrome covers
  that without needing an APK either)

## Open questions to think through together
- Should "Parent view" be PIN-protected, or is a simple toggle fine?
- Pre-fill default chores/goals, or should she start from scratch?
- Whether to add a "request money" feature so she can ask for funds instead of
  me just adding them directly
