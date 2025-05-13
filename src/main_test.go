package main

import (
    "testing"
    // "fmt"
)

func TestHello(t *testing.T) {
    name := "Alice"

    expected_msg := "Hello, Alice. Welcome!"
    msg, err := Hello(name, "en")

    if msg != expected_msg || err != nil {
        t.Errorf(`%q, %v = Hello("Alice", "en"), expected %#q, nil`, msg, err, expected_msg)
    }
    
    expected_msg = "Hola, Alice. Bienvenidos!"
    msg, err = Hello(name, "es")

    if msg != expected_msg || err != nil {
        t.Errorf(`%q, %v = Hello("Alice", "es"), expected %#q, nil`, msg, err, expected_msg)
    }
    
    expected_msg = "Привет, Alice. Добро пожаловать!"
    msg, err = Hello(name, "ru")

    if msg != expected_msg || err != nil {
        t.Errorf(`%q, %v = Hello("Alice", "ru"), expected %#q, nil`, msg, err, expected_msg)
    }
    
    expected_msg = ""
    msg, err = Hello(name, "nope")

    if msg != expected_msg || err == nil  {
        t.Errorf(`%q, %v = Hello("Alice", "nope"), expected %#q`, msg, err, expected_msg)
    }
}
