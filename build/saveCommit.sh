echo "saving this commitId as passed build number"
LCOMMIT=$(git log --format="%H" -n 1)
WSPACE=$(pwd)
COMMITPATH=$WSPACE/build/gitCommit
echo current commit $LCOMMIT
echo current workspace $WSPACE
echo commit path $COMMITPATH
if [[ -f $COMMITPATH/prevCommit.txt ]] 
then
    echo "file exists"
    echo "deleting previous commit file" 
    rm -rf $COMMITPATH/prevCommit.txt
else
    mkdir -p $COMMITPATH
fi

echo $LCOMMIT > $COMMITPATH/prevCommit.txt
echo "syncing with s3 bucket"
# cd $WSPACE/build
aws s3 sync $COMMITPATH s3://oau-crm-salesforce-metadatabackup/hive/$CIRCLE_BRANCH --exclude='*' --include='prevCommit.txt' --delete
