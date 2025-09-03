# Outputs for Compute Module

# Linux Virtual Machines
output "linux_vms" {
  description = "Information about Linux virtual machines"
  value = {
    LinAMAPortalDep = {
      id         = azurerm_linux_virtual_machine.lin_ama_portal_dep.id
      public_ip  = azurerm_public_ip.lin_ama_portal_dep_pip.ip_address
      private_ip = azurerm_network_interface.lin_ama_portal_dep_nic.private_ip_address
    }
    LinAMAPSDeploy = {
      id         = azurerm_linux_virtual_machine.lin_ama_ps_deploy.id
      public_ip  = azurerm_public_ip.lin_ama_ps_deploy_pip.ip_address
      private_ip = azurerm_network_interface.lin_ama_ps_deploy_nic.private_ip_address
    }
    LinAMACLIDeploy = {
      id         = azurerm_linux_virtual_machine.lin_ama_cli_deploy.id
      public_ip  = azurerm_public_ip.lin_ama_cli_deploy_pip.ip_address
      private_ip = azurerm_network_interface.lin_ama_cli_deploy_nic.private_ip_address
    }
    LinAMAPolicyDep = {
      id         = azurerm_linux_virtual_machine.lin_ama_policy_dep.id
      public_ip  = azurerm_public_ip.lin_ama_policy_dep_pip.ip_address
      private_ip = azurerm_network_interface.lin_ama_policy_dep_nic.private_ip_address
    }
    AutoUpgradePortal = {
      id         = azurerm_linux_virtual_machine.auto_upgrade_portal.id
      public_ip  = azurerm_public_ip.auto_upgrade_portal_pip.ip_address
      private_ip = azurerm_network_interface.auto_upgrade_portal_nic.private_ip_address
    }
    AutoUpgradePS = {
      id         = azurerm_linux_virtual_machine.auto_upgrade_ps.id
      public_ip  = azurerm_public_ip.auto_upgrade_ps_pip.ip_address
      private_ip = azurerm_network_interface.auto_upgrade_ps_nic.private_ip_address
    }
    AutoUpgradeCLI = {
      id         = azurerm_linux_virtual_machine.auto_upgrade_cli.id
      public_ip  = azurerm_public_ip.auto_upgrade_cli_pip.ip_address
      private_ip = azurerm_network_interface.auto_upgrade_cli_nic.private_ip_address
    }
  }
}

# Windows Virtual Machines
output "windows_vms" {
  description = "Information about Windows virtual machines"
  value = {
    WinAMAPortalDep = {
      id         = azurerm_windows_virtual_machine.win_ama_portal_dep.id
      public_ip  = azurerm_public_ip.win_ama_portal_dep_pip.ip_address
      private_ip = azurerm_network_interface.win_ama_portal_dep_nic.private_ip_address
    }
    WinAMAPSDeploy = {
      id         = azurerm_windows_virtual_machine.win_ama_ps_deploy.id
      public_ip  = azurerm_public_ip.win_ama_ps_deploy_pip.ip_address
      private_ip = azurerm_network_interface.win_ama_ps_deploy_nic.private_ip_address
    }
    WinAMACLIDeploy = {
      id         = azurerm_windows_virtual_machine.win_ama_cli_deploy.id
      public_ip  = azurerm_public_ip.win_ama_cli_deploy_pip.ip_address
      private_ip = azurerm_network_interface.win_ama_cli_deploy_nic.private_ip_address
    }
    WinAMAPolicyDep = {
      id         = azurerm_windows_virtual_machine.win_ama_policy_dep.id
      public_ip  = azurerm_public_ip.win_ama_policy_dep_pip.ip_address
      private_ip = azurerm_network_interface.win_ama_policy_dep_nic.private_ip_address
    }
  }
}

# All VM Information Combined
output "all_vm_connection_info" {
  description = "Connection information for all virtual machines"
  value = {
    linux_vms = {
      for vm_name, vm_info in {
        LinAMAPortalDep = {
          public_ip  = azurerm_public_ip.lin_ama_portal_dep_pip.ip_address
          private_ip = azurerm_network_interface.lin_ama_portal_dep_nic.private_ip_address
          protocol   = "SSH"
          port       = "22"
          username   = var.admin_username
        }
        LinAMAPSDeploy = {
          public_ip  = azurerm_public_ip.lin_ama_ps_deploy_pip.ip_address
          private_ip = azurerm_network_interface.lin_ama_ps_deploy_nic.private_ip_address
          protocol   = "SSH"
          port       = "22"
          username   = var.admin_username
        }
        LinAMACLIDeploy = {
          public_ip  = azurerm_public_ip.lin_ama_cli_deploy_pip.ip_address
          private_ip = azurerm_network_interface.lin_ama_cli_deploy_nic.private_ip_address
          protocol   = "SSH"
          port       = "22"
          username   = var.admin_username
        }
        LinAMAPolicyDep = {
          public_ip  = azurerm_public_ip.lin_ama_policy_dep_pip.ip_address
          private_ip = azurerm_network_interface.lin_ama_policy_dep_nic.private_ip_address
          protocol   = "SSH"
          port       = "22"
          username   = var.admin_username
        }
        AutoUpgradePortal = {
          public_ip  = azurerm_public_ip.auto_upgrade_portal_pip.ip_address
          private_ip = azurerm_network_interface.auto_upgrade_portal_nic.private_ip_address
          protocol   = "SSH"
          port       = "22"
          username   = var.admin_username
        }
        AutoUpgradePS = {
          public_ip  = azurerm_public_ip.auto_upgrade_ps_pip.ip_address
          private_ip = azurerm_network_interface.auto_upgrade_ps_nic.private_ip_address
          protocol   = "SSH"
          port       = "22"
          username   = var.admin_username
        }
        AutoUpgradeCLI = {
          public_ip  = azurerm_public_ip.auto_upgrade_cli_pip.ip_address
          private_ip = azurerm_network_interface.auto_upgrade_cli_nic.private_ip_address
          protocol   = "SSH"
          port       = "22"
          username   = var.admin_username
        }
      } : vm_name => vm_info
    }
    windows_vms = {
      for vm_name, vm_info in {
        WinAMAPortalDep = {
          public_ip  = azurerm_public_ip.win_ama_portal_dep_pip.ip_address
          private_ip = azurerm_network_interface.win_ama_portal_dep_nic.private_ip_address
          protocol   = "RDP"
          port       = "3389"
          username   = var.admin_username
        }
        WinAMAPSDeploy = {
          public_ip  = azurerm_public_ip.win_ama_ps_deploy_pip.ip_address
          private_ip = azurerm_network_interface.win_ama_ps_deploy_nic.private_ip_address
          protocol   = "RDP"
          port       = "3389"
          username   = var.admin_username
        }
        WinAMACLIDeploy = {
          public_ip  = azurerm_public_ip.win_ama_cli_deploy_pip.ip_address
          private_ip = azurerm_network_interface.win_ama_cli_deploy_nic.private_ip_address
          protocol   = "RDP"
          port       = "3389"
          username   = var.admin_username
        }
        WinAMAPolicyDep = {
          public_ip  = azurerm_public_ip.win_ama_policy_dep_pip.ip_address
          private_ip = azurerm_network_interface.win_ama_policy_dep_nic.private_ip_address
          protocol   = "RDP"
          port       = "3389"
          username   = var.admin_username
        }
      } : vm_name => vm_info
    }
  }
}
