class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://github.com/paholg/devconcurrent"
  version "0.0.19"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.19/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "855b87d579e3b0431799cba0dd08c10ad20e7fd368d8c5a6dbbd238c066a6f48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.19/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "41d2bbd178c82ac5fe52eff3224c042c1ff8c70eee08e95bc2aff18daf2aa5aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.19/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca35f7a27614bbd27f7b30f652f9f540bdd337da5da185f9471ea332c77e6f3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.19/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "968786e0d9a4cd17036adc1919bb16f38997620a167bcab9f6df43afc4ab112e"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "devconcurrent" if OS.mac? && Hardware::CPU.arm?
    bin.install "devconcurrent" if OS.mac? && Hardware::CPU.intel?
    bin.install "devconcurrent" if OS.linux? && Hardware::CPU.arm?
    bin.install "devconcurrent" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
