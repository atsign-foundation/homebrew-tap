cask "noports" do
  arch arm: "arm64", intel: "x64"
  os macos: "macos", linux: "linux"
  version 'v5.11.2'

  macos_arm_sha = "13c384ad74aab82e8d7a81d83abc18d72a76ddaca80b53d32a87cbdd623dd8b9"
  macos_x64_sha = "2b1619065faac9c7750a17f1b04fe2b2b9b91226de90c1e0554fb0ffc400bf13"
  linux_arm_sha = "77ec1651b5121068045e898b4d6ce0a1f8b2651bc72d5c1eb5d802aec3d1061b"
  linux_x64_sha = "8afd8689841861d94bddf122b7053fc1207960f2f58851bfd532bf6022a3525d"

  on_macos do
    on_arm do
      sha256 macos_arm_sha
    end
    on_intel do
      sha256 macos_x64_sha
    end
  end
  on_linux do
    on_arm do
      sha256 linux_arm_sha
    end
    on_intel do
      sha256 linux_x64_sha
    end
  end
 
  url "https://github.com/atsign-foundation/noports/releases/download/#{version}/sshnp-#{os}-#{arch}.zip"
  name "noports"
  desc "Cli binaries for noports (https://noports.com)"
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

  on_macos do
    service "sshnp/launchd/com.atsign.sshnpd.plist"
  end

  on_linux do
    service "sshnp/systemd/sshnpd.service"
    service "sshnp/systemd/srvd.service"
    # Note: We don't replace the USER var in systemd services like we do with
    # universal.sh, but most people don't use brew on linux, so it's fine.
    artifact "sshnp/systemd/sshnpd.service.d/override.conf",
        target: "/etc/systemd/system/sshnpd.service.d/override.conf"
    artifact "sshnp/systemd/srvd.service.d/override.conf",
        target: "/etc/systemd/system/srvd.service.d/override.conf"
  end


  zap do
    trash [
      "~/.atsign/sshnp", # Trash runtime cache when zapped (uninstall + extras)
    ]
  end

  on_linux do
    caveats <<~EOS
      sshnpd systemd service installed /etc/systemd/system/sshnp.service
      To edit the configuration, modify the file:

      vi /etc/systemd/system/sshnp.service.d/override.conf

      After modifying the service, you must reload the configuration:

      systemctl daemon-reload

      Once configured, the following commands can be used to manage the service.
      Enable/disable automatic startup:

      systemctl enable sshnpd
      systemctl disable sshnpd

      Start/stop/restart the service:

      systemctl start sshnpd
      systemctl stop sshnpd
      systemctl restart sshnpd

      View status/logs:

      systemctl status sshnpd
      journalctl -u sshnpd
    EOS
  end
  on_macos do
    caveats <<~EOS
      sshnpd launchd agent installed ~/Library/LaunchAgents/com.atsign.sshnpd.plist
      To edit the configuration, modify the file:

      xcode ~/Library/LaunchAgents/com.atsign.sshnpd.plist

      The service can be enabled or disabled from System Settings under the
      "Login Items" menu.
    EOS
  end
end
