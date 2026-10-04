package main

import (
	"encoding/json"
	"math/rand/v2"
	"net/http"
	"strconv"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	reqTotal = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "http_requests_total", Help: "HTTP requests by route and status code.",
	}, []string{"route", "code"})
	reqDuration = promauto.NewHistogramVec(prometheus.HistogramOpts{
		Name:    "http_request_duration_seconds",
		Help:    "HTTP request latency.",
		Buckets: []float64{.01, .05, .1, .3, .5, 1, 2},
	}, []string{"route"})
)

type statusRecorder struct {
	http.ResponseWriter
	code int
}

func (r *statusRecorder) WriteHeader(c int) { r.code = c; r.ResponseWriter.WriteHeader(c) }

func instrument(route string, h http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		rec := &statusRecorder{ResponseWriter: w, code: http.StatusOK}
		h(rec, r)
		reqTotal.WithLabelValues(route, strconv.Itoa(rec.code)).Inc()
		reqDuration.WithLabelValues(route).Observe(time.Since(start).Seconds())
	}
}

func NewRouter(cfg Config) http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, _ *http.Request) { w.WriteHeader(http.StatusOK) })
	mux.HandleFunc("GET /readyz", func(w http.ResponseWriter, _ *http.Request) { w.WriteHeader(http.StatusOK) })
	mux.Handle("GET /metrics", promhttp.Handler())
	mux.HandleFunc("GET /api/hello", instrument("/api/hello", func(w http.ResponseWriter, _ *http.Request) {
		if cfg.ExtraLatencyMs > 0 {
			time.Sleep(time.Duration(cfg.ExtraLatencyMs) * time.Millisecond)
		}
		if cfg.ErrorRate > 0 && rand.Float64() < cfg.ErrorRate {
			http.Error(w, "injected failure", http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{"message": "hello from platform-lab", "version": version})
	}))
	return mux
}
