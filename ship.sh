app_name=$1
app_version=$2
namespace=webclient



docker_process(){
        echo ">>>>>>>>>>>>>>>>>>> DOCKER IMAGE BUILD"

        docker build . -t $app_name:$app_version

        echo ">>>>>>>>>>>>>>>>>>> DOCKER IMAGE TAG"
        docker tag $app_name:$app_version hunaltay/$app_name:$app_version

        echo ">>>>>>>>>>>>>>>>>>> DOCKER IMAGE PUSH"
        docker push hunaltay/$app_name:$app_version


}
openshift_process_route(){
 echo ">>>>>>>>>>>>>>>>>>> OPENSHIFT: CREATE ROUTE"
if [[ $app_name  =~ "www" ]]; then

                oc create -f www.yaml
fi
}


openshift_process(){
              echo ">>>>>>>>>>>>>>>>>>> OPENSHIFT: CREATE APP"

              oc delete all --selector app=$app_name

              oc new-app hunaltay/$app_name:$app_version

              openshift_process_route



}


if [[ -n "$app_name" ]]; then
        if [[ -n "$app_version" ]]; then

        oc project $namespace

        docker_process

        openshift_process


        else
            echo "Put the app version"
        fi
else
    echo "Put the app name"
fi

