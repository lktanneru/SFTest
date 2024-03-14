if [[ ! -d "target" ]]
then
        mkdir target
else
        rm -rf target/*
fi
echo "Converting to MDAPI format..."
sfdx force:source:convert -d ./deployCode -r $1

