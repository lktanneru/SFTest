echo "Deploying to Dev Sandbox & running all tests..."
ant deployUnpackaged -Dsf.username=$1 -Dsf.password=$2 -Dsf.serverurl=$3
