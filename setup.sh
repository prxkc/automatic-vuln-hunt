#!/bin/bash
apt-get update -y && apt-get upgrade -y && apt-get install git tmux python3-full pip -y && bash <(curl -sL https://git.io/go-installer) && source /root/.bashrc && apt install libpcap-dev && mkdir /root/.config && mkdir /root/.config/pip && echo -e "[global]\nbreak-system-packages = true" > /root/.config/pip/pip.conf &&  echo "[+] Setup Complete Successfully"; 

################ SUBFINDER #############################
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest;
#################################################################################


################ PUREDNS ################################################
git clone https://github.com/blechschmidt/massdns.git;
cd massdns;
make;
sudo make install;

cd ~;

go install github.com/d3mondev/puredns/v2@latest;
#################################################################################


################ DNSGEN ###############################################
git clone https://github.com/ProjectAnte/dnsgen;
cd dnsgen;
pip3 install -r requirements.txt;
python3 setup.py install;
cd ~;
#################################################################################

################ ANEW #####################################################
go install -v github.com/tomnomnom/anew@latest
#################################################################################


################# NUCLEI ################################################
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
#################################################################################

######################## NAABU #################################################
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
#################################################################################

######################## HTTPX #######################################
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
######################################################################

######################## WAYMORE ########################
git clone https://github.com/xnl-h4ck3r/waymore.git;
cd waymore;
pip install -r requirements.txt;
python3 setup.py install;
cd ~;
#################################################################################

################################ xnLinkFinder ####################################
git clone https://github.com/xnl-h4ck3r/xnLinkFinder.git;
cd xnLinkFinder;
sudo python3 setup.py install;
cd ~;
##################################################################################

################################ trufflehog ####################################
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin
##################################################################################

################################ wayfiles ####################################
go install github.com/Rffrench/wayfiles@latest
################################ wayfiles ####################################



######################################### URO ####################################
pip3 install uro
#################################################################################

######################################### NOTIFY ################################
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
#################################################################################

######################################### dsieve ################################
go install github.com/trickest/dsieve@latest
#################################################################################

######################################### prips #################################
go install github.com/imusabkhan/prips@latest
#################################################################################

go install github.com/hakluke/hakrevdns@latest

####################### KXSS #########################################
go install github.com/Emoe/kxss@latest;
#################################################################################


####################################### KSSTI ####################################
go install github.com/whalebone7/kssti@latest
#################################################################################

############################ DALFOX ############################
go install github.com/hahwul/dalfox/v2@latest
#################################################################################

###################### FUZZING TEMPLATES NUCLEI ###############################
git clone https://github.com/projectdiscovery/fuzzing-templates.git
#################################################################################

################################## WORDLISTS ####################################
wget https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt -P ~/wordlists
wget https://raw.githubusercontent.com/trickest/wordlists/main/inventory/levels/level1.txt -P ~
wget https://raw.githubusercontent.com/trickest/wordlists/main/inventory/levels/level2.txt -P ~
wget https://raw.githubusercontent.com/trickest/wordlists/main/inventory/levels/level3.txt -P ~
wget https://raw.githubusercontent.com/trickest/wordlists/main/inventory/levels/levels4plus.txt -P ~
#################################################################################