package main

import (
	"fmt"
	"golang.org/x/text/language"
)

func Hello(name string, lang string) (message string, err error) {
	tag, err := language.Parse(lang)
	
	if tag == language.English {
		message = fmt.Sprintf("Hello, %v. Welcome!", name)
	} else if tag == language.Spanish {
		message = fmt.Sprintf("Hola, %v. Bienvenidos!", name)
	} else if tag == language.Russian {
		message = fmt.Sprintf("Привет, %v. Добро пожаловать!", name)
	} else {
		err = fmt.Errorf("Unsupported language")
	}

	return message, err
}

func main() {
	message, err := Hello("Bob", "en")
    
	if err != nil {
		fmt.Printf("Error occurred: %s\n", err)
	} else {
		fmt.Println(message)
	}
}
