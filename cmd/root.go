package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"os"

	"github.com/spf13/viper"
)

var cfgFile string

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "workspace",
	Short: "Tool to manage mentos1386/workspace repository",
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default workspace.toml)")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
    viper.SetConfigType("toml")
		viper.AddConfigPath(".")
    viper.SetConfigName("workspace")
	}

	viper.AutomaticEnv() // read in environment variables that match

	err := viper.ReadInConfig()
  if err != nil {
    panic(fmt.Errorf("Fatal error reading config file: %s \n", err))
  }
}

