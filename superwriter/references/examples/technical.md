# Technical: example

To rotate the signing key:

1. Generate a new key pair: `keytool -genkeypair -alias signing-2 -keystore release.jks`.
2. Add the new public key to `config/trusted-keys.json`.
3. Deploy the config change and wait for every node to report `keys_loaded: 2`.
4. Update the build to sign with `signing-2`.
5. After one full release cycle, remove the old key.

**Shows:** verb-first imperative steps; the condition ("after one full release cycle") before the action; concept kept out of the procedure.
