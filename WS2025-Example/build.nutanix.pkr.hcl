packer {
  required_plugins {
    nutanix = {
      version = ">= 1.1.4" 
      source  = "github.com/nutanix-cloud-native/nutanix"
    }
  }
}

build {
  sources = [
    "source.nutanix.windows"
  ]
  provisioner "file" {
    source      = "scripts/autounattend.xml"
    destination = "C:/autounattend.xml"
  }

  provisioner "powershell" {
    inline = [
      "Restart-Computer -Force"
    ]
  }

  provisioner "windows-restart" {}

  provisioner "powershell" {
    inline = [
      "winrm quickconfig -q",
      "winrm set winrm/config @{MaxTimeoutms='1800000'}",
      "winrm set winrm/config/winrs @{MaxMemoryPerShellMB='300'}",
      "winrm set winrm/config/service @{AllowUnencrypted='true'}",
      "winrm set winrm/config/service/auth @{Basic='true'}",
      "netsh advfirewall firewall add rule name='WinRM-HTTP' dir=in action=allow protocol=TCP localport=5985"
    ]
  }

}