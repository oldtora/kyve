# Быстрой установки как у NodesGuru у меня нету, я слишком тупой ещё. 
# Часть с быстрым для скачиванием, распаковкой и тд в будущем сделаю. Настройка сервиса пока только ручная.

----------------------------------------

# Устанавливаем апдейты + unzip

sudo apt-get update && \
sudo apt-get upgrade -y && \
sudo apt-get install wget unzip -y

----------------------------------------

# создаем папку kyve > заходим в неё > скачиваем зип файл в папку (одной командой)
# если ставим другой пул, то ищем бинарник https://github.com/kyve-org > имя бинарника, например solana > справа в углу releases > смотрим версию и получаем примерно:
# https://github.com/kyve-org/solana/releases/download/v0.0.1/kyve-solana-linux.zip

mkdir $HOME/kyve && \ 
cd $HOME/kyve && \ 
wget https://github.com/kyve-org/near/releases/download/v0.0.0/kyve-near-linux.zip

----------------------------------------

# распаковываем файлы. в случае другого бинарника, подставляем имя zip файла. например kyve-solana-linux.zip

unzip kyve-near-linux.zip

----------------------------------------

# даём пермиссии. на примере Solana > /usr/bin/kyve-solana (одной командой)

chmod u+x * && \ 
mv kyve-near-linux /usr/bin/kyve-near

----------------------------------------

# создаём сервис и настраиваем валидатора: ExecStart= вместо near, по примеру solana путь будет такой: /usr/bin/kyve-solana
# $POOL = номер пула который запускаете / "$MNEMONIC" = мнемоник кошелька с которым участвуете в тестнете 
# $STAKE = количество монет которые готовы отправить в стейкинг # arweave.json вытягиваете из Arweave кошелька (пару монет нужно на комиссии) и закидываете в root
# near.service меняете на любое другое, к примеру пул Solana > solana.sevice / kyvesolana.service

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

# приводите в чувства сервис. если изменяли имя сервиса- near меняете на то, что взяли при установке. (одной командой)

sudo systemctl daemon-reload && \ 
sudo systemctl enable near && \ 
sudo systemctl restart near

----------------------------------------

# команда для проверки логов. имя сервиса near изменяете на то, что поставили при установке сервиса

sudo journalctl -u near -f -o cat
