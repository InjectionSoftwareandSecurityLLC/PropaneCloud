resource "aws_instance" "gemstone" {

  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ctf_ports.name]
  key_name        = "propane"


  tags = {
    Name = "gemstone"
  }
  
provisioner "remote-exec" {    
    connection {    
      type = "ssh"    
      user = "ubuntu"    
      agent = "false"
      private_key = file("~/.ssh/propane.pem") # CHANGE ME
      host = coalesce(self.public_ip, self.private_ip)
      }
    
  inline = [      
    "sudo apt update -y",
    "sudo apt install ca-certificates curl gnupg lsb-release -y",
    "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
    "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
    "sudo apt update -y",
    "sudo apt install docker-ce docker-ce-cli containerd.io docker-compose git -y",
    "sudo service docker start",
    "sudo systemctl enable docker",
    "git clone https://github.com/InjectionSoftwareandSecurityLLC/vulndocker.git",
    "cd vulndocker/ruby/CVE-2017-17405 && sudo docker-compose up -d",
    ]  
  }
}


output "SALTY" {
  value = aws_instance.gemstone.public_ip
}
