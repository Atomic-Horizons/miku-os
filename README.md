# MikuOS   [![bluebuild build badge](https://github.com/shinylisan/miku-os/actions/workflows/build.yml/badge.svg)](https://github.com/shinylisan/miku-os/actions/workflows/build.yml)

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on this template.

MikuOS is a learning experiment in image-based distros. We are currently in the experimental stage, focusing on perfecting the image's aesthetics and compatibility. The .iso file is not currently in development.

## Installation

To rebase an existing atomic Fedora installation to the latest MikuOS build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/atomic-horizons/miku-os:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/atomic-horizons/miku-os:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/shinylisan/miku-os
```

✨ If your OS doesn’t spark joy, just add more Miku until it does.