class Filebrowser < Formula
  desc "Modern, secure, and self-hosted web-based file manager"
  homepage "https://github.com/FilebrowserNext/filebrowserNEXT"
  version "3.0.1-next"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-amd64.tar.gz"
      sha256 "29635005df501fa20491bc48cb5de0e035b25622354b2d3001acd2a2e8ab3960"
    else
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-darwin-arm64.tar.gz"
      sha256 "b81e9f23ee7d50b5b3f4f35a8b4b233ec5680d1fe34ba8bea213ed33f641bc29"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-amd64.tar.gz"
      sha256 "6a631d1c95be3ffdda73733cb6190f285aae9a238ecc448f053ca902e42cedd3"
    else
      url "https://github.com/FilebrowserNext/filebrowserNEXT/releases/download/v#{version}/filebrowser-linux-arm64.tar.gz"
      sha256 "3fca5c79a369e96e21af4fc85a5cb13950a3d4f768c001770fd5b0ab92c50821"
    end
  end

  def install
    bin.install "filebrowser"
  end

  test do
    system "#{bin}/filebrowser", "version"
  end
end
