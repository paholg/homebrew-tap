class Dc < Formula
  desc "Worktree aware devcontainer manager"
  homepage "https://github.com/paholg.dc"
  version "0.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.7/dc-aarch64-apple-darwin.tar.xz"
      sha256 "0acc0e5055032901d3141f2760f65f3575fbe02a707ca701b9b53a50fa8bc1cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.7/dc-x86_64-apple-darwin.tar.xz"
      sha256 "cf10b3af30020872cf8477a9bd2bdc1efa9ed55d29bfa6fb98aca7b2043a80a1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.7/dc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9f033094f099977335ee57d0a91f379ada66d0f8a8f69f91f7dcb0723a3aa0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.7/dc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d8da87ce50e121b94cd5181b69b342f6636430122bea38d5de1e6b238f6c3a1"
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
    bin.install "dc" if OS.mac? && Hardware::CPU.arm?
    bin.install "dc" if OS.mac? && Hardware::CPU.intel?
    bin.install "dc" if OS.linux? && Hardware::CPU.arm?
    bin.install "dc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
