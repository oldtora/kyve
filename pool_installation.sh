# Устанавливаем unzip

sudo apt-get install wget unzip -y

----------------------------------------

#создаем папку kyve > заходим в неё > скачиваем зип файлы в папку (одной командой) (второй зип файл в будущем нужно будет изменить если планируете запускать другой пул)

mkdir $HOME/kyve; \ cd $HOME/kyve && \
wget https://github.com/KYVENetwork/evm/releases/download/v1.0.3/evm-linux.zip && \
wget https://github.com/kyve-org/near/releases/download/v0.0.0/kyve-near-linux.zip

----------------------------------------

# распаковываем файлы (одной командой)

unzip evm-linux.zip && \
unzip kyve-near-linux.zip

----------------------------------------

# даём максимальные пермиссии файлам (одной командой)

chmod u+x * && \
mv evm-linux /usr/bin/kyve-evm && \
mv kyve-near-linux /usr/bin/kyve-near

----------------------------------------

# создаём сервис и настраиваем валидатора: $POOL = номер пула который запускаете / "$MNEMONIC" = мнемоник кошелька с которым участвуете в тестнете / $STAKE = количество монет которые готовы отправить в стейкинг

sudo tee <<EOF >/dev/null /etc/systemd/system/kyved.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $BIN) \\
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

# приводите в чувства все сервисы (одной командой)

sudo systemctl daemon-reload && \
sudo systemctl enable kyved && \
sudo systemctl restart kyved

----------------------------------------

# команда для проверки логов

sudo journalctl -u kyved -f -o cat
