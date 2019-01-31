# created by kamsar
# https://kamsar.net/index.php/2017/10/Quickly-add-SSL-to-Solr/

param(
	[string]$KeystoreFile = 'solr-ssl.keystore.jks',
	[string]$KeystorePassword = 'secret',
	[string]$SolrDomain = 'localhost',
	[switch]$Clobber
)

$ErrorActionPreference = 'Stop'

### PARAM VALIDATION
if($KeystorePassword -ne 'secret') {
	Write-Error 'The keystore password must be "secret", because Solr apparently ignores the parameter'
}

$P12Path = [IO.Path]::ChangeExtension($KeystoreFile, 'p12')
$keytool = 'c:\Java\jre\bin\keytool.exe'

### DOING STUFF

Write-Host ''
Write-Host 'Trusting generated SSL certificate...'
$secureStringKeystorePassword = ConvertTo-SecureString -String $KeystorePassword -Force -AsPlainText
$root = Import-PfxCertificate -FilePath $P12Path -Password $secureStringKeystorePassword -CertStoreLocation Cert:\LocalMachine\Root
Write-Host 'SSL certificate is now locally trusted. (added as root CA)'

$KeystorePath = Resolve-Path $KeystoreFile
Move-Item -Path $KeystorePath -Destination c:\solr\solr-6.6.3\server\etc\solr-ssl.keystore.jks

Add-Content c:\solr\solr-6.6.3\bin\solr.in.cmd "set SOLR_SSL_KEY_STORE=etc/solr-ssl.keystore.jks`n"
Add-Content c:\solr\solr-6.6.3\bin\solr.in.cmd "set SOLR_SSL_KEY_STORE_PASSWORD=$KeystorePassword`n"
Add-Content c:\solr\solr-6.6.3\bin\solr.in.cmd "set SOLR_SSL_TRUST_STORE=etc/solr-ssl.keystore.jks`n"
Add-Content c:\solr\solr-6.6.3\bin\solr.in.cmd "set SOLR_SSL_TRUST_STORE_PASSWORD=$KeystorePassword`n"