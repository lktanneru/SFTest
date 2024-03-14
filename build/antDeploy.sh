echo "Deploying to Dev Sandbox & running all tests..."
ant deployUnpackaged -Dsf.accesstoken=$1 -Dsf.serverurl=$2
