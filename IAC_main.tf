provider "aws {
  region = "us-east-1"
}
resource "aws_instance" "web_server" {
  ami           = "ami-04ccd752e0917a978"
  instance_type = "t2.micro"

 tags = {
    Name = "ExampleInstance"
  }

}
