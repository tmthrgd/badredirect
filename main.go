package main

import (
	crand "crypto/rand"
	"encoding/binary"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"strings"
)

func main() {
	var seed int64
	binary.Read(crand.Reader, binary.LittleEndian, &seed)
	rand.Seed(seed)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8090"
	}

	http.ListenAndServe(":"+port, http.HandlerFunc(redirectHandler))
}

func redirectHandler(w http.ResponseWriter, r *http.Request) {
	i, _ := strconv.ParseInt(strings.TrimPrefix(r.URL.Path, "/"), 10, 64)
	to, _ := r.URL.Parse(fmt.Sprintf("/%d", i+1))
	to.Scheme = "https"
	to.Host = fmt.Sprintf("%x.badredirect.tmthrgd.dev", rand.Intn(16))
	w.Header().Set("Connection", "close")
	http.Redirect(w, r, to.String(), http.StatusTemporaryRedirect)
}
