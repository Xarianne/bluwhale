### Set up MOK for kernel modules and driver signing
These justfiles exist but will not work currently as the required mokutil, sbsigntools and openssl are not installed. As I don't have to sign anything currently I decided to remove these to lighten the image. Xone is very hard to implement at build stage on Kinoite so if that's needed switch to the `ublue-build.sh` instead of using `kinoite-build.sh`.

```bash
ujust setup-mok
```

Creates ~/.mok-keys and, if keys are absent, writes an OpenSSL cnf and generates a long-lived 2048‑bit RSA x509 cert:

    MOK.priv (private key), MOK.der (public cert, DER), MOK.pem (public cert, PEM).

Runs sudo mokutil --import ~/.mok-keys/MOK.der so the key is added to the MOK enrollment list, requiring a reboot to complete.

Prints step‑by‑step instructions for using the shim “MOK manager” UI on next boot to enroll the key and then suggests check-mok and sign-module as follow‑ups.

```bash
ujust check-mok
```

```bash
ujust sign-module
```
- Identify the installed .ko with `modinfo -n <module>` or by path under `/lib/modules/$(uname -r)/`.
- Run sign-module with that path as shown above.

```bash
ujust sign-xone
```
Installs the Xone module after installation (the Xbox Wireless Dongle firmware).
