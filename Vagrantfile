Vagrant.configure("2") do |config|
       config.vm.box = "bento/ubuntu-20.04"
       config.ssh.insert_key = false
       config.hostmanager.enabled = true
       config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
       config.vm.provider "virtualbox" do |vb|
     vb.customize ["modifyvm", :id, "--memory", "1024"]
     vb.customize ["modifyvm", :id, "--cpus", 2]
 end

  (  ["master"] + ["worker1"] + ["worker2"] + ["worker3"] ).each_with_index do |role, i|
    name = "%s"     % [role, i]
    addr = "10.0.6.%d" % (100 + i)
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network",ip: addr
      node.vm.provision "shell", path: "provision.sh", args: "#{name}"
        end
    end

end
