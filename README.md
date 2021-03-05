# AWS Architecture Icons

AWS architecture icons in SVG format.

## Description

This repository contains the SVG versions of all the icons from the official [AWS architecture icon assets package](https://aws.amazon.com/architecture/icons/).

The content is generated from the AWS architecture icons assets package with the `build.sh` script.

## Icons

**[Services](Asset-Package_20210131/Architecture-Service-Icons_01-31-2021):**

![AWS architecture icons](img/icons-services.png)

**[Resources](Asset-Package_20210131/Resource-Icons_01-31-2021):**

![AWS architecture icons](img/icons-resources.png)

**[Categories](Asset-Package_20210131/Category-Icons_01-31-2021):**

![AWS architecture icons](img/icons-categories.png)

## Versions

Current and past versions of the [AWS architecture icons assets package](https://aws.amazon.com/architecture/icons/):

| Version      | URL |
|--------------|-----|
| **20210131** | https://d1.awsstatic.com/webteam/architecture-icons/q1-2021/AWS-Architecture_Asset-Package_20210131.a41ffeeec67743738315c2585f5fdb6f3c31238d.zip |


## Generate images

To generate the icon grid images, extract all PNG versions of the icons (instead of SVG) of a specific size with the `build.sh` script, then use the [ImageMagick](https://imagemagick.org/index.php) `montage` command along the following lines:

```bash
montage -tile 30x0 -geometry +2+2 -scale 80x80 */*.png out.png
```
