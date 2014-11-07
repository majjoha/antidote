# Notes
* Type checking this way has huge performance costs.
* We could utilize TracePoint or set_trace_func, but that would force us to
  trace on all the executed code.
* It may be worthwhile defining the new functions as interpolated strings and
  `eval` instead of using define_singleton_method and define_method.
* It should also be able to type check the return value.
