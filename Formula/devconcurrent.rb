class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://github.com/paholg/devconcurrent"
  version "0.0.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.16/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "b711cbebcc59196f0745fd9d605504a93e9141815f4efd21216edf11315f1b89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.16/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "b297944ad9a2df9718aac99e37312cd07a157517f587e48b5bb947195aeaa90e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.16/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eab060b50a7d42c8a0dac92917ecde0d073841a278bc8740a1a994026ff26005"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.16/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ea8bfa3390e4a3ab009e208ba260cafa1b0e8e8c7912c075fbf98d1419477e55"
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
