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

```bash
# 拉取镜像
docker pull coderuner/canary-demo:release-0.3

# 导入镜像到 k3d 集群
k3d image import coderuner/canary-demo:release-0.5 -c canary-demo
```

## Kubernetes 操作

### 查看 Pods
```bash
kubectl get pods
```

### 应用部署配置
```bash
# 应用稳定版本部署
kubectl apply -f stable-deployment.yaml

# 应用金丝雀部署
kubectl apply -f canary-deployment.yaml

# 应用 ingress 配置
kubectl apply -f canary-demo-ingress.yaml

# 应用稳定版本服务
kubectl apply -f stable-service.yaml
```

### 临时通道
```bash
kubectl port-forward pod/canary-demo-stable-9f7985bbb-kkxgk 18080:8080
```

## 标签
- k3d
- kubernetes
- canary-deployment
- demo


