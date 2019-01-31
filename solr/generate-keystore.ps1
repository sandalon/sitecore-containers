
param(
	[string]$KeystoreFile = 'solr-ssl.keystore.jks',
	[string]$KeystorePassword = 'secret',
	[string]$SolrDomain = 'localhost',
	[switch]$Clobber
)

$ErrorActionPreference = 'Stop'

$keytool = (Get-Command 'keytool.exe').Source
$P12Path = [IO.Path]::ChangeExtension($KeystoreFile, 'p12')

Write-Host ''
Write-Host 'Generating JKS keystore...'
& $keytool -genkeypair -alias solr-ssl -keyalg RSA -keysize 2048 -keypass $KeystorePassword -storepass $KeystorePassword -validity 9999 -keystore $KeystoreFile -ext SAN=DNS:$SolrDomain,IP:127.0.0.1 -dname "CN=$SolrDomain, OU=Organizational Unit, O=Organization, L=Location, ST=State, C=Country"

Write-Host ''
Write-Host 'Generating .p12 to import to Windows...'
& $keytool -importkeystore -srckeystore $KeystoreFile -destkeystore $P12Path -srcstoretype jks -deststoretype pkcs12 -srcstorepass $KeystorePassword -deststorepass $KeystorePassword

Write-Host ''
Write-Host 'Trusting generated SSL certificate...'
$secureStringKeystorePassword = ConvertTo-SecureString -String $KeystorePassword -Force -AsPlainText
$root = Import-PfxCertificate -FilePath $P12Path -Password $secureStringKeystorePassword -CertStoreLocation Cert:\LocalMachine\Root
Write-Host 'SSL certificate is now locally trusted. (added as root CA)'
