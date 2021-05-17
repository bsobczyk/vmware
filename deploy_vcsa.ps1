#Deploy VCSA 

#Convert JSON file to powershell object
$ConfigLoc = "D:\vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json"
$Installer = "D:\vcsa-cli-installer\win32\vcsa-deploy.exe"
$updateconfig="C:\temp\configruation.json"
$json = (Get-Content -Raw $ConfigLoc) | ConvertFrom-Json

#Vcsa system information
$json.ceip.settings.ceip_enabled= $false
$json.new_vcsa.appliance.thin_disk_mode = $true
$json.new_vcsa.appliance.deployment_option = "tiny"
$json.new_vcsa.appliance.name = "vc01.v.lab"

$json.new_vcsa.sso.domain_name = "vsphere.local"
$json.new_vcsa.sso.password = "VMware1!"

$json.new_vcsa.os.password = "Vmware1!"
$json.new_vcsa.os.ssh_enable = $true
$json.new_vcsa.os.ntp_servers= "time.google.com"

#ESxi host information
$json.new_vcsa.esxi.hostname = "esxi01a.v.lab"
$json.new_vcsa.esxi.username = "root"
$json.new_vcsa.esxi.password = "VMware1!"
$json.new_vcsa.esxi.deployment_network = "VM Network"
$json.new_vcsa.esxi.datastore = "DS01"

#Network information
$json.new_vcsa.network.dns_servers = "10.10.10.1"
$json.new_vcsa.network.ip ="10.10.10.50"
$json.new_vcsa.network.ip_family = "ipv4"
$json.new_vcsa.network.mode ="static"
$json.new_vcsa.network.prefix ="24"
$json.new_vcsa.network.gateway="10.10.10.1"
$json.new_vcsa.network.system_name="vc01.v.lab"

#save json configuration file
$json | ConvertTo-Json | Set-Content -Path $updateconfig
#Deploy vcsa
Invoke-Expression -Command "$Installer install --accept-eula $updateconfig --no-ssl-certificate-verification " 
