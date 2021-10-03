#!/bin/bash
#reads valid_invoices_details file
#insert it into invoice_details database line by line




if [[ ${#} -ne 1 ]]
then
    echo "Invalid Parameters: script accepts only 1 parameter"
    exit 1
fi
#check if it exists
FILENAME=${1}
if [[ ! -f ${FILENAME} ]]
then
    echo "file doesn't exist"
    exit 2 
fi
#check permission
if [[ ! -r ${FILENAME} ]]
then
    echo "no read permission"
    exit 3
fi


psql -d shellscriptinglab -h localhost -U postgres -c "truncate invoice_details;"
set IFS=$'\n'
while read LINE

do
# valid invoice_details is separated by commas
psql -d shellscriptinglab -h localhost -U postgres -c "insert into public.invoice_details(id, inv_id, item, quantity, unit) values (${LINE});"

done < ${FILENAME}
exit 0


