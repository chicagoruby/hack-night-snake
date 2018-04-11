# Snake

Tonight we will be building a classic implementation of the videogame, Snake.

## The basics

Snake is played on a 2D rectangular board. You start with a
"snake", which is represented by one or more filled consecutive spaces. The snake is constantly moving forward, but the player can change the snake's direction by 90 degrees (left or right) to avoid collisions.

## The basic application

The idea of the game is to not allow the snake to hit itself or the edges of the board.

The classic game also includes food of some sort, which can be represented by a single filled space randomly placed on the board. The snake "eats" these spots by navigating to these spots and slithering over them. When the food is eaten, the snake increases in size by one unit. You want to keep score and see how many foods you can eat before you lose (by running into a wall, or yourself).

## Stretch

The game gets more challenging the longer the snake is. You can also increase the difficulty by speeding up the snake (either as an initial configuration, or after the snake consumes a certain number of foods).

You can add obstacles on the board for the snake to avoid. You can also change the shape of the board (a U shape, a + shape).

You can make larger apples that add more length to the snake (ie: 2x2 apple adds 4 units).
