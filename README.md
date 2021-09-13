# actions-collection

## Description

Collection.sh contains shell functions that are ran in [actions-dotnet](https://github.com/variant-inc/actions-dotnet)

To run shell functions from collection.sh:

```bash
source collection.sh
ecr_create
```

### Using Pre-Test Script

When using actions-python, actions-nodejs and actions-dotnet, create a file in .github/actions/pre_test.sh.

Include any dependant packages your app requires when testing. These packages will need to be installed with the package managers of OS the respective actions.

- actions-python: Debian/apt-get
- actions-nodejs: Alpine/apk
- actions-dotnet: Alpine/apk

#### Example (actions-python)
```bash
#!/bin/bash

sudo apt-get update --no-install-recommends -y

echo "____INSTALLING_SVN_____"
sudo apt-get install --no-install-recommends -y \
subversion

echo "____INSTALLING_PWSH_____"
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install -y powershell
```
