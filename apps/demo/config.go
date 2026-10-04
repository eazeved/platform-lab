package main

import (
	"os"
	"strconv"
)

var version = "dev" // set via -ldflags

type Config struct {
	Port string
	// ErrorRate (0-1) injects 5xx responses; used to exercise SLO alerts and canary analysis.
	ErrorRate float64
	// ExtraLatencyMs adds artificial latency to /api/hello.
	ExtraLatencyMs int
}

func LoadConfig() Config {
	c := Config{Port: getenv("PORT", "8080")}
	c.ErrorRate, _ = strconv.ParseFloat(getenv("ERROR_RATE", "0"), 64)
	c.ExtraLatencyMs, _ = strconv.Atoi(getenv("EXTRA_LATENCY_MS", "0"))
	return c
}

func getenv(k, d string) string {
	if v := os.Getenv(k); v != "" {
		return v
	}
	return d
}
