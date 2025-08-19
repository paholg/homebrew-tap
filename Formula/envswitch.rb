class Envswitch < Formula
  desc "A simple tool for managing sets of environment variables"
  homepage "https://github.com/paholg/envswitch"
  version "0.5.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.7/envswitch-aarch64-apple-darwin.tar.xz"
      sha256 "323e60eaa079200a156887046dc29a93af18608a19b418fd922b0133e2a870ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.7/envswitch-x86_64-apple-darwin.tar.xz"
      sha256 "2b651e7221d5a1bc95eaa96a35f68f836feef01f091fe54a79473360ba3db1af"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.7/envswitch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7f9aa64d1b127f60fb7c5ed4502d1abcc34f1267424e1f64f89e1299391ee746"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/envswitch/releases/download/v0.5.7/envswitch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ee9e139a624490345feecb4f890e0e59e72a69bada2f91495ac9678e7690118"
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
