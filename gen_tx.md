```
cd $HOME
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config git make libssl-dev libclang-dev libclang-12-dev -y
sudo apt install jq build-essential bsdmainutils ncdu gcc git-core chrony liblz4-tool -y
sudo apt install original-awk uidmap dbus-user-session protobuf-compiler unzip -y
sudo apt install libudev-dev

sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
$HOME/.cargo/env
curl https://deb.nodesource.com/setup_20.x | sudo bash
sudo apt install cargo nodejs -y

cargo --version
node -v

if ! [ -x "$(command -v go)" ]; then   ver="1.21.6";   cd $HOME;   wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz";   sudo rm -rf /usr/local/go;   sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz";   rm "go$ver.linux-amd64.tar.gz";   echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile;   source ~/.bash_profile; fi

go version
protoc --version

echo "export NAMADA_TAG=v0.30.0" >> ~/.bash_profile
echo "export CBFT=v0.37.2" >> ~/.bash_profile
echo "export NAMADA_CHAIN_ID=" >> ~/.bash_profile
echo "export BASE_DIR=$HOME/.local/share/namada" >> ~/.bash_profile
echo "export VALIDATOR_ALIAS=*****************" >> ~/.bash_profile
source ~/.bash_profile

cd $HOME && git clone https://github.com/anoma/namada && cd namada && git checkout $NAMADA_TAG
make build-release
cd $HOME && git clone https://github.com/cometbft/cometbft.git && cd cometbft && git checkout $CBFT
make build

cd $HOME && cp $HOME/cometbft/build/cometbft /usr/local/bin/cometbft && cp "$HOME/namada/target/release/namada" /usr/local/bin/namada && cp "$HOME/namada/target/release/namadac" /usr/local/bin/namadac && cp "$HOME/namada/target/release/namadan" /usr/local/bin/namadan && cp "$HOME/namada/target/release/namadaw" /usr/local/bin/namadaw && cp "$HOME/namada/target/release/namadar" /usr/local/bin/namadar

cometbft version
namada --version

sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=namada
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.local/share/namada
Environment=TM_LOG_LEVEL=p2p:none,pex:error
Environment=NAMADA_CMT_STDOUT=true
ExecStart=/usr/local/bin/namada node ledger run 
StandardOutput=syslog
StandardError=syslog
Restart=always
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable namadad

#restore from mnemonics if u use extension 
#dont add BIP39 passw, just press enter
namadaw --pre-genesis derive --alias $VALIDATOR_ALIAS --unsafe-dont-encrypt

#or if u create wallet on local machine with CLI
#u can copy wallet.toml to pre-gen folder and go to 

TX_FILE_PATH="$HOME/.local/share/namada/pre-genesis/transactions.toml"
namadac utils init-genesis-established-account --path $TX_FILE_PATH --aliases $VALIDATOR_ALIAS

ESTABLISHED_ACCOUNT_ADDRESS=tnam1...

EMAIL="******"
DISCORD_HANDLE="******"
SELF_BOND_AMOUNT=2600000
IP_ADDRESS="******"

namadac utils init-genesis-validator --alias $VALIDATOR_ALIAS --address $ESTABLISHED_ACCOUNT_ADDRESS --path $TX_FILE_PATH --net-address "$IP_ADDRESS:26656" --commission-rate 0.05 --max-commission-rate-change 0.01 --self-bond-amount $SELF_BOND_AMOUNT --email $EMAIL  --discord-handle $DISCORD_HANDLE

namadac utils sign-genesis-txs     --path $TX_FILE_PATH     --output $BASE_DIR/pre-genesis/signed-transactions.toml     --alias $VALIDATOR_ALIAS

cp "$HOME/.local/share/namada/pre-genesis/signed-transactions.toml" "$HOME/.local/share/namada/pre-genesis/NAME_VALIDATOR.toml"
```
