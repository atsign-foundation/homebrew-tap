cask "noports" do
  arch arm: "arm64", intel: "x64"

  version '5.14.13'
  sha256 arm:  "1918008ae9483d3ddd6cfad5f311ea22e1627e3acde299a0b505d96ed4fe6ada",
         intel: "45158cedc867af19660607aea733e67854f65c98c1f47498afa3f58f4d45a52f"

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
