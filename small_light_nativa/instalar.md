cd small_light_nativa

# 1. Instalar (requiere sudo)
sudo ./install.sh

# 2. Iniciar nginx
sudo ./deploy_native.sh all

# 3. Añadir al hosts si no tienes DNS:
echo "127.0.0.1 images.antonio.me" | sudo tee -a /etc/hosts

# 4. Acceder:
# https://images.antonio.me
