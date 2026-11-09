#!/usr/bin/env bash
set -e

REPO="FilebrowserNext/filebrowserNEXT"
echo "Checking latest release of ${REPO}..."

LATEST_TAG=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest" | python3 -c "import sys, json; print(json.load(sys.stdin).get('tag_name', ''))")

if [[ -z "${LATEST_TAG}" ]]; then
  echo "Error: unable to determine latest release tag."
  exit 1
fi

VERSION="${LATEST_TAG#v}"
echo "Latest release: ${LATEST_TAG} (version: ${VERSION})"

CURRENT_VERSION=$(grep -E '^\s*version\s+"' Formula/filebrowser.rb | head -n1 | sed -E 's/.*version "([^"]+)".*/\1/')
echo "Current Homebrew tap version: ${CURRENT_VERSION}"

if [[ "${CURRENT_VERSION}" == "${VERSION}" ]]; then
  echo "Homebrew tap is already up to date with version ${VERSION}."
  exit 0
fi

echo "Fetching checksums.txt from release ${LATEST_TAG}..."
CHECKSUMS_URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/checksums.txt"
CHECKSUMS=$(curl -fsSL "${CHECKSUMS_URL}")

DARWIN_AMD64_SHA=$(echo "${CHECKSUMS}" | grep "filebrowser-darwin-amd64.tar.gz" | awk '{print $1}')
DARWIN_ARM64_SHA=$(echo "${CHECKSUMS}" | grep "filebrowser-darwin-arm64.tar.gz" | awk '{print $1}')
LINUX_AMD64_SHA=$(echo "${CHECKSUMS}" | grep "filebrowser-linux-amd64.tar.gz" | awk '{print $1}')
LINUX_ARM64_SHA=$(echo "${CHECKSUMS}" | grep "filebrowser-linux-arm64.tar.gz" | awk '{print $1}')

for sha in "${DARWIN_AMD64_SHA}" "${DARWIN_ARM64_SHA}" "${LINUX_AMD64_SHA}" "${LINUX_ARM64_SHA}"; do
  if [[ ${#sha} -ne 64 ]]; then
    echo "Error: invalid SHA256 length for one or more archives: ${sha}"
    exit 1
  fi
done

echo "Updating Formula/filebrowser.rb..."
cat << EOF > Formula/filebrowser.rb
class Filebrowser < Formula
  desc "Modern, secure, and self-hosted web-based file manager"
  homepage "https://github.com/FilebrowserNext/filebrowserNEXT"
  version "${VERSION}"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-amd64.tar.gz"
      sha256 "${DARWIN_AMD64_SHA}"
    else
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-arm64.tar.gz"
      sha256 "${DARWIN_ARM64_SHA}"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-amd64.tar.gz"
      sha256 "${LINUX_AMD64_SHA}"
    else
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-arm64.tar.gz"
      sha256 "${LINUX_ARM64_SHA}"
    end
  end

  def install
    bin.install "filebrowser"
  end

  test do
    system "#{bin}/filebrowser", "version"
  end
end
EOF

echo "Updating Casks/filebrowser.rb..."
cat << EOF > Casks/filebrowser.rb
cask "filebrowser" do
  version "${VERSION}"

  on_macos do
    on_intel do
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-amd64.tar.gz"
      sha256 "${DARWIN_AMD64_SHA}"
    end
    on_arm do
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-arm64.tar.gz"
      sha256 "${DARWIN_ARM64_SHA}"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-amd64.tar.gz"
      sha256 "${LINUX_AMD64_SHA}"
    end
    on_arm do
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-arm64.tar.gz"
      sha256 "${LINUX_ARM64_SHA}"
    end
  end

  name "filebrowser"
  desc "Modern, secure, and self-hosted web file manager"
  homepage "https://github.com/FilebrowserNext/filebrowserNEXT"

  binary "filebrowser"

  postflight do
    if system_command("/usr/bin/xattr", args: ["-h"]).exit_status == 0
      system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{staged_path}/filebrowser"]
    end
  end
end
EOF

echo "Formula and Casks updated to version ${VERSION}."
