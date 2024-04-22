package server

import (
	"database/sql"
	"ticketless-api-go/controllers"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(db *sql.DB) {
	router := gin.Default()
	router.Use(func(c *gin.Context) {
		c.Set("db", db)
		c.Next()
	})
	router.SetTrustedProxies([]string{"127.0.0.1"})

	// Public endpoints
	public := router.Group("/")
	{
		public.GET("events", controllers.GetAllEvents)
	}

	router.Run()
}
