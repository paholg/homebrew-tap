class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://devconcurrent.paholg.com"
  version "0.0.35"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.35/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "13334b6b83a539087d8e079ef5d40537b5d5ba148575b3d3f6e553bbacbb0a05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.35/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "331892eaa789986e3f6281c5d6ed2ac51bb4499298e6df1bd800bea9e17e528f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.35/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7628e9ab0c6f8f18c7a09ee7459352cba63430f906a78b54cf92862e88fff49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.35/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15fcec634e021d289ff23d49b685d92f80d995baf1438d2c6586c0d9f01d5c46"
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
