resource "aws_instance" "ms2" {

  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ctf_ports.name]
  key_name        = "propane"


  tags = {
    Name = "ms2"
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
    "sudo docker run --name ms2 -p 80:80 -p 2222:22 -p 2223:23 -p 2221:21 -p 8787:8787 -p 8180:8180 -p 4445:445 -d -it tleemcjr/metasploitable2:latest sh -c '/bin/services.sh && bash'",    
    ]  
  }
}


output "OLDFAITHFUL" {
  value = aws_instance.ms2.public_ip
}
