import { trace, context, SpanStatusCode } from "@opentelemetry/api";

const tracer = trace.getTracer("tic-tac-toe-game", "1.0.0");

export function instrumentGameAction(actionName: string, handler: () => void) {
  const span = tracer.startSpan(actionName);
  return context.with(trace.setSpan(context.active(), span), () => {
    try {
      handler();
      span.addEvent("action_completed", { status: "success" });
      span.setStatus({ code: SpanStatusCode.OK });
    } catch (error) {
      span.recordException(error as Error);
      span.setStatus({
        code: SpanStatusCode.ERROR,
        message: (error as Error).message,
      });
      throw error;
    } finally {
      span.end();
    }
  });
}
