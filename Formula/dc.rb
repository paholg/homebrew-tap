class Dc < Formula
  desc "Worktree aware devcontainer manager"
  homepage "https://github.com/paholg.dc"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.4/dc-aarch64-apple-darwin.tar.xz"
      sha256 "391bfa7e3de767a79750db91af8ce864fde96854f395a1e45ae45274566765ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.4/dc-x86_64-apple-darwin.tar.xz"
      sha256 "44f12df1572a26de09d3cbde3c97cc323a3acba8e53a7413ef204e0a7e067dbd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.4/dc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0abf9893182ed0321fd8b424155e686dd762feb289e732fcee62d998819460f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.4/dc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8d35707ea52a71b334a0e4626a03487681b3ef1178895fac817fe2c5d6dc17e"
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
