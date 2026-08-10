; List operations
; Paste these lines at the TinyLisp > prompt.

; Length of a list
(DEFINE LENGTH (LAMBDA (L) (IF (NULL? L) 0 (+ 1 (LENGTH (CDR L))))))

; Append two lists
(DEFINE APPEND (LAMBDA (A B) (IF (NULL? A) B (CONS (CAR A) (APPEND (CDR A) B)))))

; Reverse a list (tail-recursive)
(DEFINE REV1 (LAMBDA (L A) (IF (NULL? L) A (REV1 (CDR L) (CONS (CAR L) A)))))
(DEFINE REVERSE (LAMBDA (L) (REV1 L NIL)))

; Map a function over a list
(DEFINE MAP (LAMBDA (F L) (IF (NULL? L) NIL (CONS (F (CAR L)) (MAP F (CDR L))))))

; Try them out
(DEFINE NUMS '(1 2 3 4 5))
(LENGTH NUMS)
(APPEND '(A B) '(C D))
(REVERSE NUMS)
(DEFINE SQUARE (LAMBDA (X) (* X X)))
(MAP SQUARE NUMS)
