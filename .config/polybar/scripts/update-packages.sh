#!/bin/bash

apt_output=$(apt upgrade 2>&1 | grep "Instalados" | cut -d ' ' -f 2)

# Obtém o número de pacotes atualizados usando o awk
num_updated=$(echo "$apt_output" | awk -F/ '{print $1}')

# Exibe a notificação com a porcentagem de pacotes atualizados
notify-send "Atualização do APT" "Pacotes atualizados: $num_updated"
