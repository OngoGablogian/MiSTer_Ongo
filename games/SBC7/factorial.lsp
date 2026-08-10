; Factorial
; Paste these lines at the TinyLisp > prompt.

; Recursive factorial
(DEFINE FACT (LAMBDA (N) (IF (= N 0) 1 (* N (FACT (- N 1))))))

; Try it out (6! = 720 is the largest that fits in 12 bits)
(FACT 1)
(FACT 5)
(FACT 6)

; Tail-recursive version (constant stack usage)
(DEFINE FACT-T (LAMBDA (N ACC) (IF (= N 0) ACC (FACT-T (- N 1) (* N ACC)))))
(FACT-T 6 1)
