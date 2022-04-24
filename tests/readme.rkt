#lang s-exp kal

(fn (even_numbers)
  (let count 0)
  (loop
    (send yield with count)
    (set! count (+ count 2))))

(for ([num (even_numbers)])
  (log num))
