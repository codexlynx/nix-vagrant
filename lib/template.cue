import "text/template"

// TODO: Model more config: https://developer.hashicorp.com/vagrant/docs/vagrantfile/machine_settings

#Vagrant: {
	package: string
	name: string
	box: string
	provider: string
	gui: bool
}

data: {
	config: #Vagrant
}

_final: {
	config: data.config
}

tmpl:
"""
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.define "{{ .config.name }}"
	config.vm.box = "{{ .config.box }}"

	config.vm.synced_folder "/nix/store", "/nix/store"

	{{- if eq .config.provider "virtualbox" }}
	config.vm.provider :virtualbox do |vb|
		vb.name = "{{ .config.name }}"
		vb.gui = {{ .config.gui }}
	end
	{{- end }}
end
"""

rendered: template.Execute(tmpl, data)
