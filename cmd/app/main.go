package main

import (
	"fmt"
	"net/http"
	"time"

	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

func main() {
	viper.SetConfigName("application")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("./config")
	viper.AddConfigPath("/opt/service/config")

	if err := viper.ReadInConfig(); err != nil {
		log.WithError(err).Fatal("error reading config")
	}

	http.HandleFunc("/go-template/api/v1/health/status/", healthCheck)

	log.WithFields(log.Fields{
		"host": viper.GetString("server.host"),
		"port": viper.GetString("server.port"),
	}).Info("starting application server")

	http.ListenAndServe(fmt.Sprintf(":%s", viper.GetString("server.port")), nil)
}

func healthCheck(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello from Kubernetes!\n"))
	w.Write([]byte(fmt.Sprintf("Health status report successful at: %s", time.Now())))
	w.WriteHeader(http.StatusOK)
}
