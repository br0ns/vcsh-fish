function myip --description "Get Internet facing IP address"
   curl --silent wtfismyip.com/json | \
       grep -vE "\{|\}"             | \
       sed 's/\s\+"YourFucking//'   | \
       sed 's/": "/: /'             | \
       sed 's/",\?//'
end
