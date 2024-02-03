# Postfix

Se utiliza como base el repositorio de https://github.com/juanluisbaptiste/docker-postfix
Se hace un git pull y se construye la imagen como postfix/postfix:latest
La implementacion hace uso de un archivo .env, no sirve subir los archivos main.cf y master.cf
Se utiliza docker-compose para iniciar y apagar el stack de servicio con nombre de proyecto desde bash cript manage.sh
Al construir el dockerfile copia el archivo transport que permite acotar el envio de emails a un dominio especifico y limitar el relay a otros. Se pueden agregar multiples entradas pero es necesario editar el archivo transport antes de contruir la imagen.

## La configuracion de postfix existe en
```
/etc/postfix/main.cf
```
## Ejemplo de postif real productivo
```
# See /usr/share/postfix/main.cf.dist for a commented, more complete version


# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2



# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_security_level=may

smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache


smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = postfix.tq.com.ar
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = postfix.tqcorp.com, $myhostname, tqarsvlu20smtp01, localhost.localdomain, localhost
relayhost = tqcorp-com.mail.protection.outlook.com
mynetworks = 192.168.150.6/32 192.168.27.14/32 192.168.27.2/32 192.168.11.14/32 10.1.1.0/24 192.168.29.0/24 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all

# Transport mapping
transport_maps = texthash:/etc/postfix/transport
```

# Limitar el transport a uno o mas dominios especificos

## You can add a transport map in main.cf:
```
transport_maps = texthash:/etc/postfix/transport
```
Then edit /etc/postfix/transport with your favorite editor and add this:
```
tqcorp.com smtp:
rochel.com.ar smtp:
* error:only mail to @tqcorp.com & @rochel.com.ar will be delivered
```
This will bounce every mail with recipients other than *@example.com. If you need to be able to change the transport_map on the fly use hash instead of texthash, but you have to use postmap on the file once you changed it to update the corresponding .db file and so postfix notices it has changed. If you don't want to bounce other mails use this instead:
```
example.com smtp:
* discard:
```

# Resguardar cambios del container en nueva imagen
```
# Save the current state of the container as an image
docker commit <container_id> your_image_name:tag

# Add a label to the image (replace your_email@example.com with your actual email address)
docker image label add maintainer=your_email@example.com your_image_name:tag
```

# Bash script para gestionar container
```
#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to display the menu
display_menu() {
    echo -e "${GREEN}Select an option:${NC}"
    echo -e "${GREEN}1 - Start container${NC}"
    echo -e "${GREEN}2 - Stop container${NC}"
    echo -e "${GREEN}3 - Restart container${NC}"
    echo -e "${GREEN}4 - Display container status${NC}"
    echo -e "${GREEN}q - Exit${NC}"
}

# Function to start the container
start_container() {
    docker-compose -p postfix up -d
}

# Function to stop the container
stop_container() {
    docker-compose -p postfix down
}

# Function to restart the container
restart_container() {
    docker-compose -p postfix down
    docker-compose -p postfix up -d
    docker ps -a
}

# Function to display container status
display_status() {
    docker ps -a
}

# Main script
while true; do
    display_menu

    read -p "Enter your choice (1-4, q): " choice

    case "$choice" in
        1)
            restart_container
            ;;
        2)
            stop_container
            ;;
        3)
            start_container
            ;;
        4)
            display_status
            ;;
        q)
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 4, or 'q' to exit."
            ;;
    esac

    read -p "Press Enter to continue..."
    clear  # Clear the screen for the next iteration
done
```