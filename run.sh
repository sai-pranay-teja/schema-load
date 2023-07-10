git clone https://github.com/sai-pranay-teja/$2 /app
cd /app

case $1 in
  mongo)
    curl -L curl -s -L https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -o /app/rds-combined-ca-bundle.pem
    mongo --ssl \
    --host $(aws ssm get-parameter --name ${env}.docdb.endpoint --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g'):27017 \
    --sslCAFile /app/rds-combined-ca-bundle.pem \
    --username $(aws ssm get-parameter --name ${env}.docdb.user --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
     --password $(aws ssm get-parameter --name ${env}.docdb.pass --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
      </app/schema/${2}.js
    ;;
  mysql)
    mysql -h $(aws ssm get-parameter --name ${env}.rds.endpoint --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
     -u$(aws ssm get-parameter --name ${env}.rds.user --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
     -p$(aws ssm get-parameter --name ${env}.rds.pass --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
      < /app/schema/${2}.sql
    ;;
  *)
    echo Schema loading supported only for mongo and mysql
    exit 1
    ;;
esac


