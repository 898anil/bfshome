package main

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strconv"

	server "github.com/898anil/bfs_server"
)

func staticFileHandler(req *server.Request) *server.Response {
	staticPath := "public"
	absPath, _ := filepath.Abs(staticPath)
	path := req.Path
	if path == "/" {
		path = "/index.html"
	}
	file, err := os.Open(absPath + path)
	if err != nil {
		return &server.Response{
			Headers: map[string]string{
				"Status": "HTTP/1.1 404 Not Found",
			},
			Body: []byte("404 Not Found"),
		}
	}
	defer file.Close()
	if err != nil {
		return &server.Response{
			Headers: map[string]string{
				"Status": "HTTP/1.1 404 Not Found",
			},
			Body: []byte("404 Not Found"),
		}
	}
	fileInfo, err := file.Stat()
	if err != nil {
		return &server.Response{
			Headers: map[string]string{
				"Status": "HTTP/1.1 404 Not Found",
			},
			Body: []byte("404 Not Found"),
		}
	}
	fileExtension := filepath.Ext(path)
	mimeType := "application/octet-stream" // default MIME type

	switch fileExtension {
	case ".html", ".htm":
		mimeType = "text/html"
	case ".css":
		mimeType = "text/css"
	case ".js":
		mimeType = "application/javascript"
	case ".json":
		mimeType = "application/json"
	case ".png":
		mimeType = "image/png"
	case ".jpg", ".jpeg":
		mimeType = "image/jpeg"
	case ".gif":
		mimeType = "image/gif"
	case ".svg":
		mimeType = "image/svg+xml"
	case ".xml":
		mimeType = "application/xml"
	case ".pdf":
		mimeType = "application/pdf"
	}

	content, err := io.ReadAll(file)
	if err != nil {
		return &server.Response{
			Headers: map[string]string{
				"Status": "HTTP/1.1 500 Internal Server Error",
			},
			Body: []byte("500 Internal Server Error"),
		}
	}

	return &server.Response{
		Headers: map[string]string{
			"Status":         "HTTP/1.1 200 OK",
			"Content-Type":   mimeType,
			"Content-Length": strconv.FormatInt(fileInfo.Size(), 10),
		},
		Body: content,
	}
}

func main() {
	fmt.Println("Starting server on port 8080")
	router := server.NewRouter()
	router.Add(server.Route{Path: "/*", Handler: staticFileHandler})
	server := &server.Server{
		Router: *router,
		Port:   "8080",
	}
	server.ListenAndServe()
}
