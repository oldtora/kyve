# Устанавливаем апдейты + unzip

sudo apt-get update && \
sudo apt-get upgrade -y && \
sudo apt-get install wget unzip -y

----------------------------------------

#создаем папку kyve > заходим в неё > скачиваем зип файл в папку (одной командой)

mkdir $HOME/kyve && \ 
cd $HOME/kyve && \ 
wget https://github.com/kyve-org/near/releases/download/v0.0.0/kyve-near-linux.zip

----------------------------------------

# распаковываем файлы

unzip kyve-near-linux.zip

----------------------------------------

# даём пермиссии (одной командой)

chmod u+x * && \ 
mv kyve-near-linux /usr/bin/kyve-near

----------------------------------------

# создаём сервис и настраиваем валидатора: $POOL = номер пула который запускаете / "$MNEMONIC" = мнемоник кошелька с которым участвуете в тестнете 
# $STAKE = количество монет которые готовы отправить в стейкинг # arweave.json вытягиваете из Arweave кошелька (пару монет нужно на комиссии) и закидываете в root

sudo tee <<EOF >/dev/null /etc/systemd/system/near.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart= /usr/bin/kyve-near \\
--poolId $POOL \\
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

----------------------------------------

# приводите в чувства сервис (одной командой)

sudo systemctl daemon-reload && \ 
sudo systemctl enable near && \ 
sudo systemctl restart near

----------------------------------------

# команда для проверки логов

sudo journalctl -u near -f -o cat
