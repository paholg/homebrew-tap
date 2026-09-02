class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://devconcurrent.paholg.com"
  version "0.0.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.30/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "b7a57a28f744d90607fb62d20197285ecddf90623801d7264efa83e428f95c83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.30/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "0d2f92d0e542ae3771b54d8f90878501fe9178c99b162223561a6a6ecbc4324e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.30/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5afe37469da16aeb6d2f8549ebda49f34220539b8953776318a9c12043d5cf6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.30/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aff979332e1743b5611d5a576296aabc8d3a46c38b2b1a9c893b8289476fc6bc"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "devconcurrent"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "devconcurrent"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "devconcurrent"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "devconcurrent"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
