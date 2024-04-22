package main

import (
	"log"
	"ticketless-api-go/database"
	"ticketless-api-go/server"
)

func main() {
	db, err := database.ConnectDatabase()

	if err != nil {
		log.Fatalf("Could not connect to the database: %v\n", err)
	}

	server.SetupRoutes(db)

}
