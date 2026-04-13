class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://github.com/paholg/devconcurrent"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.13/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "ff1d8e2d41016c416700527f1650c305714b3d9a52fdad5565a2de6bea239bb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.13/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "2a02e5751f38b4e941e138d5a05253e55ba9ae5fa5ce484867cdce4e60737e20"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.13/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b4eef2f982cd15e0da5ec5aea60be3f0acc99e1358014ecc2ae9092835e30cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.13/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d778180997c3513f4a926b103bac964a52779d14eddd6736e8e74455735dc3b2"
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
