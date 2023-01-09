resource "aws_instance" "propane" {

  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.all_ports.name]
  key_name        = "propane"


  tags = {
    Name = "propane"
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
    "sudo apt install docker-ce docker-ce-cli containerd.io -y",
    "sudo service docker start",
    "sudo systemctl enable docker",
    "sudo docker run --name propane -v $PWD/tmp:/tmp -d -p 80:80 3ndg4me/propane",    
    ]  
  }
}


output "PROPANE" {
  value = aws_instance.propane.public_ip
}
