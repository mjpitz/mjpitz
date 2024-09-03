---
title: 'Countdown - the Card Game'
description: |
  Over the summer, I made a more conscious effort to spend dedicated 1-1 time with my child. We often spend our time
  together playing board games, playing piano, watching movies, among other activities. Recently, I've been watching
  clips from the UK game show "Countdown" and found myself really enjoying the math portion. In this post, I discuss how
  my child and I came up with a way to play this game using a single deck of cards.
pubDate: "August 30 2024"
heroImage: '/img/2024-08-30-countdown.png'

slug: 2024/08/30/countdown

---

Over the summer, I made a more conscious effort to spend dedicated one-on-one time with my child. We often spend our
time together playing board games, playing piano, watching movies, among other activities. Recently, I've been watching
clips from the UK game show "Countdown" and found myself really enjoying the math portion.

For those unfamiliar with the game, you're given 6 numbers (a mix of both high and low values). Using these 6 numbers,
you must construct an equation that produces a 3-digit random number or a value close to it. For example, given the
values `50`, `25`, `75`, `100`, `8`, and `2`, you can produce `368` by `(100 + 75 + 8) * (50 / 25) + 2`.

Now, my kid is a bit of a math wiz and I thought that they may really enjoy this game. But I wanted to find a way to
play without needing screens involved. Sure I could probably program it in an hour (7 random numbers and a UI), but I
wanted us to be able to play this game while we are out camping, during power or internet outages, or even on a plane.
With a little creativity, we were able to find a way to play without any electricity.

<br/>

### Requirements

1. A single, standard deck of cards (2 - 10, J, Q, K, A).
2. A random number generator, or a second deck of cards (A - 9 only).
3. 1-minute timer (optional).

<br/>

### Set-up

1. Separate the standard deck of cards into two piles.
   * Pile 1 should contain all face cards (J, Q, K, A). This will be our "high value" deck (25, 50, 75, 100,
     respectively).
   * Pile 2 should contain all numeric cards (2 - 10). This will be our "low value" deck (value shown on card).
2. If you're using a second deck of cards instead of a random generator, only use the A - 9 cards.
3. Shuffle each pile of cards, separately.

<br/>

### How to play

Each game is composed of multiple rounds. Each round:

1. We start by dealing out 7 values from the high and low pile. Most games I've seen, players choose 3 or 4 high value
   numbers and the remainder will be low value.
2. Using the random number generator, generate three-digit number between 100 and 1000. If you're doing this using a
   second deck of cards, flip the top three cards over to reveal the generated number. For instance, a 6, Ace, and 8
   would be 618.
3. Start the timer
4. Until the timer stops, players must construct a math equation using the values that produces the generated number or
   a value close to it. Only addition, subtraction, multiplication, and division are allowed. Each value may only be
   used once in the final equation.
5. When the timer runs out, players share their equations and how they came to the value they produced. The individual
   with a correct math equations whose value is closest to the generated value wins the round.

Then, just play as many rounds as you like! For those with younger children or those who don't do well under pressure,
you can replace the 1-minute timer with a longer once (say 5 minutes) or just wait until each other are ready to share.
For those interested in more of a challenge, replace the 1-minute timer with a shorter one (the game show itself uses a
30-second clock).

<br/>

Thanks for stopping by! I hope that you and your family can enjoy this as much as I have enjoyed it with mine.

~ Ciao!
