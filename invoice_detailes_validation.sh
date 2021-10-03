#!/bin/bash
###
###
# validation
# 1- check correct number of parameter
# 2- check if file exist
# 3- check if we have read permission


# 1- seq in an integer
# 2- id integer and exists in database (since we need a request and a response we'll leave this part to the database)
# 3- quantity is number
# some items have numbers and sympols in it's name we're not gonna validate it
# 4- unit is a valid word

## Exit codes:
#   0: Success
#   1: Invalid Parameters
#   2: file doesn't exist
#   3: no read permission on file

#check correct parameter
if [ ${#} -ne 1 ]
then
    echo "Invalid Parameters: script accepts only 1 filename "
    exit 1
fi
#check if it exists
FILE=${1}
if [ ! -f ${FILE} ]
then
    echo "file doesn't exist"
    exit 2 
fi
#check permission
if [ ! -r ${FILE} ]
then
    echo "no read permission"
    exit 3
fi

CO=1
# make valid_invoices_detailes file
echo -n > valid_invoice_details

while read LINE
do
    # check if each line has an error
    ERROR=0
    # NO INPUT?
    SEQ=$(echo ${LINE} | awk -F':' '{print $1}')
    INVID=$(echo ${LINE} | awk -F':' '{print $2}')
    ITEM=$(echo ${LINE} | awk -F':' '{print $3}')
    QUANTITY=$(echo ${LINE} | awk -F':' '{print $4}')
    UNIT=$(echo ${LINE} | awk -F':' '{print $5}')

        #check if sequence is 1-positive, 2-integer 
    if [[ $(echo ${SEQ} | grep -Pc "\D") -eq 1 ]]
    then
        echo "error: invalid ID, ID is not a positive integer in line: ${CO}"
        ERROR=$[ERROR+1]
    fi

        #check if invoice id is 1-positive, 2-integer 
    if [[ $(echo ${INVID} | grep -Pc "\D") -eq 1 ]]
    then
        echo "error: invalid ID, ID is not a positive integer in line: ${CO}"
        ERROR=$[ERROR+1]
    fi

        # check quantit is a number, regex need to be redone
    if [[ $(echo ${QUANTITY} | grep -Pcv "^[\d]+(\.\d+)?") -eq 1 ]]
    then
        echo "error: invalid total in line ${CO}, total must be a positive "
        ERROR=$[ERROR+1]
    fi

        # check unit is  valid 
    if [[ $(echo ${NAME} | grep -Pc "[^a-zA-Z/]") -eq 1 ]]
    then
        echo "error: invalid name in line: ${CO}"
        ERROR=$[ERROR+1]
    fi

	echo "${CO}----${SEQ} : ${INVID} : ${ITEM} : ${QUANTIT} : ${UNIT} ---- errors:${ERROR}"
    if [[ ${ERROR} -eq 0 ]]
    then
        # append
        echo "${SEQ}, ${INVID}, '${ITEM}', ${QUANTITY}, '${UNIT}'" >> valid_invoice_details
    fi
	CO=$[CO+1]
	###Redirect the input from keyboard to file passed
done < ${FILE}
exit 0
# insert valids into valid_invoice_details
# echo -n > valid_invoice_details