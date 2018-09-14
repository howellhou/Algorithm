# Backtrack algorithm that solves polyominoes in Racket
* polyominoes.rkt contains the main algorithm and main functions to test
* a10.rtk and kanoodle.rkt are provided by UW, including tests and struct definitions
* To run the program, use (solve-puzzle grid polys viz-style)
    * grid is "pent-grid-X" where 0<=X<=12
    * polys is "pent-pieces-X" where 0<=X<=12
    * viz-style is one of 'interactive (draw every step of the search), 'at-end (just draw the solution, if one is found), or 'offline (don't draw anything).
    * grid and polys must have the same X to get a valid solution, the larger X is, the more area is filled in the original grid
    * Use 'offline to get actual performance since generating graphs will take too much time
* Performance (time is in millisecond) :
    * (time (solve-puzzle pent-grid-0 pent-pieces-0 'offline)) 
        * cpu time: 35578 real time: 35929 gc time: 2451
    * (time (solve-puzzle pent-grid-1 pent-pieces-1 'offline)) 
        * cpu time: 48172 real time: 48617 gc time: 2057 
    * (time (solve-puzzle pent-grid-2 pent-pieces-2 'offline))
        * cpu time: 45328 real time: 53728 gc time: 3720
    *  (time (solve-puzzle pent-grid-3 pent-pieces-3 'offline))
        * cpu time: 375 real time: 389 gc time: 0
        * The required time to pass this test is 45000
