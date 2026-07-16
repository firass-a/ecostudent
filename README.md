# EcoStudent

High-fidelity Flutter prototype for an Algerian campus reverse-vending startup. Students deposit plastic bottles at smart machines, earn points (1 pt = 1 DZD), and cash out via BaridiMob or CCP.

## Run

```bash
flutter pub get
flutter run
```

## Demo login

- Email: `amine.benali@usthb.dz`
- Password: `demo1234`
- OTP (forgot password): any 4+ digits (e.g. `1234`)

## What’s included

- Splash → onboarding → auth (signup / login / OTP reset)
- Home dashboard with points ring, stats, weekly chart
- Scan to deposit (QR + manual machine picker) with success animation
- Wallet + BaridiMob/CCP cash-out flow
- Transaction history (filter / search / swipe)
- Machines map (stub map + list; admin mode can add/edit machines)
- Referral code share
- Notifications, profile, AR/FR/EN + RTL, dark mode

All data is mocked behind repository interfaces in `lib/data/` so a real API can replace the mock layer without touching UI.
