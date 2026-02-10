class Dc < Formula
  desc "Worktree aware devcontainer manager"
  homepage "https://github.com/paholg.dc"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.3/dc-aarch64-apple-darwin.tar.xz"
      sha256 "baf77a1a0d7d01fb97f6863128b74a63310bc74debfae914fc561c766f1a42ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.3/dc-x86_64-apple-darwin.tar.xz"
      sha256 "eee18393781872571479480659b5934fba7e04b1d6b096536a9c56ff5cf00cc9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.3/dc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19fd8275cfdf395955f479eb55366825826a369d205a2bbee6c5ef722910b72d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.3/dc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ec52396f8c9203b75804ddd3c61468df5d3615d57c169d79fc26f1ef9ec35a3"
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
