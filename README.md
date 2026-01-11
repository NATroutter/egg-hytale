# Hytale Server Egg

![GitHub License](https://img.shields.io/github/license/NATroutter/egg-hytale?style=for-the-badge) ![GitHub Issues](https://img.shields.io/github/issues/NATroutter/egg-hytale?style=for-the-badge)
![GitHub Stars](https://img.shields.io/github/stars/NATroutter/egg-hytale?style=for-the-badge) ![GitHub Forks](https://img.shields.io/github/forks/NATroutter/egg-hytale?style=for-the-badge)

A Pelican Panel egg for hosting Hytale game servers.

## Overview

This egg provides an automated installation and startup configuration for Hytale servers on Pelican Panel. It handles downloading the Hytale server files, setting up the environment, and starting the server with customizable parameters.

**Note**: While designed for Pelican Panel, this egg should work with Pterodactyl Panel as well, though it has not been tested on Pterodactyl.

## Features

- Automated Hytale server installation
- Automatic download of server files from official sources
- Configurable server parameters
- Easy setup and deployment
- Support for custom asset packs
- Backup management
- Multiple authentication modes

## Installation

1. Download the `egg-hytale.json` file from this repository
2. In your Pelican Panel, navigate to **Admin Panel** > **Eggs**
3. Click **Import**
4. Select the downloaded JSON file
5. Configure the egg settings as needed

For Pterodactyl Panel users, the process should be similar, though compatibility is untested.

## Server Configuration

The following variables can be configured:

| Variable | Description | Default |
|----------|-------------|---------|
| `ASSET_PACK` | Assets pack (.zip) that are being send to player | `Assets.zip` |
| `ACCEPT_EARLY_PLUGINS` | Acknowledge that loading early plugins is unsupported and may cause stability issues | `false` |
| `ALLOW_OP` | Do you wish to allow operators or not | `true` |
| `AUTH_MODE` | Authentication mode (authenticated or offline) | `authenticated` |
| `AUTOMATIC_UPDATE` | Update the hytale server automatically | `true` |
| `LEVERAGE_AHEAD_OF_TIME_CACHE` | The server ships with a pre-trained AOT cache (HytaleServer.aot) that improves boot times by skipping JIT warmup | `true` |
| `DISABLE_SENTRY` | Disable Sentry during active plugin development. Hytale uses Sentry to track crashes. Disable it to avoid submitting your development errors | `true` |
| `ENABLE_BACKUPS` | Enable automatic backups | `false` |
| `BACKUP_DIRECTORY` | Directory where backups are saved | `/backup` |
| `BACKUP_FREQUENCY` | Backup interval in minutes | `30` |

### First-Time Authentication

During the first installation, the Hytale downloader will require authentication with your Hytale account. You'll see output similar to this in the console:

```
Please visit the following URL to authenticate:
https://oauth.accounts.hytale.com/oauth2/device/verify?user_code=XXXXXXXX
Or visit the following URL and enter the code:
https://oauth.accounts.hytale.com/oauth2/device/verify
Authorization code: XXXXXXXX
```

**To complete authentication:**
1. Open the provided URL in your web browser
2. Enter the authorization code shown in the console
3. Sign in with your Hytale account credentials
4. Authorize the server to download game files
5. Return to the console - the download will continue automatically

This authentication step is only required during initial setup. Subsequent server starts will not require re-authentication.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Hytale team for the game and server software
- Pelican Panel for the hosting platform
- Community contributors

## Links

- [Hytale Official Website](https://hytale.com/)
- [Pelican Panel](https://pelican.dev/)
- [Pterodactyl Panel](https://pterodactyl.io/) (untested compatibility)
- [Report Issues](https://github.com/NATroutter/egg-hytale/issues)

## Support

If you encounter any issues or have questions:
- Check existing issues for solutions
- Open an issue on GitHub

---

**Note**: This is an unofficial community-created egg and is not officially supported by Hypixel Studios or the Hytale team.
