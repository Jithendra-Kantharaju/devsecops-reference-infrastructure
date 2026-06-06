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

// The OTLP exporter validates this with `new URL()`, which REQUIRES an
// absolute URL — a relative path like "/v1/traces" throws and would crash
// the app on load. We build an absolute URL from the current origin so the
// browser posts same-origin to /v1/traces, which nginx proxies to the
// in-cluster collector in production. Override with VITE_OTLP_ENDPOINT.
function resolveEndpoint(): string {
  const configured = import.meta.env.VITE_OTLP_ENDPOINT as string | undefined;
  if (configured && /^https?:\/\//.test(configured)) return configured;
  const origin =
    typeof window !== "undefined" ? window.location.origin : "http://localhost";
  const path = configured && configured.startsWith("/") ? configured : "/v1/traces";
  return origin + path;
}

// Telemetry must NEVER break the app. If anything here throws, we log and
// continue so the UI still renders.
export function initTelemetry(): void {
  try {
    const provider = new WebTracerProvider({
      resource: new Resource({
        [ATTR_SERVICE_NAME]: "tic-tac-toe",
        [ATTR_SERVICE_VERSION]: "1.0.0",
        "deployment.environment": import.meta.env.MODE,
      }),
      spanProcessors: [
        new BatchSpanProcessor(new OTLPTraceExporter({ url: resolveEndpoint() })),
      ],
    });

    provider.register({ contextManager: new ZoneContextManager() });

    registerInstrumentations({
      instrumentations: [
        new DocumentLoadInstrumentation(),
        new FetchInstrumentation(),
      ],
    });

    if (import.meta.env.DEV) {
      console.log("OpenTelemetry web tracing initialized:", resolveEndpoint());
    }
  } catch (err) {
    console.warn("OpenTelemetry init skipped:", err);
  }
}

initTelemetry();