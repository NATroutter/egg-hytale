# Hytale Server Egg

![GitHub License](https://img.shields.io/github/license/NATroutter/egg-hytale?style=for-the-badge) ![GitHub Issues](https://img.shields.io/github/issues/NATroutter/egg-hytale?style=for-the-badge)
![GitHub Stars](https://img.shields.io/github/stars/NATroutter/egg-hytale?style=for-the-badge) ![GitHub Forks](https://img.shields.io/github/forks/NATroutter/egg-hytale?style=for-the-badge)

Panel eggs for hosting Hytale game servers on both Pelican and Pterodactyl panels.

> [!IMPORTANT]
> ## Support
>
> **We provide active and fast support for this project!**
>
> If you encounter any issues or have questions, please don't hesitate to ask. We strive to respond and resolve issues as quickly as possible.
>
>
> **How to get help:**
> 1. **Search Existing Issues:** Check the [GitHub Issues](https://github.com/NATroutter/egg-hytale/issues) to see if your problem has already been reported or solved.
> 2. **Open a New Issue:** If you can't find a solution, [open a new issue](https://github.com/NATroutter/egg-hytale/issues/new/choose).
>
> ***Please Note:** We are only humans and unfortunately we have to sleep and have lives outside of this project. Support is offered within a humanly possible timeframe, so please be patient.*

## Overview

This egg provides an automated installation and startup configuration for Hytale servers. It handles downloading the Hytale server files, setting up the environment, and starting the server with customizable parameters.

Both Pelican Panel and Pterodactyl Panel are fully supported with dedicated egg files for each platform.

## Features

- Automated Hytale server installation and updates
- Multi-architecture support (x86_64 & ARM64)
- Automatic `hytale-sourcequery` plugin installation (Optional)
- Built-in server validation tools (World, Assets, Prefabs)
- Performance optimizations via AOT Cache support
- Configurable server parameters and JVM arguments
- Integrated backup management system
- Multiple authentication modes (Standard & GSP)
- Support for custom asset packs

## System Requirements

| Component | Minimum | Recommended |
| --------- | ------- | ------------|
| RAM       | 8 GB    | 16 GB+      |
| CPU       | Intel Core i5-7500 (or equivalent), AMD Ryzen 3 1200 (or equivalent) | Intel Core i5-10400 (or equivalent), AMD Ryzen 5 3600 (or equivalent) |
| Storage   | 10 GB   | 20 GB+      |

## Ports

| Port | Protocol | Description |
| ---- | -------- | ----------- |
| 5520 | UDP | Game Server Port (Default) |
| 5521 | TCP | SourceQuery (Optional) |


## Installation

### Pelican Panel

1. Download the [egg-hytale.pelican.json](egg-hytale.pelican.json) file from this repository
2. In your Pelican Panel, navigate to **Admin Panel** > **Eggs**
3. Click **Import**
4. Select the downloaded JSON file and click **Submit**

### Pterodactyl Panel

1. Download the [egg-hytale.pterodactyl.json](egg-hytale.pterodactyl.json) file from this repository
2. In your Pterodactyl Panel, navigate to **Admin Panel** > **Nests**
3. Select or create a nest for the egg
4. Click **Import Egg**
5. Select the downloaded JSON file and click **import**

## Updating the Egg

When a new version of the egg is released, follow these steps to update:

### Pelican Panel

1. Download the latest [egg-hytale.pelican.json](egg-hytale.pelican.json) file from this repository
2. In your Pelican Panel, navigate to **Admin Panel** > **Eggs**
3. Click **Import** on top right
4. Select the downloaded JSON file and click **Submit**
5. You are done!

> **Need help?** Watch the [Pelican Update Tutorial](https://www.youtube.com/watch?v=V8NPn6ZxezY) for a step-by-step guide.

### Pterodactyl Panel

1. Download the latest [egg-hytale.pterodactyl.json](egg-hytale.pterodactyl.json) file from this repository
2. In your Pterodactyl Panel, navigate to **Admin Panel** > **Nests**
3. Click on the nest where hytale egg is imported
4. Click on the hytale egg to open it
5. On top of the page there update egg section where you can select the new egg Click **Update Egg**
6. You are done!

> **Need help?** Watch the [Pterodactyl Update Tutorial](https://www.youtube.com/watch?v=rtptzLBfZ24) for a step-by-step guide.

## Server Configuration

The following options can be configured:

| Option | Description | Default |
| ---------- | ------------- | --------- |
| `Game Profile (username)` | Hytale profile username for server authentication. Visit [accounts.hytale.com](https://accounts.hytale.com/) → Game Profiles to find your username. Leave empty to use first profile. | (empty) |
| `Asset Pack` | Assets pack (.zip) that are being send to player | `Assets.zip` |
| `Accept Early Plugins` | Acknowledge that loading early plugins is unsupported and may cause stability issues | `false` |
| `Allow Operators` | Do you wish to allow operators or not | `true` |
| `Auth Mode` | Authentication mode (authenticated or offline) | `authenticated` |
| `Automatic Update` | Update the hytale server automatically | `true` |
| `Boot Commands` | A list of commands to run when the server boots. | (empty) |
| `Enforce Permissions` | Enforce correct file permissions on startup. This may increase startup time. | `false` |
| `Event Debug` | Enables detailed debug logging for the internal event system. | `false` |
| `Force Network Flush` | Forces the network buffer to flush immediately. Can help with latency debugging. | `false` |
| `JVM Arguments` | Additional Java Virtual Machine arguments for advanced configuration. | See egg config |
| `Leverage Ahead-Of-Time Cache` | The server ships with a pre-trained AOT cache (HytaleServer.aot) that improves boot times by skipping JIT warmup | `true` |
| `Disable Sentry Crash Reporting` | Disable Sentry during active plugin development. Hytale uses Sentry to track crashes. Disable it to avoid submitting your development errors | `true` |
| `Enable Backups` | Enable automatic backups | `false` |
| `Backup Frequency` | Backup interval in minutes | `30` |
| `Maximum Backups` | The maximum number of backups to retain. Older backups will be deleted when this limit is reached. | `5` |
| `Patchline` | What release channel you want to use | `release` |
| `Persistent Authentication` | Enables caching of authentication tokens. This prevents the need to re-authenticate via the web browser on every server restart. | `ENABLED` |
| `Memory overhead` | The amount of RAM (in MB) kept aside for the system so the server doesn’t use everything. Java will get the rest. | `0` |
| `Logger Level` | Sets the logging level for specific components. Use a comma-separated list in the format LoggerName:LEVEL (for example, com.example:INFO) to control how much detail is logged. | `empty` |
| `Trim Log Padding` | Collapses excessive spacing in log lines (for example between the level and component tag) to improve console readability. | `false` |
| `Source Query Support` | Automatically installs the Hytale Source Query plugin, allowing external services to query server status. | `false` |
| `Validate Assets` | Causes the server to exit with an error code if assets are invalid. Leave empty to skip validation. | `false` |
| `Validate prefabs` | Forces the server to stop and exit with an error if any specified prefab types are invalid. Provide a comma-separated list of prefab categories (e.g. PHYSICS,BLOCKS,BLOCK_STATES,ENTITIES,BLOCK_FILLER) to check. Leave empty to skip validation. | `0` |
| `Validate world generation` | Causes the server to exit with an error code if world gen is invalid. Leave empty to skip validation. | `false` |

### First-Time Authentication

During the first start, the Hytale downloader will require authentication with your Hytale account. You'll see output similar to this in the console:

> [!CAUTION]
> **You must have purchased Hytale on the account you are using to authenticate.**

```txt
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
- Pelican Panel and Pterodactyl Panel for the hosting platforms
- [physgun-com](https://github.com/physgun-com) for the [hytale-sourcequery](https://github.com/physgun-com/hytale-sourcequery) plugin
- Community contributors

## Links

- [Hytale Official Website](https://hytale.com/)
- [Pelican Panel](https://pelican.dev/)
- [Pterodactyl Panel](https://pterodactyl.io/)
- [Report Issues](https://github.com/NATroutter/egg-hytale/issues)

---

**Note**: This is an unofficial community-created egg and is not officially supported by Hypixel Studios or the Hytale team.
