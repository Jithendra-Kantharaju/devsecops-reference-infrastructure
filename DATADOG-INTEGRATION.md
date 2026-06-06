# Datadog Integration with OpenTelemetry

This guide explains how to integrate Datadog with your Tic Tac Toe application using OpenTelemetry for comprehensive observability.

## 📊 Architecture Overview

```
Your Application (OpenTelemetry SDK)
           ↓
OpenTelemetry Collector (in Kubernetes)
           ↓
Datadog Exporter
           ↓
Datadog SaaS Platform (Monitoring & Observability)
```

## 🚀 Quick Start

### 1. **Set Your Datadog API Key**

Store your Datadog API key as a Kubernetes secret:

```bash
# Create namespace
kubectl create namespace datadog

# Create secret with your Datadog API key
kubectl create secret generic datadog-secret \
  --from-literal=api-key=YOUR_DATADOG_API_KEY \
  -n datadog

# Verify
kubectl get secret datadog-secret -n datadog
```

### 2. **Deploy OpenTelemetry Collector with Datadog Exporter**

Apply the configuration:

```bash
kubectl apply -f kubernetes/datadog/otel-collector-config.yaml
kubectl apply -f kubernetes/datadog/otel-collector-deployment.yaml
```

### 3. **Update Your Application Deployment**

The deployment already includes OTEL environment variables. Just ensure it points to the collector:

```yaml
env:
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: "http://otel-collector:4317"  # gRPC endpoint
- name: OTEL_TRACES_EXPORTER
  value: "otlp"
- name: OTEL_METRICS_EXPORTER
  value: "otlp"
```

## 📈 What You'll Monitor in Datadog

### **Traces (Distributed Tracing)**
- Game action traces (move, reset, etc.)
- API response times
- Error traces with full context
- Service dependencies

### **Metrics**
- Application performance metrics
- Container resource usage
- HTTP request metrics
- Custom business metrics

### **Logs**
- Application logs
- Kubernetes events
- Error logs with context

## 🔧 Configuration Files

### **OpenTelemetry Collector Configuration**
Located at: `kubernetes/datadog/otel-collector-config.yaml`

Key components:
- **Receivers**: Accept OTLP data from applications
- **Processors**: Batch and process telemetry
- **Exporters**: Send to Datadog
- **Pipelines**: Define data flow

### **Datadog Exporter Settings**

```yaml
exporters:
  datadog:
    api:
      key: ${DATADOG_API_KEY}  # From Kubernetes secret
    site: datadoghq.com        # Or datadoghq.eu for EU
    host_metadata:
      enabled: true             # Send host metadata
    resource_attributes:
      enabled: true
    tag_by_host: true           # Tag by hostname
```

## 🎯 Integration Points

### **1. Application Instrumentation**
Your app already includes OpenTelemetry SDK setup in `src/telemetry/opentelemetry-setup.ts`

### **2. Custom Spans**
Use the tracing context in `src/telemetry/tracing-context.ts`:

```typescript
import { instrumentGameAction } from './src/telemetry/tracing-context';

// In your game component
const handleMove = () => {
  instrumentGameAction('game:move', () => {
    // Your game logic
  });
};
```

### **3. Metrics Export**
Metrics automatically exported via OTLP to Datadog

## 🔐 Security

### **API Key Management**
- Store in Kubernetes secret (never in code)
- Use restrictive IAM policies
- Rotate regularly
- Monitor API key usage

### **Data Privacy**
- Configure PII redaction if needed
- Use sampling for high-volume traces
- Encrypt data in transit (HTTPS)

## 📊 Datadog Features You'll Use

### **APM (Application Performance Monitoring)**
- Trace requests end-to-end
- Identify bottlenecks
- Track service dependencies

### **Dashboards**
- Real-time metrics visualization
- Custom business KPIs
- Alert thresholds

### **Alerts & Incidents**
- Performance degradation alerts
- Error rate monitoring
- Resource utilization alerts

### **Logs**
- Centralized log management
- Full-text search
- Log-trace correlation

## 🛠️ Deployment Steps

### **Step 1: Create Namespace**
```bash
kubectl create namespace datadog
```

### **Step 2: Store API Key**
```bash
kubectl create secret generic datadog-secret \
  --from-literal=api-key=YOUR_API_KEY \
  -n datadog
```

### **Step 3: Deploy Collector**
```bash
kubectl apply -f kubernetes/datadog/otel-collector-config.yaml
kubectl apply -f kubernetes/datadog/otel-collector-deployment.yaml
```

### **Step 4: Verify**
```bash
# Check collector pod
kubectl get pods -n datadog

# View logs
kubectl logs -l app=otel-collector -n datadog

# Check endpoints
kubectl get svc -n datadog
```

### **Step 5: Access Datadog Dashboard**
1. Go to https://app.datadoghq.com
2. Navigate to **APM > Services** to see your application
3. Navigate to **Logs** to see application logs
4. Create custom dashboards

## 🔍 Verification

### **Check Metrics Flow**
```bash
# Port-forward to collector
kubectl port-forward -n datadog svc/otel-collector 4317:4317

# From another terminal, check metrics endpoint
curl http://localhost:4317/metrics
```

### **Verify Data in Datadog**
1. Go to APM > Services
2. Look for "tic-tac-toe" service
3. Check for traces

### **View Logs**
1. Navigate to Logs section
2. Filter by `service:tic-tac-toe`

## 🚨 Troubleshooting

### **No Data Appearing in Datadog**

**Check 1: API Key**
```bash
# Verify secret was created
kubectl get secret datadog-secret -n datadog -o jsonpath='{.data.api-key}' | base64 -d
```

**Check 2: Collector Logs**
```bash
kubectl logs -l app=otel-collector -n datadog
```

**Check 3: Application Connection**
```bash
# From app pod
kubectl exec -it deployment/tic-tac-toe -- sh
curl http://otel-collector:4317 -v
```

### **High Latency or Data Loss**

- Increase batch processor size
- Adjust sampling rates
- Check network policies

## 📚 Advanced Features

### **Custom Metrics**
Export custom business metrics to Datadog:

```typescript
import { metrics } from '@opentelemetry/api';

const meter = metrics.getMeter('game-metrics');
const gameCounter = meter.createCounter('games_played');

gameCounter.add(1, { result: 'win' });
```

### **Log Correlation**
Logs are automatically correlated with traces via trace IDs

### **Service Map**
Datadog automatically generates service maps showing dependencies

## 📖 Resources

- [Datadog OpenTelemetry Documentation](https://docs.datadoghq.com/tracing/connect_open_telemetry/)
- [OpenTelemetry Datadog Exporter](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/datadogexporter)
- [Datadog APM Best Practices](https://docs.datadoghq.com/tracing/guide/)

## ✅ Next Steps

1. ✅ Add your Datadog API key to Kubernetes secret
2. ✅ Deploy OpenTelemetry Collector
3. ✅ Deploy your application with OTEL configuration
4. ✅ Access Datadog dashboard
5. ✅ Create custom dashboards and alerts

Your application will now have enterprise-grade observability with Datadog! 🎉
