package main

import (
	"encoding/json"
	"log"
	"os"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
	_ "shared_ledger/migrations"
)

type OtpRequest struct {
	Email string `json:"email"`
}

type ChangePasswordRequest struct {
	Password string `json:"password"`
}

func changePassword(e *core.RequestEvent) error {
	var body ChangePasswordRequest
	err := json.NewDecoder(e.Request.Body).Decode(&body)
	if err != nil {
		return err
	}

	if len(body.Password) < 8 {
		return e.Error(400, "Password must be at least 8 characters long", nil)
	}

	rec := e.Auth
	rec.SetPassword(body.Password)
	err = e.App.Save(rec)
	if err != nil {
		return err
	}

	return e.Next()
}

func main() {
	app := pocketbase.New()

	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Automigrate: false,
	})

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		// serves static files from the provided public dir (if exists)
		se.Router.GET("/{path...}", apis.Static(os.DirFS("./pb_public"), false))

		se.Router.POST("/api/collections/users/change-password", changePassword).Bind(apis.RequireAuth())

		return se.Next()
	})

	app.OnRecordRequestOTPRequest("users").BindFunc(func(e *core.RecordCreateOTPRequestEvent) error {
		if e.Record != nil {
			return e.Next()
		}

		var body OtpRequest
		json.NewDecoder(e.Request.Body).Decode(&body)

		rec := core.NewRecord(e.Collection)
		rec.Set("email", body.Email)
		rec.SetRandomPassword()

		err := e.App.Save(rec)
		if err != nil {
			return err
		}

		e.Record = rec

		return e.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
