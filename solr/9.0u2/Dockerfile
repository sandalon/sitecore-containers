# Builds Solr image for a Windows container environment
# escape=\
FROM mcr.microsoft.com/windows/servercore:1809

SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN Add-WindowsFeature web-server, web-webserver

# Download and install Java - Solr dependency
RUN Invoke-WebRequest -Method Get -Uri http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185 -OutFile /jreinstaller.exe ; \
    Start-Process -FilePath C:\jreinstaller.exe -PassThru -wait -ArgumentList "/s,INSTALLDIR=c:\Java\jre" ; \
    del C:\jreinstaller.exe

RUN Remove-Item -Recurse C:\inetpub\wwwroot\*

ENV JAVA_HOME c:\\Java\\jre

# Write variables to the master environment in the registry
RUN setx PATH '%PATH%;c:\\Java\\jre'

# Download and extract Solr project files
RUN Invoke-WebRequest -Method Get -Uri "http://archive.apache.org/dist/lucene/solr/6.6.3/solr-6.6.3.zip" -OutFile /solr.zip ; \
    Expand-Archive -Path /solr.zip -DestinationPath /solr ; \
    Remove-Item /solr.zip -Force

ENV SOLR_HOME c:\\solr\\solr-6.6.3\\server\\solr

# this sets the prefix for the solr cores
# it should match the $prefix var in Sitecore's install.ps1
ENV SC_PREFIX sc9

# enable SSL for Solr
ADD solr-ssl.ps1 .
ADD sitecore-solr.json .
ADD xconnect-solr.json .
ADD sitecore-config.ps1 .

# run the generate-keystore.ps1 to create the files
ADD solr-ssl.keystore.jks .
ADD solr-ssl.keystore.p12 .

# configure ssl with the passed in cert
RUN .\solr-ssl.ps1 ; Remove-Item .\solr-ssl.ps1 -Force

# Run Sitecore's SIF to generate the cores on disk
# note that this doesn't add the cores to solr.  That still needs to be done
# via the install.ps1 from Sitecore
RUN .\sitecore-config.ps1

WORKDIR "/solr/solr-6.6.3"

EXPOSE 8983

ENTRYPOINT bin/solr start -port 8983 -f -noprompt