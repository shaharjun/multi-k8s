docker build -t arjunshah/multi-client:latest -t arjunshah/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t arjunshah/multi-server:latest -t arjunshah/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t arjunshah/multi-worker:latest -t arjunshah/multi-worker:$SHA -f ./worker/Dockerfile ./worker


docker login docker.io
docker push arjunshah/multi-client:latest
docker login docker.io
docker push arjunshah/multi-server:latest
docker login docker.io
docker push arjunshah/multi-worker:latest

docker login docker.io
docker push arjunshah/multi-client:$SHA
docker login docker.io
docker push arjunshah/multi-server:$SHA
docker login docker.io
docker push arjunshah/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=arjunshah/multi-server:$SHA
kubectl set image deployments/client-deployment client=arjunshah/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=arjunshah/multi-worker:$SHA

