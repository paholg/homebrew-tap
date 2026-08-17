class Devconcurrent < Formula
  desc "Worktree aware devcontainer manager, for concurrent development"
  homepage "https://devconcurrent.paholg.com"
  version "0.0.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.27/devconcurrent-aarch64-apple-darwin.tar.xz"
      sha256 "d7ef323ac53e5d64f727480d98604d1e84a3742f9a23e5503c35a07a28e26765"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.27/devconcurrent-x86_64-apple-darwin.tar.xz"
      sha256 "0d9e995bbf4fc6b0a0034327d792fc87c80b94b0b9055fb12757cdb9a8b5c5fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.27/devconcurrent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "89797130ee2d53d0835d8af060c66edba3637310a849143660b1d33bb8d13f5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/devconcurrent/releases/download/v0.0.27/devconcurrent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e11a5b4cb1864ed45b9c04817b9785c34513d90c5dc27792ed648e696b1863c8"
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
