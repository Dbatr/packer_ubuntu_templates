variable "cpus" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "32880"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "hostname" {
  type    = string
  default = "bionic64"
}

variable "http_proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("https_proxy")}"
}

variable "iso_checksum" {
  type    = string
  default = "8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-18.04.5-server-amd64.iso"
}

variable "iso_path" {
  type    = string
  default = "iso"
}

variable "iso_url" {
  type    = string
  default = "http://old-releases.ubuntu.com/releases/18.04.5/ubuntu-18.04.5-server-amd64.iso"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "no_proxy" {
  type    = string
  default = "${env("no_proxy")}"
}

variable "preseed" {
  type    = string
  default = "preseed.cfg"
}

variable "ssh_fullname" {
  type    = string
  default = "ubuntu"
}

variable "ssh_password" {
  type    = string
  default = "ubuntu"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "ssh_public_key_path" {
  type    = string
  default = "C:/Users/Lenovo/.ssh/id_ed25519.pub"
}

variable "update" {
  type    = string
  default = "true"
}

variable "version" {
  type    = string
  default = "0.1"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "Ubuntu_64"
}

variable "vm_name" {
  type    = string
  default = "ubuntu-18.04"
}

variable "home" {
  type    = string
  default = env("HOME")
}

source "virtualbox-iso" "autogenerated_1" {
  boot_command            = [
    "<esc><esc><enter><wait>", 
    "/install/vmlinuz noapic ", 
    "initrd=/install/initrd.gz ", 
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed} ", 
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ", 
    "hostname=${var.hostname} ", 
    "grub-installer/bootdev=/dev/sda<wait> ", 
    "fb=false debconf/frontend=noninteractive ", 
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ", 
    "keyboard-configuration/variant=USA console-setup/ask_detect=false ", 
    "passwd/user-fullname=${var.ssh_fullname} ", 
    "passwd/user-password=${var.ssh_password} ", 
    "passwd/user-password-again=${var.ssh_password} ", 
    "passwd/username=${var.ssh_username} ", "-- <enter>"
  ]
  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_path}/${var.iso_name}", 
    "${var.iso_url}"
  ]
  output_directory        = "output"
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now"
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage              = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"], 
    ["modifyvm", "{{ .Name }}", "--vram", "12"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"], 
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"]
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
  format                  = "ova"
}

build {
  sources = ["source.virtualbox-iso.autogenerated_1"]
  
  provisioner "file" {
    source      = "${var.ssh_public_key_path}"
    destination = "/home/ubuntu/authorized_keys"
  }

  provisioner "shell" {
    environment_vars  = [
      "DEBIAN_FRONTEND=noninteractive", 
      "UPDATE=${var.update}", 
      "SSH_USERNAME=${var.ssh_username}", 
      "SSH_PASSWORD=${var.ssh_password}", 
      "http_proxy=${var.http_proxy}", 
      "https_proxy=${var.https_proxy}", 
      "no_proxy=${var.no_proxy}"
    ]
    execute_command   = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "script/update.sh",
      "script/install_devops_tools.sh",
      "script/cleanup.sh",
      "script/ssh.sh"
    ]
  }
}