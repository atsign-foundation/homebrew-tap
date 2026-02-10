cask "noports" do
  arch arm: "arm64", intel: "x64"

  version 'v5.14.5'
  sha256 arm:   "892e229e17557aea2eb17318ee11c2ae5955ea84942c847d013e23818c018193",
         intel: "355b55a71213dbd2f92228b8d89527f9739ae5e2dcd4de3cfec9a423c6933c01"

  # N.B. Be careful about the formatting in the above lines.
  # They are automatically updated by: .github/workflows/multibuild.yaml

  url "https://github.com/atsign-foundation/noports/releases/download/#{version}/sshnp-#{os}-#{arch}.zip"
  name "noports"
  desc "Make your devices invisible (https://noports.com)"
  homepage "https://noports.com"

  depends_on formula: "ca-certificates"

  binary "sshnp/at_activate"
  binary "sshnp/srv"
  binary "sshnp/npt"
  binary "sshnp/sshnp"
  binary "sshnp/sshnpd"
  binary "sshnp/srvd"
  binary "sshnp/npp_atserver"
  binary "sshnp/npp_file"
  binary "sshnp/npa_file"

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
