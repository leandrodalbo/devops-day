# Ansible and Vagrant quick example

## Start Virtual Environment

```console
python3 -m venv venv
```

## Set The Environment

```console
source venv/bin/activate
```

## Upgrade pip

```console
pip install -U pip
```

## Install Ansible

```console
pip install ansible
```

## Install Vagrant (arch)

```console
sudo pacman -S vagrant
```

## Spin-up VMs

```console
vagrant up
```

### to get the info necessary to build our hosts file run

```console
vagrant ssh-config
```

### ping

```console
ansible -i hosts all -m ping
```

### others commands

```console
ansible-inventory --list
ansible-playbook demo_playbook.yml
vagrant destroy
```
