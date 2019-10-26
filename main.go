package main

import (
	"fmt"
	"os"

	"gopkg.in/ini.v1"
)

func main() {
	awsCredentialsFile, err := ini.Load("/Users/daniel.vidal/.aws/credentials")
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
			fmt.Printf("* %v\n", profile)
		}

	}
}
