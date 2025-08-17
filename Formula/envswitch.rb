class Envswitch < Formula
  desc "A simple tool for managing sets of environment variables"
  homepage "https://github.com/paholg/envswitch"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.1/envswitch-aarch64-apple-darwin.tar.xz"
      sha256 "454873997bf280f6c488cd1fd8067c87af981295a75d794789abb5b3be7a8ba4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.1/envswitch-x86_64-apple-darwin.tar.xz"
      sha256 "d6c5d785bdd2a68d2bf52fd347b358f32e0f3f2152d234bdd1e63e5f3de3bd8c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.1/envswitch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5913e917f3914ff5718f2cb35a501b680d996207b494f0146f6b52f36c1dc172"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.1/envswitch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2cb538bfb33ce0a557b1388202477cf7e46c8dd7940480cb8938cce29e4998ac"
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
