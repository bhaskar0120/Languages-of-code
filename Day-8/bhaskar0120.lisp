;; imports for reading files
(load "~/quicklisp/setup.lisp")  
(ql:quickload :asdf)

;; set some parameters 
(defparameter grid (uiop:read-file-lines "inp.txt"))
(defparameter row-len (length (nth 0 grid)) )
(defparameter col-len (length grid) )

;; returns value at grid[r][c]
(defun val (r c) (digit-char-p (char (nth r grid) c) ))

;; checks if r, c is in the grid
(defun in (r c)
 (
  if 
    (OR
     (OR (< r 0) (< c 0) )
     (OR (>= r col-len)  (>= c row-len ))
    )
    nil
    t
  )
)


;;rx - row change, cx - col change
;;recursive checks if blocked, else moves one step in that direction
(defun not-blocked (row col rx cx v) 
 (let ((r (+ rx row))
       (c (+ cx col)))
  (
     if (not (in r c))
     t
     (
      if (>= (val r c) v)
      nil
      ( not-blocked r c rx cx v)
     ) 
    )
  )
)

(defun visibility (row col rx cx v score) 
 (let ((r (+ rx row))
       (c (+ cx col)))
  (
     if (not (in r c))
     score
     (
      if (>= (val r c) v)
      (+ 1 score)
      ( visibility r c rx cx v (+ 1 score))
     ) 
    )
  )
)

;; A simple recursive loop counts visible trees
(defun easy (pos sum) 
 (let ((row (floor ( / pos row-len))) 
       (col (mod pos row-len)))
 (
  if (not (in row col))
  sum 
  (
    if (OR
       (OR
          (not-blocked row col 1 0 (val row col)) 
          (not-blocked row col 0 1 (val row col))
       )
       (OR 
         (not-blocked row col 0 -1 (val row col)) 
         (not-blocked row col -1 0 (val row col)) 
       )
      )
    (easy (+ 1 pos ) (+ 1 sum))
    (easy (+ 1 pos ) sum)
  )
 )
 )
)
   

(defun hard (pos score) 
 (let ((row (floor ( / pos row-len))) 
       (col (mod pos row-len)))
 (if (not (in row col))
  score 
  (
   let(
      (s0 (visibility row col 1 0 (val row col) 0 ))
      (s1 (visibility row col 0 1 (val row col) 0 ))
      (s2 (visibility row col 0 -1 (val row col) 0)) 
      (s3 (visibility row col -1 0 (val row col) 0)) 
   )(
     if (< score (* (* s0 s1) (* s2 s3)))
     (hard (+ 1 pos ) (* (* s0 s1) (* s2 s3)))
     (hard (+ 1 pos ) score)
    )
   )
 )
 )
)

(format t "Easy: ~A ~%"(easy 0 0))
(format t "Hard: ~A ~%"(hard 0 0))

