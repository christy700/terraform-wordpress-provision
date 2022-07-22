resource "local_file" "wordpress_config" {
  content         = templatefile("./templates/wordpress.tmpl", { private-ip = aws_instance.backend.private_ip, db_name = var.db_name, db_user = var.db_user, db_pass = var.db_pass })
  filename        = "./template-output/wp-config.php"
  file_permission = "0644"
}


resource "local_file" "nginx_config" {
  content         = templatefile("./templates/vhosts.tmpl", { domain_name = var.domain_name })
  filename        = "./template-output/${var.domain_name}.conf"
  file_permission = "0644"
}

resource "local_file" "mysql_config" {
  content         = templatefile("./templates/my.cnf.tmpl", { mysqlrp = var.mysql_pass })
  filename        = "./template-output/my.cnf"
  file_permission = "0644"
}

resource "local_file" "backend_mysql" {
  content         = templatefile("./templates/backend_mysql.sh.tmpl", { mysqlrp = var.mysql_pass, db_name = var.db_name, db_user = var.db_user, db_pass = var.db_pass })
  filename        = "./template-output/backend_mysql.sh"
  file_permission = "0775"
}

resource "local_file" "tranfer_file" {
  content         = templatefile("./templates/tranfer.sh.tmpl", { domain_name = var.domain_name, private-ip = aws_instance.backend.private_ip, private-ip2 = aws_instance.frontend.private_ip })
  filename        = "./template-output/tranfer.sh"
  file_permission = "0775"
}

