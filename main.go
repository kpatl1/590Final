package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func main() {
	seed := time.Now().UnixNano()
	rnd := rand.New(rand.NewSource(seed))

	inCh := make(chan int, 5)
	outCh := make(chan int, 5)

	var wgProducers sync.WaitGroup
	wgProducers.Add(2)

	go func() {
		defer wgProducers.Done()
		for i := 1; i <= 29; i += 2 {
			inCh <- i
			time.Sleep(time.Duration(rnd.Intn(1500)) * time.Millisecond)
		}
	}()

	go func() {
		defer wgProducers.Done()
		for i := 2; i <= 30; i += 2 {
			inCh <- i
			time.Sleep(time.Duration(rnd.Intn(1500)) * time.Millisecond)
		}
	}()

	go func() {
		wgProducers.Wait()
		close(inCh)
	}()

	var wgConsumers sync.WaitGroup
	wgConsumers.Add(2)

	consumer := func() {
		defer wgConsumers.Done()
		for v := range inCh {
			squared := v * v
			outCh <- squared
			time.Sleep(time.Duration(rnd.Intn(3000)) * time.Millisecond)
		}
	}

	go consumer()
	go consumer()

	go func() {
		wgConsumers.Wait()
		close(outCh)
	}()

	var prev int
	first := true
	for v := range outCh {
		if first || v > prev {
			fmt.Println(v)
			prev = v
			first = false
		}
	}
}
