#!/bin/bash
#
#
## validations
# 1- check correct number of parameter
# 2- check if file exist
# 3- check if we have read permission
# 4- id is unique (check database not file maybe, because what if an invaliid entry stops a valid entry with the same id)
# 5- id in an integer
# 6- name is valid (no numbers no sympols)
# 7- total is a number
# 8- check date is valid
## Exit codes:
#   0: Success
#   1: Invalid Parameters
#   2: file doesn't exist
#   3: no read permission on file

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
CO=1
# make valid_invoices file
echo -n > valid_invoice
### Read the LINE from std/input
while read LINE
do
    # check if each line has an error
    ERROR=0
    # NO INPUT?
    ID=$(echo ${LINE} | awk -F':' '{print $1}')
    NAME=$(echo ${LINE} | awk -F':' '{print $2}')
    TOTAL=$(echo ${LINE} | awk -F':' '{print $3}')
    DATE=$(echo ${LINE} | awk -F'"' '{print $2}')

    #check if id is 1-positive, 2-integer 
    if [[ $(echo ${ID} | grep -Pc "\D") -eq 1 ]]
    then
        echo "error: invalid ID, ID is not a positive integer in line: ${CO}"
        ERROR=$[ERROR+1]
    fi

    # check name is a valid name
    if [[ $(echo ${NAME} | grep -Pc "[^a-zA-Z\s]") -eq 1 ]]
    then
        echo "error: invalid name in line: ${CO}"
        ERROR=$[ERROR+1]
    fi

    # check total is a number, regex need to be redone
    if [[ $(echo ${TOTAL} | grep -Pcv "^[\d]+(\.\d+)?") -eq 1 ]]
    then
        echo "error: invalid total in line ${CO}, total must be a positive "
        ERROR=$[ERROR+1]
    fi

    #check date is valid
    if [[ $(date -d "${DATE}" 2>&1 | grep -c "invalid date") -eq 1 ]]
    then
        echo "error: invalid date in line: ${CO}"
        ERROR=$[ERROR+1]
    fi

	echo "${CO}----${ID} : ${NAME} : ${TOTAL} : ${DATE} ---- errors:${ERROR}"
    if [[ ${ERROR} -eq 0 ]]
    then
        # append
        echo "${ID}, '${NAME}', ${TOTAL}, '${DATE}'" >> valid_invoice
    fi
	CO=$[CO+1]
	###Redirect the input from keyboard to file passed
done < ${FILENAME}
exit 0

# insert valids into valid_invoice
# echo -n > valid_invoice

#CAN'T CHECK UNIQUENESS OF AN ID it involves a database request and response on each line
#the better way to do it is to leave the database to handle it
#it's better not to check it on file either if an invaliid entry stops a valid entry with the same id from going to the valid_invoice file