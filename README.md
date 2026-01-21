# canary-demo

## 集群管理

### 删除集群
```bash
k3d cluster delete canary-demo
```

### 创建集群
```bash
k3d cluster create canary-demo \
  --agents 1 \
  --port "80:80@loadbalancer"
```

## 镜像管理

### 镜像使用步骤
需要将镜像拉到本地并传给 k3s：

# 拉取镜像
docker pull coderuner/canary-demo:release-0.3
docker pull coderuner/canary-demo:release-0.5

# 导入镜像到 k3d 集群
k3d image import coderuner/canary-demo:release-0.3 -c canary-demo
k3d image import coderuner/canary-demo:release-0.5 -c canary-demo
### 快速部署脚本


```
kubectl --kubeconfig $(k3d kubeconfig write canary-demo) \                         
  apply -f stable-deployment.yaml \
           -f canary-deployment.yaml \
           -f stable-service.yaml \
           -f canary-service.yaml \
           -f traefik_service.yaml \
           -f ingressroute.yaml



for i in {1..30}; do curl http://localhost; done
```