package models

import (
	"database/sql"
	"log"
)

type Event struct {
	EventID        int      `json:"eventID"`
	OrganizationID *int     `json:"organizationID"`
	Name           string   `json:"name"`
	Location       string   `json:"location"`
	Type           string   `json:"type"`
	Date           string   `json:"date"`
	Image          string   `json:"image"`
	IsPublic       bool     `json:"isPublic"`
	Status         string   `json:"status"`
	TicketSaleUrl  string   `json:"ticketSaleUrl"`
	ActiveFrom     *string  `json:"activeFrom"`
	ActiveTo       *string  `json:"activeTo"`
	TrendingScore  int      `json:"trendingScore"`
	TicketMaxPrice *float64 `json:"ticketMaxPrice"`
	Created_at     string   `json:"createdAt"`
	Updated_at     string   `json:"updatedAt"`
}

func GetAllEvents(db *sql.DB) ([]Event, error) {
	rows, err := db.Query("SELECT * FROM events")
	if err != nil {
		log.Fatalf("Could not get events: %v\n", err)
		return nil, err
	}
	defer rows.Close()

	events := []Event{}
	for rows.Next() {
		var event Event
		err := rows.Scan(
			&event.EventID,
			&event.OrganizationID,
			&event.Name,
			&event.Location,
			&event.Type,
			&event.Date,
			&event.Image,
			&event.IsPublic,
			&event.Status,
			&event.TicketSaleUrl,
			&event.ActiveFrom,
			&event.ActiveTo,
			&event.TrendingScore,
			&event.TicketMaxPrice,
			&event.Created_at,
			&event.Updated_at,
		)
		if err != nil {
			log.Printf("Error scanning row: %v\n", err)
			return nil, err
		}
		events = append(events, event)
	}

	if err := rows.Err(); err != nil {
		log.Printf("Error iterating rows: %v\n", err)
		return nil, err
	}

	return events, nil
}
