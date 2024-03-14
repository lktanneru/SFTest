
# cd ../deployCode
# # ls -l
# LCOMMIT=$(git log --format="%H" -n 1)
# echo $LCOMMIT 
# WORKSPACE=$(pwd)
# echo $WORKSPACE
# ./build/getDelta.sh -b $1 -w $WORKSPACE -l $LCOMMIT 
# if [[ ! -d "target"  ]] 
# then
#         mkdir target
# fi
echo "Converting target folder to MDAPI format..."
DESTINATION_DIR=$1
ROOT_DIR=$2
sfdx force:source:convert -d $DESTINATION_DIR -r $ROOT_DIR