instance_type = "t3.micro"
name          = "devvpc"
environment   = "dev"
dns-name      = "${random_pet.server.id}.destroyerohith.online"
