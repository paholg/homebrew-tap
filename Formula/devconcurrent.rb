class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://github.com/paholg/devconcurrent"
  version "0.0.20"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.20/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "89883647a1fba22dc3aebd175a01e76d6ba8651c31a54d28f3d07420bc0f42e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.20/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "13570970619094cdde8d07b630fcf191c7a4bc17fc421bb158cfc1f00731e7c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.20/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a1f60770dee83584586c50d3021257c605425d6b370f8fd9f327943968e0f36c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.20/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab917a770fd23ef18749d1b8365aefa25deb3fc6f090421f7596e3dbbb955313"
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
