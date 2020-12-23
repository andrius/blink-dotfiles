package cmd

import (
	"fmt"
  "os"
  "path"
  "text/template"

	"github.com/spf13/cobra"
  "github.com/spf13/viper"
)

// templateCmd represents the template command
var templateCmd = &cobra.Command{
	Use:   "template",
	Short: "Template a specific file as described in config",
  Args: cobra.ExactArgs(1),
  Run: func(cmd *cobra.Command, args []string) {
    templateName := args[0]
    templateFile := viper.GetString(fmt.Sprintf("templates.%s.template", templateName))
    templateVars := viper.Get(fmt.Sprintf("templates.%s.vars", templateName))

    workspaceTemplate := template.New(path.Base(templateFile))
    workspaceTemplate = workspaceTemplate.Delims("[[[", "]]]")

    tmpl:= template.Must(workspaceTemplate.ParseFiles(templateFile))

    err := tmpl.Execute(os.Stdout, templateVars)
    if err != nil {
      panic(fmt.Errorf("Failed %s", err))
    }
	},
}

func init() {
	rootCmd.AddCommand(templateCmd)
}

