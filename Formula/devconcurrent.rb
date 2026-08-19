class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://devconcurrent.paholg.com"
  version "0.0.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.28/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "86f58eaf8151422fd8be5dadad7b789afe07c4b0279567216e680236b5f6ea40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.28/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "c566059a4f8d94e1c04d0d3aeef0756903cb6335208931c423f873ba6886cfa9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.28/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81ab6064619651eef02e37007b1b6832cb8288f88c88905bdc446ca541e840e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.28/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e60ea00f3a5cf40c03339377ed05f9f4f23bd70fe14239801902af5f9f0a3e0c"
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
