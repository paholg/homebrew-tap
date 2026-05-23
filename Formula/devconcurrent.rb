class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://github.com/paholg/devconcurrent"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.14/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "c3f0ebfeafe10a71641a65cd76b64b54ec70eb2fdfaf20bcd8f52c079949631e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.14/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "06713cbd4b311ebee760cc0e2d7d99d1d70de4d33088ec4adbe6d8307db31577"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.14/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8c3efac02913ea3648cd72e2029804748f03f2e182509da2ad9b3c63adf72e5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.14/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f813f3b2992eedd7da4d3f9e8e8aa4d70b61c9521b059d0cc3dc53eee669648c"
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
