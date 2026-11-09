# Homebrew Tap for File Browser Next

Official [Homebrew](https://brew.sh) tap for [File Browser Next](https://github.com/FilebrowserNext/filebrowserNEXT) on macOS and Linux.

## Installation

### Recommended Method

1. Add and trust the official tap:
```bash
brew tap filebrowsernext/tap
brew trust filebrowsernext/tap
```

2. If you previously had the legacy archived `homebrew/core/filebrowser` installed, remove it first:
```bash
brew uninstall filebrowser
```

3. Install File Browser Next:
```bash
brew install filebrowsernext/tap/filebrowser
```

### Direct Install (One Command)

```bash
brew install filebrowsernext/tap/filebrowser
```

*(If prompted by Homebrew, run `brew trust filebrowsernext/tap` to authorize the tap).*

## Starting the Server

```bash
filebrowser -r /path/to/your/files
```

Open your browser at:
`http://127.0.0.1:8080` (or `http://<your-server-ip>:8080`)

Default credentials: `admin` / `admin`.

## Updating

```bash
brew update
brew upgrade filebrowsernext/tap/filebrowser
```
