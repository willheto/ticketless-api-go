package controllers

import (
	"database/sql"
	"log"
	"net/http"
	"ticketless-api-go/models"

	"github.com/gin-gonic/gin"
)

func GetAllEvents(c *gin.Context) {
	db := c.MustGet("db").(*sql.DB)

	events, err := models.GetAllEvents(db)
	if err != nil {
		log.Fatalf("Could not get events: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not get events"})
		return
	}

	c.JSON(http.StatusOK, events)
}
