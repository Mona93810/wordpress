The WordPress website is live and accessible at the following URL: [https://wordpresstask.ddns.net](https://wordpresstask.ddns.net)

For administrative access, you can visit the WordPress admin dashboard at: [https://wordpresstask.ddns.net/wp-admin/](https://wordpresstask.ddns.net/wp-admin/)

# WordPress Deployment on AWS EC2 with Nginx and Terraform

This document outlines the successful deployment of a WordPress website on an AWS EC2 instance using the Nginx web server, MySQL, PHP (LEMP stack), and Terraform for provisioning. The deployment was completed with a focus on security best practices and website performance optimization.

## Server Provisioning

### AWS EC2 Instance

- *Provisioned an EC2 instance*(ec2.tf) running Ubuntu 22.04(ami-053b0d53c279acc90) on AWS using Terraform.
- *Configured Security Groups* to allow only necessary inbound and outbound traffic.
- *Utilized User Data* for initial setup, installing Nginx, MySQL, PHP, and WordPress.
- *Stored Terraform state files* in an S3 bucket for better state management.

## Website Configuration

### WordPress Setup

- *Deployed WordPress* on the EC2 instance.
- *Secured MySQL installation* with a strong password and limited user privileges.
- *Created a WordPress database* with a specific user for enhanced security.

### SSL/TLS Implementation

- *Implemented Let's Encrypt SSL certificate* for secure communication between the server and clients.
sudo apt-get install -y certbot python3-certbot-nginx
# Request a certificate for the domain, agreeing to the Terms of Service and providing an email address
sudo certbot --nginx -d wordpresstask.ddns.net --agree-tos --email monabommakanti@gmail.com --no-eff-email


### Nginx Optimization

- *Configured Nginx* specifically for WordPress hosting.
- *Enabled gzip compression* to enhance website performance, reducing loading times for users.

## GitHub Actions CI/CD Pipeline

- *Created a GitHub repository* containing all code and configuration files.
- *Set up a GitHub Actions workflow* for automated deployment, including steps to install dependencies, build the project, and securely transfer files to the server.
- *Utilized AWS secrets* for secure storage and usage of AWS access keys within the pipeline.

## Security Measures

- *Implemented security best practices* for both server and WordPress installation, including strong passwords and access control.
- *Utilized a secure Linux distribution* (Ubuntu 22.04) and applied necessary firewall rules.

## Performance Considerations

- *Optimized Nginx server configuration* including efficient caching and gzip compression.
- *Monitored website performance* to ensure optimal user experience.


## Conclusion

The deployment of the WordPress website on AWS EC2 using Nginx and Terraform was successfully completed. The project adhered to best practices for security, functionality, and performance. The automated deployment through GitHub Actions ensures a streamlined and repeatable process for future updates and maintenance.


