array_exist() {
    echo "in array exists"
    element=$1
    arrayToBeSearched=$2
    echo "element to be Searched is "$element
    for i in ${arrayToBeSearched[@]}
    do
        if [[ "$i" == "$element" ]]
        then
            echo "testclass already exists"
            var=1
            return $var
        fi
    done
    echo "Test Class does not exists"
    var=0
    return $var
}

addClassName(){
    echo "in Add Classname Function"
    testClassToAdd=$1
    # specifiedClasses=$2

    array_exist "$testClassToAdd" "${specifiedClasses[@]}"
    echo $var
    if [[ $var -eq 0 ]]
    then
        ENTITY=${testClassToAdd%.cls}
        echo "class to be added is $ENTITY"
        # echo "var is $var"
        specifiedClasses+=($ENTITY)
        testLevel="RunSpecifiedTests"
    fi
}
#check if test scripts are to be executed or not.
testLevel="NoTestRun"
xml_target="deployDelta"
# CIRCLE_BRANCH="BAU-workflow-validate"
if [[ $CIRCLE_BRANCH == "BAU-Release" ]]
then
        xml_target="ValidatePreProd"
fi
echo $xml_target 
if [[ -d "deployChangeCode" ]] 
then

    #get the count of total number of metadata types which are changed
    count=$(xmllint --xpath "count(//*[local-name()='Package']/*[local-name()='types']/*[local-name()='name']/text())" ./deployChangeCode/package.xml)
    echo $count
    metadataTypeNames=() # Create array
    # store metadata types name in array
    for((i=1;$i<=$count;i++)) ; do
            metadataTypeNames+=($(xmllint --xpath "//*[local-name()='Package']/*[local-name()='types'][$i]/*[local-name()='name']/text()" ./deployChangeCode/package.xml))        
    done
    echo ${metadataTypeNames[@]}

    while read standardMetadataType
    do
        for deployMetadataType in ${metadataTypeNames[@]}
        do  
            echo deploymetadata is $deployMetadataType 
            if [[ $standardMetadataType == $deployMetadataType ]]
            then
                testLevel="RunLocalTests" #set test level to run local tests.
                echo "both metadatatypes are same"
                echo $testLevel
                break  #break the loop if any one of the metadatatype is matching standard metadata
            fi
        done
        if [[ $testLevel == "RunLocalTests" ]]
        then
            
            specifiedClasses=() # initialize an array to store testclasses name. This will be used to add runTests tag in build.xml
            
            #check if any mandatory testclasses are mentioned in Mandatory tests.txt
            if [[ -s ./config/MandatoryTests.txt ]]
            then
                
                testLevel="RunSpecifiedTests"
                echo testLevel is $testLevel
                for testClassName in $(cat ./config/MandatoryTests.txt)
                do
                    BASENAME=${testClassName%.cls}
                    specifiedClasses+=($BASENAME)
                    echo 
                done
            fi
            # check if classes are being deloyed
            if [[ -d deployChangeCode/classes ]]
            then
                cd deployChangeCode/classes
                testLevel="RunSpecifiedTests"
                # Pick test classes for each class from TestsClasses.json file
                for entry in *.cls
                do
                    echo "classname is  $entry"
                    if [[ $entry == *Test.cls ]]
                    then
                        addClassName "$entry"
                    else

                        testClassDeploy=`jq -r --arg className "$entry" '.[] | select(.class == $className).testClass' ../../config/TestClasses.json`
                        echo $testClassDeploy
                        IFS=',' read -ra commSepTest <<< "$testClassDeploy" #split comma separated test classes names.
                        echo "comma separated tests classes name are ${commSepTest[@]} "
                        for testClass in ${commSepTest[@]}; do
                            echo $testClass
                            addClassName "$testClass"
                        done
                        unset commSepTest
                    fi      
                done
                cd ../..
                echo ${specifiedClasses[@]}
            fi
            echo $testLevel
            for specifiedTestclass in ${specifiedClasses[@]}
            do 
                xmlstarlet ed -L -s "project/target[@name='$xml_target']/sf:deploy" -t elem -n runTest -v $specifiedTestclass build.xml
            done
            break
        fi
    done < ./config/MetadataTypes.txt
    echo $testLevel
    
    xmlstarlet ed -L -u "project/target[@name='$xml_target']/sf:deploy/@testLevel" -v $testLevel build.xml
fi
