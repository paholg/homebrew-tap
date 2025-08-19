class Envswitch < Formula
  desc "A simple tool for managing sets of environment variables"
  homepage "https://github.com/paholg/envswitch"
  version "0.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.6/envswitch-aarch64-apple-darwin.tar.xz"
      sha256 "b7ad56025b5037ec9a9a6cff42eb5a1fcc2161b2e7d2a11a5495d56e8d7ddded"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.6/envswitch-x86_64-apple-darwin.tar.xz"
      sha256 "988edfb39655f572df7120827f70c79cdc23b5beb10f2c2b9bd0df6bd9d6ceec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.6/envswitch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2eb7f39d15fa529ca389f9b839552f23e70f7d8c20c809562514f84b22bd1f1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.6/envswitch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7c46f22522a1b647398d5fece0f460d3d8322632b5d1075aab66f9c34eb3feb2"
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
