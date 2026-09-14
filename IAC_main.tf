provider "aws" {
  region = "ap-southeast-2"
}
resource "aws_instance" "web_server" {
  ami           = "ami-04ccd752e0917a978"
  instance_type = "t2.micro"
  count         = 1


 tags = {
    Name = "ExampleInstance"
  }

}
