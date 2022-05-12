# Быстрой установки как у NodesGuru у меня нету, я слишком тупой ещё. 
# Часть с быстрым для скачиванием, распаковкой и тд в будущем сделаю. Настройка сервиса пока только ручная.

----------------------------------------

# устанавливаем апдейты + unzip

sudo apt-get update && \
sudo apt-get upgrade -y && \
sudo apt-get install wget unzip -y

----------------------------------------

# создаем папку kyve > заходим в неё > скачиваем зипы всех на данный момент пулов в папку (одной командой)

mkdir $HOME/kyve && \
cd $HOME/kyve && \
wget https://github.com/kyve-org/evm/releases/download/v1.0.5/kyve-evm-linux.zip && \
wget https://github.com/kyve-org/solana/releases/download/v0.0.1/kyve-solana-linux.zip && \
wget https://github.com/kyve-org/celo/releases/download/v0.0.0/kyve-celo-linux.zip && \
wget https://github.com/kyve-org/near/releases/download/v0.0.0/kyve-near-linux.zip && \
wget https://github.com/kyve-org/bitcoin/releases/download/v0.0.0/kyve-bitcoin-linux.zip && \
wget https://github.com/kyve-org/zilliqa/releases/download/v0.0.0/kyve-zilliqa-linux.zip

----------------------------------------

# распаковываем файлы (одна команда)

unzip kyve-solana-linux.zip && \
unzip kyve-evm-linux.zip && \
unzip kyve-celo-linux.zip && \
unzip kyve-zilliqa-linux.zip && \
unzip kyve-bitcoin-linux.zip && \
unzip kyve-near-linux.zip

----------------------------------------

# даём пермиссии

chmod u+x * && \
mv kyve-near-linux /usr/bin/kyve-near && \
mv kyve-solana-linux /usr/bin/kyve-solana && \
mv kyve-celo-linux /usr/bin/kyve-celo && \
mv kyve-zilliqa-linux /usr/bin/kyve-zilliqa && \
mv kyve-evm-linux /usr/bin/kyve-evm && \
mv bitcoin-linux /usr/bin/kyve-bitcoin

----------------------------------------

# создаём сервис и настраиваем валидатора:
# "$MNEMONIC" = мнемоник кошелька с которым участвуете в тестнете (нужно вручную вставить)
# $STAKE = количество монет которые готовы отправить в стейкинг (нужно вручную вставить)
# arweave.json вытягиваете из Arweave кошелька (пару монет нужно на комиссии) и закидываете в root


# MOONBEAM

sudo tee <<EOF >/dev/null /etc/systemd/system/moonbeam.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-evm \\
--poolId 0 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable moonbeam && \ 
sudo systemctl restart moonbeam

# Проверяем логи
sudo journalctl -u moonbeam -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y >ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/moonbeam.service

----------------------------------------

# AVAX

sudo tee <<EOF >/dev/null /etc/systemd/system/avax.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-evm \\
--poolId 1 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable avax && \ 
sudo systemctl restart avax

# Проверяем логи
sudo journalctl -u avax -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y >ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/avax.service

----------------------------------------

# BITCOIN

sudo tee <<EOF >/dev/null /etc/systemd/system/bitcoin.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-bitcoin \\
--poolId 3 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable bitcoin && \ 
sudo systemctl restart bitcoin

# Проверяем логи
sudo journalctl -u bitcoin -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y >ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/bitcoin.service

----------------------------------------

# SOLANA

sudo tee <<EOF >/dev/null /etc/systemd/system/solana.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-solana \\
--poolId 4 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable solana && \ 
sudo systemctl restart solana

# Проверяем логи
sudo journalctl -u solana -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y > ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/solana.service

----------------------------------------

# ZILLIQA

sudo tee <<EOF >/dev/null /etc/systemd/system/zilliqa.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-zilliqa \\
--poolId 5 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable zilliqa && \ 
sudo systemctl restart zilliqa

# Проверяем логи
sudo journalctl -u zilliqa -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y >ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/zilliqa.service

----------------------------------------

# NEAR

sudo tee <<EOF >/dev/null /etc/systemd/system/near.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-near \\
--poolId 6 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF


# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable near && \ 
sudo systemctl restart near

# Проверяем логи
sudo journalctl -u near -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y >ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/near.service

----------------------------------------

# CELO

sudo tee <<EOF >/dev/null /etc/systemd/system/celo.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-celo \\
--poolId 7 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable celo && \ 
sudo systemctl restart celo

# Проверяем логи
sudo journalctl -u celo -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y >ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/celo.service

----------------------------------------

# EVMOS

sudo tee <<EOF >/dev/null /etc/systemd/system/evmos.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-evm \\
--poolId 8 \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервис
sudo systemctl daemon-reload && \ 
sudo systemctl enable aevmos && \ 
sudo systemctl restart evmos

# Проверяем логи
sudo journalctl -u evmos -f -o cat

# Изменить настройки сервиса (как сделали правки > CTRL X > Y >ENTER и запускаем релоуд демона + рестарт сервиса. В основном для изменение к-ства стейка монет)
nano /etc/systemd/system/evmos.service

----------------------------------------
