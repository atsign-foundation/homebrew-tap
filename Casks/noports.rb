cask "noports" do
  arch arm: "arm64", intel: "x64"

  version '5.14.11'
  sha256 arm:  "0c2e001ac9d8ca51bd0668b52625847b7da1a82d21cc152149f0c947af02380f",
         intel: "2908aee55107de51c0efd1cd7784f4b84d6615ccb093c83264c1409438895979"

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
