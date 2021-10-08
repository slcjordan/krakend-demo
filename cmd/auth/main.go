package main

import (
	"fmt"
	"net/http"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "{\"auth\": true}\n")
}

func main() {
	http.HandleFunc("/hello", hello)

	fmt.Println("listening on port 8090")
	fmt.Println(http.ListenAndServe(":8090", nil))
}
