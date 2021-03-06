package main

import (
	"fmt"
	"os"
	"os/user"
	"path/filepath"

	"gopkg.in/ini.v1"
)

func main() {
	currentUser, _ := user.Current()
	awsCredentialsPath := filepath.Join(currentUser.HomeDir, ".aws/credentials")

	awsCredentialsFile, err := ini.Load(awsCredentialsPath)
	if err != nil {
		fmt.Printf("Fail to read file: %v", err)
		os.Exit(1)
	}
	profileList := awsCredentialsFile.SectionStrings()[1:] //[1:] removes the DEFAULT section

	if len(os.Args) > 1 {
		requestedProfile := os.Args[1]
		for _, profile := range profileList {
			if requestedProfile == profile {
				os.Setenv("AWS_PROFILE", requestedProfile)
				fmt.Printf("AWS profile changed to %s.\n", requestedProfile)
				os.Exit(0)
			}
		}
		fmt.Printf("Profile %s doesn't exist.\n", requestedProfile)
		os.Exit(1)

	} else {
		for _, profile := range profileList[1:] {
			fmt.Println(profile)
		}
	}
}
