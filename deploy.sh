docker build -t arjunshah/multi-client:latest -t arjunshah/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t arjunshah/multi-server:latest -t arjunshah/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t arjunshah/multi-worker:latest -t arjunshah/multi-worker:$SHA -f ./worker/Dockerfile ./worker


echo "$DOCKER_PASSWORD | docker login -u ""$DOCKER_USERNAME" --password-stdin
docker push arjunshah/multi-client:latest
echo "$DOCKER_PASSWORD | docker login -u ""$DOCKER_USERNAME" --password-stdin
docker push arjunshah/multi-server:latest
echo "$DOCKER_PASSWORD | docker login -u ""$DOCKER_USERNAME" --password-stdin
docker push arjunshah/multi-worker:latest

echo "$DOCKER_PASSWORD | docker login -u ""$DOCKER_USERNAME" --password-stdin
docker push arjunshah/multi-client:$SHA
echo "$DOCKER_PASSWORD | docker login -u ""$DOCKER_USERNAME" --password-stdin
docker push arjunshah/multi-server:$SHA
echo "$DOCKER_PASSWORD | docker login -u ""$DOCKER_USERNAME" --password-stdin
docker push arjunshah/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=arjunshah/multi-server:$SHA
kubectl set image deployments/client-deployment client=arjunshah/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=arjunshah/multi-worker:$SHA

