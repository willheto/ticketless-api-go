package database

import (
	"database/sql"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func ConnectDatabase() (*sql.DB, error) {
	log.Printf("Connecting to the database...")

	db, err := sql.Open("mysql", "ticketless:test@tcp(127.0.0.1:3306)/ticketlessLocal")
	if err != nil {
		log.Fatalf("Could not connect to the database: %v\n", err)
		return nil, err
	}

	err = db.Ping()
	if err != nil {
		log.Fatalf("Could not ping the database: %v\n", err)
		return nil, err
	}

	return db, nil
}
