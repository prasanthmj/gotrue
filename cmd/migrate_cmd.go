package cmd

import (
	"net/url"

	"github.com/gobuffalo/pop"
	"github.com/netlify/gotrue/conf"
	"github.com/pkg/errors"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

func createMigrateCommand() *cobra.Command {

	var migrateCmd = cobra.Command{
		Use:  "migrate",
		Long: "Migrate database strucutures. This will create new tables and add missing columns and indexes.",
		Args: cobra.MinimumNArgs(1),
	}

	var migrateUpCommand = &cobra.Command{
		Use:   "up",
		Long:  "migrate up the database.",
		Short: "migrate up the database",
		Run:   migrateUp,
	}

	migrateCmd.AddCommand(migrateUpCommand)

	var migrateResetCommand = &cobra.Command{
		Use:   "reset",
		Long:  "reset the database.",
		Short: "reset the database so that to start fresh",
		Run:   migrateReset,
	}

	migrateCmd.AddCommand(migrateResetCommand)

	return &migrateCmd
}

func migrateUp(cmd *cobra.Command, args []string) {
	logrus.Printf(" migrate up command ")
	migrate("up")
}

func migrateReset(_ *cobra.Command, _ []string) {
	migrate("reset")
}

func migrate(op string) {

	globalConfig, err := conf.LoadGlobal(configFile)
	if err != nil {
		logrus.Fatalf("Failed to load configuration: %+v", err)
	}
	if globalConfig.DB.Driver == "" && globalConfig.DB.URL != "" {
		u, err := url.Parse(globalConfig.DB.URL)
		if err != nil {
			logrus.Fatalf("%+v", errors.Wrap(err, "parsing db connection url"))
		}
		globalConfig.DB.Driver = u.Scheme
	}
	pop.Debug = true

	deets := &pop.ConnectionDetails{
		Dialect: globalConfig.DB.Driver,
		URL:     globalConfig.DB.URL,
	}
	if globalConfig.DB.Namespace != "" {
		deets.Options = map[string]string{
			"Namespace": globalConfig.DB.Namespace + "_",
		}
	}

	db, err := pop.NewConnection(deets)
	if err != nil {
		logrus.Fatalf("%+v", errors.Wrap(err, "opening db connection"))
	}
	defer db.Close()

	if err := db.Open(); err != nil {
		logrus.Fatalf("%+v", errors.Wrap(err, "checking database connection"))
	}

	logrus.Infof("Reading migrations from %s", globalConfig.DB.MigrationsPath)
	mig, err := pop.NewFileMigrator(globalConfig.DB.MigrationsPath, db)
	if err != nil {
		logrus.Fatalf("%+v", errors.Wrap(err, "creating db migrator"))
	}
	logrus.Infof("before status")
	err = mig.Status()
	if err != nil {
		logrus.Fatalf("%+v", errors.Wrap(err, "migration status"))
	}
	// turn off schema dump
	mig.SchemaPath = ""

	switch op {
	case "up":
		err = mig.Up()
	case "reset":
		err = mig.Reset()
	}

	if err != nil {
		logrus.Fatalf("%+v", errors.Wrap(err, "running db migrations"))
	}

	logrus.Infof("after status")
	err = mig.Status()
	if err != nil {
		logrus.Fatalf("%+v", errors.Wrap(err, "migration status"))
	}
}
