package main

import (
    "testing"
)

func TestHello(t *testing.T) {
    name := "Alice"

    expected := "Hello, Alice. Welcome!"
    msg, err := Hello(name, "en")

    if msg != expected || err != nil {
        t.Errorf(`Hello("Alice", "en") = %q, %v, want match for %#q, nil`, msg, err, expected)
    }
    
    expected = "Hola, Alice. Bienvenidos!"
    msg, err = Hello(name, "es")

    if msg != expected || err != nil {
        t.Errorf(`Hello("Alice", "es") = %q, %v, want match for %#q, nil`, msg, err, expected)
    }
    
    expected = "Привет, Alice. Добро пожаловать!"
    msg, err = Hello(name, "ru")

    if msg != expected || err != nil {
        t.Errorf(`Hello("Alice", "ru") = %q, %v, want match for %#q, nil`, msg, err, expected)
    }
}
