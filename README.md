# Caddy-Builder

Automated build system for Caddy web server with custom plugins using GitHub Actions.

## Overview

This repository automatically builds Caddy binaries with your desired plugins for multiple Linux platforms using [xcaddy](https://github.com/caddyserver/xcaddy). It includes:

- ✅ Automated builds for all major Linux platforms (amd64, arm64, armv7, armv6, 386)
- ✅ Configurable plugin management via `plugins.txt`
- ✅ Automatic update checking for Caddy and plugins
- ✅ Built-in testing to verify binary integrity
- ✅ Automatic release creation with built binaries

## Quick Start

### 1. Configure Plugins

Edit the `plugins.txt` file to add your desired Caddy plugins. Add one plugin per line:

```txt
github.com/caddy-dns/cloudflare
github.com/mholt/caddy-l4
github.com/greenpau/caddy-security
```

Lines starting with `#` are treated as comments and ignored.

### 2. Trigger a Build

Builds are triggered automatically in the following scenarios:

- **Push to main/master branch**: When `plugins.txt` or workflow files are modified
- **Weekly schedule**: Every Monday at 00:00 UTC
- **Manual trigger**: Via GitHub Actions "Run workflow" button
- **Automatic updates**: When new Caddy version is detected (checked daily)

### 3. Download Binaries

After a successful build:

1. Go to the **Actions** tab in GitHub
2. Click on the latest successful workflow run
3. Download the artifacts for your platform
4. Or check the **Releases** page for versioned releases

## Supported Platforms

- Linux amd64 (x86_64)
- Linux arm64 (aarch64)
- Linux armv7 (32-bit ARM)
- Linux armv6 (Raspberry Pi, etc.)
- Linux 386 (32-bit x86)

## Workflows

### Build Workflow (`build-caddy.yml`)

Builds Caddy with specified plugins for all Linux platforms.

- Reads plugins from `plugins.txt`
- Builds binaries using xcaddy
- Tests binary integrity
- Uploads artifacts
- Creates releases on push to main/master

### Update Checker (`check-updates.yml`)

Automatically checks for Caddy and plugin updates.

- Runs daily at 06:00 UTC
- Checks GitHub for latest Caddy release
- Monitors plugin repositories for updates
- Triggers builds when updates are detected
- Maintains version tracking

## Plugin Configuration

### Adding Plugins

To add a plugin, edit `plugins.txt` and add the plugin's import path:

```txt
# DNS providers
github.com/caddy-dns/cloudflare

# Layer 4 support
github.com/mholt/caddy-l4

# Security features
github.com/greenpau/caddy-security
```

### Popular Plugins

Some commonly used Caddy plugins:

- **DNS Providers**: `github.com/caddy-dns/*` (cloudflare, route53, etc.)
- **Layer 4**: `github.com/mholt/caddy-l4` - TCP/UDP proxy
- **Security**: `github.com/greenpau/caddy-security` - Authentication portal
- **Transform Encoder**: `github.com/caddyserver/transform-encoder`
- **Replace Response**: `github.com/caddyserver/replace-response`

Find more plugins: https://caddyserver.com/download

## Testing

Each build includes automated tests:

1. **Binary verification**: Confirms binary format and architecture
2. **Execution test**: Runs `caddy version` and `caddy list-modules`
3. **Module validation**: Ensures custom plugins are loaded

## Manual Build

To build locally using xcaddy:

```bash
# Install xcaddy
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build with plugins from plugins.txt
xcaddy build \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/mholt/caddy-l4
```

## Configuration

### Customizing Build Frequency

Edit the cron schedule in `.github/workflows/check-updates.yml`:

```yaml
schedule:
  - cron: '0 6 * * *'  # Daily at 06:00 UTC
```

### Adding More Platforms

To add Windows or macOS support, edit the matrix in `.github/workflows/build-caddy.yml`:

```yaml
matrix:
  os: [linux, darwin, windows]
  arch: [amd64, arm64]
```

## Troubleshooting

### Build Fails

1. Check the Actions log for specific error messages
2. Verify plugin paths in `plugins.txt` are correct
3. Ensure plugins are compatible with the latest Caddy version

### Plugin Not Loading

1. Verify the plugin path in `plugins.txt`
2. Check if the plugin is compatible with current Caddy version
3. Review the build logs for compilation errors

## Contributing

Feel free to open issues or submit pull requests for improvements.

## License

See [LICENSE](LICENSE) file for details.

## Related Projects

- [Caddy](https://github.com/caddyserver/caddy) - The web server
- [xcaddy](https://github.com/caddyserver/xcaddy) - Build tool
- [Caddy Plugins](https://caddyserver.com/download) - Plugin directory
