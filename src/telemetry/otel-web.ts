import { WebTracerProvider } from "@opentelemetry/sdk-trace-web";
import { BatchSpanProcessor } from "@opentelemetry/sdk-trace-base";
import { OTLPTraceExporter } from "@opentelemetry/exporter-trace-otlp-http";
import { ZoneContextManager } from "@opentelemetry/context-zone";
import { registerInstrumentations } from "@opentelemetry/instrumentation";
import { DocumentLoadInstrumentation } from "@opentelemetry/instrumentation-document-load";
import { FetchInstrumentation } from "@opentelemetry/instrumentation-fetch";
import { Resource } from "@opentelemetry/resources";
import {
  ATTR_SERVICE_NAME,
  ATTR_SERVICE_VERSION,
} from "@opentelemetry/semantic-conventions";

function resolveEndpoint(): string {
  const configured = import.meta.env.VITE_OTLP_ENDPOINT as string | undefined;
  if (configured && /^https?:\/\//.test(configured)) return configured;
  const origin =
    typeof window !== "undefined" ? window.location.origin : "http://localhost";
  const path = configured && configured.startsWith("/") ? configured : "/v1/traces";
  return origin + path;
}

let provider: WebTracerProvider;

export function initTelemetry(): void {
  try {
    provider = new WebTracerProvider({
      resource: new Resource({
        [ATTR_SERVICE_NAME]: "tic-tac-toe",
        [ATTR_SERVICE_VERSION]: "1.0.0",
        "deployment.environment": import.meta.env.MODE,
      }),
    });

    const exporter = new OTLPTraceExporter({ 
      url: resolveEndpoint(),
      headers: {
        "Content-Type": "application/protobuf",
      }
    });

    provider.addSpanProcessor(new BatchSpanProcessor(exporter));
    provider.register({ contextManager: new ZoneContextManager() });

    registerInstrumentations({
      instrumentations: [
        new DocumentLoadInstrumentation(),
        new FetchInstrumentation(),
      ],
    });

    if (import.meta.env.DEV) {
      console.log("✅ OpenTelemetry initialized. Endpoint:", resolveEndpoint());
    }
  } catch (err) {
    console.warn("⚠️ OpenTelemetry init failed:", err);
  }
}

export function getTracerProvider(): WebTracerProvider {
  return provider;
}

initTelemetry();
