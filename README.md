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
docker pull coderuner/canary-demo:release-0.5

# 导入镜像到 k3d 集群
k3d image import coderuner/canary-demo:release-0.3 -c canary-demo
k3d image import coderuner/canary-demo:release-0.5 -c canary-demo
```

## Kubernetes 部署流程

### 部署顺序

**正确的启动顺序**（按依赖关系）：

1. **部署稳定版本**：先创建稳定版本的 Deployment 和 Service
2. **部署金丝雀版本**：再创建金丝雀版本的 Deployment 和 Service  
3. 部署负载均衡
3. **配置 Ingress**：最后创建 Ingress 来分配流量

### 详细部署步骤

```bash
# 1. 部署稳定版本
kubectl $(k3d kubeconfig write canary-demo) apply -f stable-deployment.yaml      # 稳定版本Pod（3个副本）
kubectl $(k3d kubeconfig write canary-demo) apply -f stable-service.yaml         # 稳定版本服务（canary-demo-stable）

# 2. 部署金丝雀版本
kubectl $(k3d kubeconfig write canary-demo) apply -f canary-deployment.yaml      # 金丝雀版本Pod（2个副本）
kubectl $(k3d kubeconfig write canary-demo) apply -f canary-service.yaml         # 金丝雀版本服务（canary-demo-canary）

# 3. 部署Traefik服务（用于流量分配）
kubectl $(k3d kubeconfig write canary-demo) apply -f traefik_service.yaml        # Traefik服务配置（实现80:20流量分配）

# 4. 配置Ingress（流量入口）
kubectl $(k3d kubeconfig write canary-demo) apply -f canary-demo-ingress.yaml
```

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