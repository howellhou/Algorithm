;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname polyominoes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require "a10.rkt")

;; Uncomment the following line if you want to use
;; the examples in kanoodle.rkt
(require "kanoodle.rkt")

;; A Grid is a (listof (listof Char))
;; requires: both inner and outer lists of Grid are non-empty

(define-struct pos (x y))
;; A Pos is a (make-pos Int Int)

(define-struct state (puzzle pieces))
;; A State is a (make-state Grid (listof Grid))

;; A temporary neighbours function that always fails.  
;; Provide only the purpose, contract and function definition.

;; (solve-puzzle grid polys viz-style)
;; Solve a polyomino puzzle, given the initially empty (or partially filled 
;; in) grid, a set of pieces that must be placed, and a Symbol indicating
;; what visualization style to use.  Legal viz styles are 'interactive
;; (draw every step of the search), 'at-end (just draw the solution, if one
;; is found), or 'offline (don't draw anything).  Produce either the solved
;; Grid (converted to a list of Strings, just for convenience) or false if
;; no solution exists.
;;
;; You don't need to modify this function at all.  It is provided for you
;; so that you can test your puzzle solving algorithm interactively.  If
;; you decide you want to write check-expect tests using solve-puzzle
;; (which you don't have to do, but can if you want), be sure to consume
;; 'offline for viz-style.

;; solve-puzzle: Grid (listof Grid) Sym -> (anyof (listof Str) false)
;; requires: viz-style is one of {'interactive, 'at-end or 'offline}

;; Some Examples are included below after the solve-puzzle function definition.

;; DO NOT MODIFY THIS CODE
(define (solve-puzzle grid polys viz-style)
  (local
    [(define result
       (search 
        (lambda (S) (empty? (state-pieces S)))
        neighbours
        (cond
          [(symbol=? viz-style 'interactive)
           (lambda (S) (draw-grid (state-puzzle S)))]
          [else false])
        (make-state grid polys)))
     
     (define maybe-last-draw
       (cond
         [(and (state? result)
               (symbol=? viz-style 'at-end))
          (draw-grid (state-puzzle result))]
         [else false]))]
    (cond
      [(boolean? result) result]
      [else (map list->string (state-puzzle result))])))

;; Examples:
;; (The examples are not provided in check-expect form.  They're meant to
;; demonstrate typical uses of the function, but we don't want to them to
;; open interactive visualizations every time you start the program.)

;; Solve offline (i.e. work like a normal Scheme function).
;(solve-puzzle
;  (strlist->grid '("...." "...." "...." "...." "...." "...."))
;  (cons '((#\L #\L) (#\. #\L)) (cons '((#\O)) tetrominoes-uc))
;  'offline)

;; Display the result graphically, if a solution is found.
;(solve-puzzle
;  (strlist->grid '("...." "...." "...." "...." "...." "...."))
;  (cons '((#\L #\L) (#\. #\L)) (cons '((#\O)) tetrominoes-uc))
;  'at-end)

;; Display every step of the search as it progresses.
;(solve-puzzle
;  (strlist->grid '("...." "...." "...." "...." "...." "...."))
;  (cons '((#\L #\L) (#\. #\L)) (cons '((#\O)) tetrominoes-uc))
;  'interactive)


;;1.(a)
;;(build-2dlist w h f) consumes the width and height of a grid, and a function
;;  that is applied to all (x,y) positions corresponding to positions in the grid.
;;(build-2dlist):Nat Nat (Nat Nat-> X) -> (listof (listof X))
;;Require: w,h cannot be zero
;;Examples:


(define (build-2dlist w h f)
  (build-list h
              (lambda (i)
                (build-list w
                            (lambda (j)
                              (f j i))))))


;;1.(b)
;;(all-positions w h) consumes width w and height h, w and h,and produces a 
;;  (listof Pos) containing all possible positions in a grid with width w and height h
;;(all-positions):Nat Nat->(listof Pos)
;;Require: w,h>0
;;Examples:


(define (all-positions w h)
  (foldr append empty (build-2dlist w h make-pos)))

;;Tests: 



;;(2)
;;(all-orientations G) consumes a Grid representing a single polyomino, and
;;  produces a list of Grids containing all distinct
;;  rotations and reflections of that polyomino.
;;(all-orientations):Grid -> (listof Grid)
;;Require:G should be a single polyomino.
;;Examples:


(define (all-orientations G)
  (local [;;(fold-row G) consumes a Grid and produce reflections by row
          ;;(fold-row):Grid -> Grid
          (define (fold-row G)
            (reverse G))
          
          ;;(fold-column G) consumes a Grid and produce reflections by column
          ;;(fold-column):Grid -> Grid
          (define (fold-column G)
            (map reverse G))
          
          ;;(de-dup loa) consumes a list of any values and produces a new list with only
          ;;  one occurrence of each element of the original list.
          ;;(de-dup):(listof Any) -> (listof Any)
          (define (de-dup loa)
            (foldr (lambda (x y)
                     (cond [(member? x y) y]
                           [else (cons x y)]))
                   empty loa))
          
          ;;(rotate/acc G acc) consumes a Grid and an accumulator and produces the Grid
          ;;  that rotate 90 degree anticlockwise
          ;;(rotate/acc G acc): Grid (listof (listof Char)) ->Grid
          (define (rotate/acc G acc)
            (cond [(empty? (first G)) acc]
                  [else (rotate/acc (map rest G) (cons (map first G) acc))]))
          
          ;;(rotate/acc G acc) consumes a Grid and produces the Grid
          ;;  that rotate 90 degree anticlockwise
          ;;(rotate/acc G acc): Grid ->Grid
          (define (rotate G) (rotate/acc G empty))
          
          ;;fold-G is a list of all reflections of G
          (define fold-G
            (list G (fold-row G) (fold-column G) (fold-column (fold-row G))))]
    (de-dup (append fold-G (map rotate fold-G)))))

;;Tests:

;;(3)
;;(first-empty-pos G)consumes a Grid and produces the Pos of the first #\.
;;  character in the Grid.Produce false if there is no.
;;(first-empty-pos): Grid -> (anyof Pos false)
;;Examples:



(define (first-empty-pos G)
  (local[(define (first-empty-pos/acc G w h)
           (cond [(empty? (first G)) (first-empty-pos/acc (rest G) 0 (add1 h))]
                 [(char=? #\. (first (first G))) (make-pos w h)]
                 [else (first-empty-pos/acc (cons (rest (first G)) (rest G)) (add1 w) h)]))]
    
    (first-empty-pos/acc G 0 0)))

(define (first-non-empty-pos G)
  (local[(define (first-non-empty-pos/acc G w h)
           (cond [(empty? (first G)) (first-non-empty-pos/acc (rest G) 0 (add1 h))]
                 [(not (char=? #\. (first (first G)))) (make-pos w h)]
                 [else (first-non-empty-pos/acc (cons (rest (first G)) (rest G)) (add1 w) h)]))]
    
    (first-non-empty-pos/acc G 0 0)))

;;Tests:



(define (all-empty G w h)
  (cond [(empty? G) empty]
        [(empty? (first G)) (all-empty (rest G) 0 (add1 h))]
        [(char=? #\. (first (first G))) (cons (make-pos w h) (all-empty (cons (rest (first G)) (rest G)) (add1 w) h))]
        [else (all-empty (cons (rest (first G)) (rest G)) (add1 w) h)]))

(define (all-non-empty G w h)
  (cond [(empty? G) empty]
        [(empty? (first G)) (all-non-empty (rest G) 0 (add1 h))]
        [(not (char=? #\. (first (first G)))) (cons (make-pos w h) (all-non-empty (cons (rest (first G)) (rest G)) (add1 w) h))]
        [else (all-non-empty (cons (rest (first G)) (rest G)) (add1 w) h)]))

(define (move-pos lop w h)
  (map (lambda (p) (make-pos (+ w (pos-x p)) (+ h (pos-y p)))) lop))

(define (top-char G)
  (cond [(empty? (first G)) (top-char (rest G))]
        [(not (char=? #\. (first (first G)))) (first (first G))]
        [else (top-char (cons (rest (first G)) (rest G)))]))


;;(4)
;;(superimpose base top P) consumes two Grids which are base and top, and a Pos,
;;  and produces a new Grid in which top is laid over base such that the consumed
;;  Pos indicates the location of the upper left corner of top.
;;(superimpose):Grid Grid Pos ->Grid
;;Constant for tests:


(define (superimpose base top P)
  (local [(define top-empty (move-pos (all-non-empty top 0 0) (pos-x P) (pos-y P)))
          (define topchar (top-char top))
          (define (superimpose/acc loc w h)
            (cond [(empty? loc) empty]
                  [(member? (make-pos w h) top-empty) (cons topchar (superimpose/acc (rest loc) (add1 w) h))]
                  [else (cons (first loc) (superimpose/acc (rest loc) (add1 w) h))]))
          (define (superimpose/acc2 G h)
            (cond [(empty? G) empty]
                  [else (cons (superimpose/acc (first G) 0 h) (superimpose/acc2 (rest G) (add1 h)))]))]
    (superimpose/acc2 base 0)))

(define my-base (list (list #\A #\. #\. #\. #\.)
                      (list #\A #\A #\A #\. #\.)
                      (list #\. #\A #\. #\. #\.)))
(define my-top (list (list #\B #\B )
                     (list #\B #\B)
                     (list #\B #\. )))



;;(5)
;;(neighbours S) consumes a single State and produces a list of States
;;  in which one additional polyomino has been placed in the puzzle and
;;  removed from the list of pieces yet to be placed.
;;(neighbours):State -> (listof State)

(define (neighbours S)
  (local [(define base (state-puzzle S))
          (define lop (state-pieces S))
          (define first-empty (first-empty-pos base))
          (define base-empty (all-empty base 0 0))
          (define (can-place? top P)
            (local[(define top-non-empty (move-pos (all-non-empty top 0 0) (pos-x P) (pos-y P)))]
              (andmap (lambda (pie) (member? pie  base-empty))  top-non-empty)))
          
          
          (define (neighbours/acc untested used lostate)
            (local [(define (all-solution lopiece)
                      (cond [(empty? lopiece) empty]
                            [else (local [(define firstp (first lopiece))
                                          (define firstnep (first-non-empty-pos firstp))
                                          (define available-pos (make-pos  (- (pos-x first-empty) (pos-x firstnep)) (- (pos-y first-empty) (pos-y firstnep))))]
                                    (cond [(can-place? firstp available-pos) (cons (make-state (superimpose base firstp available-pos)
                                                                                               (append (rest untested) used)) (all-solution (rest lopiece)))]
                                          [else (all-solution (rest lopiece))]))]))]
              
              (cond [(empty? untested) lostate]
                    [else (neighbours/acc (rest untested)
                                          (cons (first untested) used)
                                          (append (all-solution
                                                   (all-orientations (first untested))) lostate))])))]
    (neighbours/acc lop empty empty)))









