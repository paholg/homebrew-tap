class Envswitch < Formula
  desc "A simple tool for managing sets of environment variables"
  homepage "https://github.com/paholg/envswitch"
  version "0.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.5/envswitch-aarch64-apple-darwin.tar.xz"
      sha256 "cf46a4157f573f06ec9e9e5425d0db307a0e438d4ced4419c1f9ed720ddf1699"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.5/envswitch-x86_64-apple-darwin.tar.xz"
      sha256 "b8fb59c71a9d7cd18e2ae36e4735d75a10f1fb0fab851a1e59f0e9f9e0a8a536"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.5/envswitch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dddc78a6801e472a9cde889457585c688466eb941ba3cb3da1ac4b3547b03f41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.5/envswitch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5e6fb8a0b72586aa3ce1bdf7a34f76cd80339b839c6c9b8d889b3f97960998c8"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "envswitch" if OS.mac? && Hardware::CPU.arm?
    bin.install "envswitch" if OS.mac? && Hardware::CPU.intel?
    bin.install "envswitch" if OS.linux? && Hardware::CPU.arm?
    bin.install "envswitch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
