Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider nuget -force
Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2
Set-PSRepository -Name SitecoreGallery -InstallationPolicy Trusted
Install-Module -Name SitecoreInstallFramework -Repository SitecoreGallery -RequiredVersion 1.2.1 -Force

Import-Module WebAdministration
Import-Module SitecoreFundamentals
Import-Module SitecoreInstallFramework

#define parameters 
$prefix = "sc9"
$PSScriptRoot = "C:\resourcefiles"
$XConnectCollectionService = "$prefix.xconnect" 
$sitecoreSiteName = "$prefix.dev.chick-fil-a.com" 
$SolrUrl = "https://localhost:8983/solr" 
$SolrRoot = "C:\solr\solr-6.6.3"
$SolrService = "solr6" 

#install solr cores for xdb 
$solrParams = @{     
	Path = ".\xconnect-solr.json"     
	SolrUrl = $SolrUrl     
	SolrRoot = $SolrRoot     
	SolrService = $SolrService     
	CorePrefix = $prefix } 
Install-SitecoreConfiguration @solrParams

#install solr cores for sitecore 
$solrParams = @{     
	Path = ".\sitecore-solr.json"     
	SolrUrl = $SolrUrl     
	SolrRoot = $SolrRoot     
	SolrService = $SolrService     
	CorePrefix = $prefix } 
Install-SitecoreConfiguration @solrParams 
