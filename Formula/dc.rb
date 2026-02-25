class Dc < Formula
  desc "Worktree aware devcontainer manager"
  homepage "https://github.com/paholg.dc"
  version "0.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.10/dc-aarch64-apple-darwin.tar.xz"
      sha256 "8e0d4830c75be93c2fae0f0b3bf9c082c4bf28e8b35ff204d137fa725df4c92a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.10/dc-x86_64-apple-darwin.tar.xz"
      sha256 "48f05937513d154dfa5c12f21a95403a520e69fccca126898a1cd515fa2ad13a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.10/dc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dcf06efca08e2f61ab624c20c55bed75e9155b3e5bfbc9ea0bfb8659a802b220"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.10/dc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "139a611c207a52b0b2d7322eb72bf2568cb0a93411c73b986f95ec01ee27d74e"
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
