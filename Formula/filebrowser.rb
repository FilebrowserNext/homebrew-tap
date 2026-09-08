class Filebrowser < Formula
  desc "Modern, secure, and self-hosted web-based file manager"
  homepage "https://github.com/FilebrowserNext/filebrowserNEXT"
  version "3.0.0-next"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-amd64.tar.gz"
      sha256 "8ec45ab1682137afa281d0fc39451c3b54956603056f986a19367cb927e9e8c2"
    else
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-arm64.tar.gz"
      sha256 "859614f13e29a7231ec2e07949d6f053b2d6637c3fc3690a2fcf27d41a2a1ad9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-amd64.tar.gz"
      sha256 "17a51c2b8fe2eaf88ca4f7a80bd2f2b2e7fe968961bbeb8569a86942696e08b0"
    else
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-arm64.tar.gz"
      sha256 "df0b301ffad4535877c2a1baadecf6780c38275b58e830141de26f95efab6ef1"
    end
  end

  def install
    bin.install "filebrowser"
  end

  test do
    system "#{bin}/filebrowser", "version"
  end
end
