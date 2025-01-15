package main

import (
	"database/sql"
	"fmt"
	"log"
	"math/rand"
	"strconv"
	"time"

	_ "github.com/lib/pq"
	_ "github.com/mattn/go-sqlite3"
)

const (
	host        = "localhost"
	port        = 54322
	user        = "postgres"
	password    = "postgres"
	dbname      = "postgres"
	tokenLength = 50
)

type SupaUser struct {
	Id    string
	Email string
}

type SupaContact struct {
	Id          int
	UserUid     string
	Email       sql.NullString
	Name        string
	PhoneNumber sql.NullString
	CreatedAt   time.Time
}

type SupaLedger struct {
	Id          int
	UserUid     string
	Name        string
	Description sql.NullString
	CreatedAt   time.Time
}

type SupaTransaction struct {
	Id            int
	LedgerId      int
	ContactId     int
	Amount        float64
	Comment       string
	CreatedAt     time.Time
	TransactionAt time.Time
}

func generateRandomString(length int) string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	seededRand := rand.New(rand.NewSource(time.Now().UnixNano()))
	randomString := make([]byte, length)
	for i := range randomString {
		randomString[i] = charset[seededRand.Intn(len(charset))]
	}
	return string(randomString)
}

func main() {
	// PostgreSQL connection
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	postgresDB, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		log.Fatal(err)
	}
	defer postgresDB.Close()

	err = postgresDB.Ping()
	if err != nil {
		log.Fatal(err)
	}

	// SQLite connection
	sqliteDB, err := sql.Open("sqlite3", "../backend/pb_data/data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer sqliteDB.Close()

	migrate_users(postgresDB, sqliteDB)
	migrate_contacts(postgresDB, sqliteDB)
	migrate_ledgers(postgresDB, sqliteDB)
	migrate_transactions(postgresDB, sqliteDB)
}

func migrate_users(postgresDB *sql.DB, sqliteDB *sql.DB) {
	// Query data from PostgreSQL
	rows, err := postgresDB.Query("SELECT id, email FROM auth.users")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var users []SupaUser
	for rows.Next() {
		var user SupaUser
		err := rows.Scan(&user.Id, &user.Email)
		if err != nil {
			log.Fatal(err)
		}
		users = append(users, user)
	}

	// Insert data into SQLite
	insertQuery := `INSERT INTO users (id, email, tokenKey, password) VALUES (?, ?, ?, ?)`
	for _, user := range users {
		tokenKey := generateRandomString(tokenLength)
		password := generateRandomString(30)
		_, err := sqliteDB.Exec(insertQuery, user.Id, user.Email, tokenKey, password)
		if err != nil {
			log.Printf("Error inserting user %s: %v", user.Id, err)
		}
	}

	fmt.Printf("Successfully imported %d users to SQLite.\n", len(users))
}

func migrate_contacts(postgresDB *sql.DB, sqliteDB *sql.DB) {
	// Query data from PostgreSQL
	rows, err := postgresDB.Query("SELECT id, user_uid, email, name, phone_number, created_at FROM public.contacts")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var contacts []SupaContact
	for rows.Next() {
		var contact SupaContact
		err := rows.Scan(&contact.Id, &contact.UserUid, &contact.Email, &contact.Name, &contact.PhoneNumber, &contact.CreatedAt)
		if err != nil {
			log.Fatal(err)
		}
		contacts = append(contacts, contact)
	}

	// Insert data into SQLite
	insertQuery := `INSERT INTO contacts (id, user_id, email, name, phone_number, created) VALUES (?, ?, ?, ?, ?, ?)`
	for _, contact := range contacts {
		if !contact.Email.Valid {
			contact.Email.String = ""
		}
		if !contact.PhoneNumber.Valid {
			contact.PhoneNumber.String = ""
		}
		_, err := sqliteDB.Exec(insertQuery, strconv.Itoa(contact.Id), contact.UserUid, contact.Email.String, contact.Name, contact.PhoneNumber.String, contact.CreatedAt)
		if err != nil {
			log.Printf("Error inserting contact %s: %v", contact.UserUid, err)
		}
	}

	fmt.Printf("Successfully imported %d contacts to SQLite.\n", len(contacts))
}

func migrate_ledgers(postgresDB *sql.DB, sqliteDB *sql.DB) {
	// Query data from PostgreSQL
	rows, err := postgresDB.Query("SELECT id, user_uid, name, description, created_at FROM public.ledgers")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var ledgers []SupaLedger
	for rows.Next() {
		var ledger SupaLedger
		err := rows.Scan(&ledger.Id, &ledger.UserUid, &ledger.Name, &ledger.Description, &ledger.CreatedAt)
		if err != nil {
			log.Fatal(err)
		}
		ledgers = append(ledgers, ledger)
	}

	// Insert data into SQLite
	insertQuery := `INSERT INTO ledgers (id, user_id, name, description, created) VALUES (?, ?, ?, ?, ?)`
	for _, ledger := range ledgers {
		if !ledger.Description.Valid {
			ledger.Description.String = ""
		}
		_, err := sqliteDB.Exec(insertQuery, strconv.Itoa(ledger.Id), ledger.UserUid, ledger.Name, ledger.Description.String, ledger.CreatedAt)
		if err != nil {
			log.Printf("Error inserting ledger %s: %v", ledger.UserUid, err)
		}
	}

	fmt.Printf("Successfully imported %d ledgers to SQLite.\n", len(ledgers))
}

func migrate_transactions(postgresDB *sql.DB, sqliteDB *sql.DB) {
	// Query data from PostgreSQL
	rows, err := postgresDB.Query("SELECT id, ledger_id, contact_id, amount, comment, created_at, transaction_at FROM public.transactions")
	if err != nil {
		log.Fatal(err)
	}
	var transactions []SupaTransaction
	for rows.Next() {
		var transaction SupaTransaction
		err := rows.Scan(&transaction.Id, &transaction.LedgerId, &transaction.ContactId, &transaction.Amount, &transaction.Comment, &transaction.CreatedAt, &transaction.TransactionAt)
		if err != nil {
			log.Fatal(err)
		}
		transactions = append(transactions, transaction)
	}

	// Insert data into SQLite
	insertQuery := `INSERT INTO transactions (id, ledger_id, contact_id, amount, comment, created, transaction_at) VALUES (?, ?, ?, ?, ?, ?, ?)`
	for _, transaction := range transactions {
		_, err := sqliteDB.Exec(insertQuery, strconv.Itoa(transaction.Id), strconv.Itoa(transaction.LedgerId), strconv.Itoa(transaction.ContactId), transaction.Amount, transaction.Comment, transaction.CreatedAt, transaction.TransactionAt)
		if err != nil {
			log.Printf("Error inserting transaction %d: %v", transaction.LedgerId, err)
		}
	}

	fmt.Printf("Successfully imported %d transactions to SQLite.\n", len(transactions))
}
