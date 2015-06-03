# CHANGELOG for openstudio

## 0.2.6
* Support and default to EnergyPlus 8.3

## 0.2.5 
* Remove gdebi cookbook, just install the dependency manually

## 0.2.4: 
* Do not symlink the x86_64 directory for OpenStudio versions greater than 1.5.1

## 0.2.3
* Use Ubuntu 14.04 in Vagrant file
* Remove semantic gem in favor of Chef::VersionConstraint
* Support for s3 bucket downloads. This is now the default
* Support for EnergyPlus 8.2 with OpenStudio >= 1.5.4.

## 0.2.2
* Support downloading from any URL

## 0.2.1

* Add call to make package always via ark
* Initial rake file to download built package

## 0.2.0
* support for installing EnergyPlus 8.1 when using OpenStudio 1.3.2 or greater

## 0.1.6/7
* Force install by source for RHEL systems
* Add Vagrant file

## 0.1.5
* remove Vagrantfile in favor of kitchen
* Add Ruby recipe for installing ruby via rbenv instead of requiring a role/attribute
* Download source from codeload.github.com
* Add support for install qt via package manager instead of building

## 0.1.4
* require the prepended v in the version to allow for downloading zip files of branches for installation

## 0.1.3
* Support for RHEL / CentOS support.  Build only option.

## 0.1.1/2
* Support for building from source

## 0.1.0

* Initial release of openstudio
