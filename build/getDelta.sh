LCOMMIT=$(git log --format="%H" -n 1)
WSPACE=$(pwd)
LOGFILENAME=$WSPACE/delta.log
mkdir $WSPACE/build/gitCommit/
cd $WSPACE/build/gitCommit/
# CIRCLE_BRANCH="develop"

echo "downloading previouscommit file from s3 bucket"
aws s3 sync s3://oau-crm-salesforce-metadatabackup/hive/$CIRCLE_BRANCH .
ls -l

BNAME="prevCommit"
# $CIRCLE_PREVIOUS_BUILD_NUM
echo Build Name: $BNAME
echo Workspace: $WSPACE
echo Last Commit: $LCOMMIT
SCRIPTFILE=$WSPACE'/build/gitCommit/'$BNAME'.txt'
echo scriptfile is $SCRIPTFILE
echo Searching for script file $SCRIPTFILE...
if [[ ! -d "$WSPACE/target" ]]
                then
                        echo "create target directory"
                        mkdir $WSPACE/target
                else 
                        echo "remove dummy file"
                        rm -rf $WSPACE/target/*
                fi
if [ -e $SCRIPTFILE ]
then

        PREVRSA=$(<$SCRIPTFILE) &&
        echo Found previous SHA $PREVRSA
        if [[ `git diff-tree --no-commit-id --name-only -r $PREVRSA $LCOMMIT | grep force-app | wc -l` > 0 ]] 
        then
                git diff --name-status $PREVRSA $LCOMMIT |  grep force-app | 
                awk '{FS="\t"; gsub("force-app/main/default/", "") ; if($1 =="M") print "Modified" "," $2; else if($1 == "D") print "Deleted" "," $2; else if($1 == "A") print "Added" ","$2 ;else print "Renamed" "," $2;}'| 
                sed 's/\(.*\)\//\1,/' | awk BEGIN{'FS=","; OFS=",";}{print $1,$2,$3,$3}' | 
                sed 's|\.[a-zA-Z]*-meta\.xml||' > test.csv 
                awk 'BEGIN{FS=",";OFS=",";print "Status","Component Type","Component API name","File changed";}1' test.csv > $WSPACE/release_notes.csv
                rm -rf test.csv
        # rm -rf $WSPACE/target/test.txt
                echo "below are changed file from previos commit $PREVRSA to the lates commit $LCOMMIT :" >> $LOGFILENAME
                git diff-tree --no-commit-id --name-only -r $PREVRSA $LCOMMIT| grep force-app | awk '{ print "\""$0"\""}' >> $WSPACE/getDiff.txt

                git diff-tree --no-commit-id --name-only -r $PREVRSA $LCOMMIT | grep force-app >> $LOGFILENAME
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILENAME
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILENAME
                
                # for CFILE in `git diff-tree --no-commit-id --name-only -r $LCOMMIT $PREVRSA | grep force-app`
                while read CFILE
                do
                        echo Analyzing file `basename "$CFILE"` >> $LOGFILENAME
                        
                        cd ${WSPACE}/force-app/main/default
                        ENTITY=$(basename "$CFILE")
                        # echo $ENTITY
                        
                        prefix="force-app/main/default/"
                        # echo Prefix is $prefix
                        temp="${CFILE%\"}"
                        CFILE="${temp#\"}"
                        echo cfile is "$CFILE" >> $LOGFILENAME
                        filename=${CFILE#"$prefix"}
                        echo file name is $filename >> $LOGFILENAME
                        echo filename prefix is ${filename%.*} >> $LOGFILENAME
                        # echo all files without extension "${filename%.*}"
                        # echo ${ENTITY}
                        # file_count=find . -name $file_name | wc -l
                        if [[ -f "$WSPACE/$CFILE" ]] 
                        then
                                # echo $CFILE file exists
                                if [[ "$WSPACE/$CFILE" == *"aura"* ]]
                                then
                                        # echo "Aura exists"
                                        cp -r --parent "${filename%/*}"/* ${WSPACE}/target/
                                else
                                        # echo "Aura does not exists"
                                        cp -r --parent "${filename%-*}"* ${WSPACE}/target/
                                fi
                        else 
                                echo filename $CFILE does not exist >> $LOGFILENAME
                                echo "------------------------------------------------------------------------------------------------" >> $LOGFILENAME
                        fi
                        
                        if [[ -f "$WSPACE/$CFILE" ]] 
                        then
                                # echo $CFILE file exists
                                if [[ "$WSPACE/$CFILE" == *"lwc"* ]]
                                then
                                        # echo "LWC exists"
                                        cp --parent "${filename%/*}"/* ${WSPACE}/target/
                                else
                                        # echo "LWC does not exists"
                                        cp --parent "${filename%-*}"* ${WSPACE}/target/
                                fi
                        else 
                                echo filename $CFILE does not exist >> $LOGFILENAME
                                echo "------------------------------------------------------------------------------------------------" >> $LOGFILENAME
                        fi
                        
                done < ${WSPACE}/getDiff.txt
                cd ${WSPACE}
                pwd
                ls -l
                if [ ! "$(ls -A target)"]
                then
                        echo "all files are of delete mode in this commit. Hence no deployment is required."
                else
                        chmod +x ./build/mdapiConvert.sh
                        ./build/mdapiConvert.sh ./deployChangeCode ./target
                fi
                # cd ${WSPACE}/target/
                cd target
                ls -l
                # ls -l aura/*
        else
                echo "no changes in code"
        fi
else
        echo No RSA found 
        cd ${WSPACE}
        ls -l
        echo "Whole code will be deployed"
        chmod +x ./build/mdapiConvert.sh
        ./build/mdapiConvert.sh ./deployChangeCode ./force-app
fi
