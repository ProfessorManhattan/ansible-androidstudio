## Introduction

Welcome to a new way of doing things. Born out of complete paranoia, this project aims to bring your system as close as possible to being able to completely wipe your whole network and reinstall on a regular basis. It all started when I changed my desktop wallpaper to an _incredibly cute_ picture of a cat and then my computer meowed. Well, it actually started before that but no one believes me when I tell them time travelers "hack" me on a regular basis so I will leave that out for now.

This repository is home to a collection of Ansible playbooks meant to provision computers and networks with the "best of GitHub". Using Ansible, you can provision your whole network relatively fast in the event of a disaster. This project is also intended to increase the security of your network by allowing you to frequently wipe, reinstall, and re-provision your network, bringing it back to its original state. This is done by backing up only what needs to be backed up (like database files and Docker volumes) to encrypted S3 buckets and git repositories. Each piece of software is included as an Ansible role.

Sometimes there are multiple tools that exist that perform the same task. In these cases, extensive research is done to ensure that only the best, most-popular software makes it into our role collection.

This Ansible playbook is:

- Highly configurable (most roles come with optional variables that you can configure to change the behavior of the role)
- Compatible with all major operating systems (i.e. Windows, Mac OS X, Ubuntu, Fedora, CentOS, Debian, and even Archlinux)
- The product of a team of experts
- An amazing way to learn about developer tools that many would consider to be "the best of GitHub"
- Open to new ideas - feel free to [open an issue]({{ repository.gitlab }}{{ repository.location.issues.gitlab }}) or [contribute]({{ repository.github }}{{ repository.location.contributing.github }}) with a [pull request]({{ repository.github }}{{ repository.location.issues.github }})!
