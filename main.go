package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8090"
	}

	http.ListenAndServe(":"+port, http.HandlerFunc(redirectHandler))
}

func redirectHandler(w http.ResponseWriter, r *http.Request) {
	i, _ := strconv.ParseInt(strings.TrimPrefix(r.URL.Path, "/"), 10, 64)
	http.Redirect(w, r, fmt.Sprintf("/%d", i+1), http.StatusTemporaryRedirect)
}
