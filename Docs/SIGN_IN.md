# How signing in works in Khylo

This page describes how signing in works on every Khylo app.

## The four ways

1. **Password.** Every app: pick or enter the server, then username and password.
2. **Quick Connect (the new device shows a six-digit code).** For devices where typing is a pain, like TVs. The new device shows a code and a QR code. Someone already signed in approves it:
   - on the iPhone: Account → **Add a Device**, then type the six digits or scan the TV's QR code;
   - in the web app: the Quick Connect page.

   The QR code is `{server}/#/quickconnect?code={code}`, so a phone's camera opens the web app's Quick Connect page with the code filled in. Only show a code the server gave you. If the server can't make one, say so plainly. **Never make one up.**
3. **Scan to Sign In (a device that's already signed in shows a QR code).** For signing in a new phone. A signed-in device opens **Sign In Another Device**, which shows a one-time QR code that lasts 5 minutes. On the new phone, pick the server first, then tap **Scan to Sign In** on the sign-in screen and scan it. The server API is `/Khylo/SignInCodes` (make, check, cancel, Redeem).
4. **Already signed in on another Khylo app (iPhone and iPad only).** The Khylo apps on one iPhone (Khylo, Khylo Music and Khylo Manager) share a small private record in a keychain area only Khylo apps can read. An app that isn't signed in reads it, asks the server for a one-time code as that account (the same code Scan to Sign In uses), and signs itself in. Each app gets its own sign-in on the server, so signing out of one doesn't sign out the others. Khylo Manager only does this for an administrator account. If you sign out of an app yourself, that app stays signed out until you sign in again.

## Where each one lives

| App | Signs itself in with | Lets another device in with |
| --- | --- | --- |
| iPhone and iPad | Password; Scan to Sign In (on the sign-in screen, after the server is chosen); signed in by another Khylo app on the same device | Add a Device (approves a Quick Connect code); Sign In Another Device (shows a QR code) |
| Android phone | Password; Quick Connect (shows a code) | To match the iPhone later |
| Android TV | Password; Quick Connect (shows a code) | Sign in another device (shows a QR code) |
| Roku | Password; Quick Connect (shows a code) | Sign in another device (shows a QR code; profile circle, then Sign in another device) |
| Web | Password; the `#/signin?code=` link from a scanned QR | Quick Connect page (types a code); Sign in another device (shows a QR code) |

The iPhone doesn't show its own Quick Connect code. Scan to Sign In does that job.

## Rules for every app

- Every request to the server, including before sign-in, sends the normal `Authorization: MediaBrowser Client=…, Device=…, DeviceId=…, Version=…` header. Without it the server turns down Quick Connect and Scan to Sign In.
- Use plain messages for failures: the code ran out, the code is from a different server, too many tries, Quick Connect is turned off, the server can't be reached.
- Use only real addresses, menu names and codes. No placeholders.
