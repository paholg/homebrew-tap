class Dc < Formula
  desc "Worktree aware devcontainer manager"
  homepage "https://github.com/paholg.dc"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.9/dc-aarch64-apple-darwin.tar.xz"
      sha256 "2e771eca25b355d145e59443de71d567cc2eb15a58cbbc6d6c73b0e1db865ba1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.9/dc-x86_64-apple-darwin.tar.xz"
      sha256 "5e84222ceee75b89d8d4f41b571a521bbcf4b9cd9cc5ea7d35a680396f31238b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paholg/dc/releases/download/v0.0.9/dc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4cded25d1cc50061850e3e5163aa1bd97e218f5e631debc984ebbe7175b1398"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paholg/dc/releases/download/v0.0.9/dc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6a8888111d9d668bacac54e1baad48079c94aef2df98f906fa75362452e749b"
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
