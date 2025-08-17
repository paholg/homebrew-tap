class Envswitch < Formula
  desc "A simple tool for managing sets of environment variables"
  homepage "https://github.com/paholg/envswitch"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.0/envswitch-aarch64-apple-darwin.tar.xz"
      sha256 "683a1af7468b698483a88e9e64411a052b4c9156cb70282319c4b3120f911731"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.0/envswitch-x86_64-apple-darwin.tar.xz"
      sha256 "868eff8b91938cafbc3e8fb96e7222f90868b34c10a8397c3c0e239ee5b3fb4d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.0/envswitch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "681cc880ba4a4e8043216aa96d198b8d987b6a98e44dd315e8f785a5895e4a50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.3.0/envswitch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8255a7bbe18be5ee67f0bd0691d066dbdf7dc6e4a303663b897188bcf11bbe82"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "envswitch" if OS.mac? && Hardware::CPU.arm?
    bin.install "envswitch" if OS.mac? && Hardware::CPU.intel?
    bin.install "envswitch" if OS.linux? && Hardware::CPU.arm?
    bin.install "envswitch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
