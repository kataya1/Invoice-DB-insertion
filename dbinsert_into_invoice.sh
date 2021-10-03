#!/bin/bash
#reades valid_invoices file
#insert it into invoice database line by line
#check correct parameter
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
# defining env variables
# source "./env" #we'll get there when we get there
psql -d shellscriptinglab -h localhost -U postgres -c "truncate invoice cascade;"
set IFS=$'\n'
while read LINE

do
# valid invoice is separated by commas
psql -d shellscriptinglab -h localhost -U postgres -c "insert into public.invoice(id, client_name, total, time ) values (${LINE}) ;"

done < ${FILENAME}
exit 0


# test
# psql -d shellscriptinglab -h localhost -U postgres -c "insert into public.invoice (id, client_name, total, time) values(10, 'niga higa', 100.31, '2001-10-01 13:10:08.764');"