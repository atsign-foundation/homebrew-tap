cask "noports" do
  arch arm: "arm64", intel: "x64"

  version '5.15.0'
  sha256 arm:  "d3c245095e63b7eb58499016abaafd3411fc11d3a629d4dafeefe42314a4a547",
         intel: "8dd7023d111f051fb3a7f7dee357b1538742c0afdc6569761909e0453a1e937b"

  # N.B. Be careful about the formatting in the above lines.
  # They are automatically updated by: .github/workflows/multibuild.yaml

  url "https://github.com/atsign-foundation/noports/releases/download/v#{version}/sshnp-macos-#{arch}.zip"
  name "noports"
  desc "Make your devices invisible (https://noports.com)"
  homepage "https://noports.com"

  depends_on formula: "ca-certificates"

  binary "sshnp/at_activate"
  binary "sshnp/noports"
  binary "sshnp/npp_atserver"
  binary "sshnp/npp_file"
  binary "sshnp/npt"
  binary "sshnp/srv"
  binary "sshnp/sshnp"
  binary "sshnp/sshnpd"
  binary "sshnp/srvd"
  
  service "sshnp/launchd/com.atsign.sshnpd.plist"
  artifact "sshnp/config/sshnpd.yaml",
    target: "~/Library/Application Support/Noports/sshnpd.yaml"

  zap do
    trash [
      "~/.atsign/sshnp", # Trash runtime cache when zapped (uninstall + extras)
    ]
  end

  caveats <<~EOS
    NoPorts Daemon installed to: ~/Library/Services/com.atsign.sshnpd.plist
    To edit the configuration:

    textedit "~/Library/Application Support/NoPorts/sshnpd.yaml"

    The service can be enabled or disabled from System Settings under the
    "Login Items" menu.
  EOS
end
