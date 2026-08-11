class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://github.com/paholg/devconcurrent"
  version "0.0.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.23/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "9942960fe4c40a9531672663a94869f3d1bd997814bf87ab4e9b9e65f25abc48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.23/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "6ccc64796bef96dd53df65a3fa35496d294b76758e458c32cede925f9203de70"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.23/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d960622004f6369c98d50f273e500bed5db2141db58b10887e9758494c94a57e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.23/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "94a8c535dca7361838c644e742aca87473b3b426d34961b00b0822b746ddd28e"
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
