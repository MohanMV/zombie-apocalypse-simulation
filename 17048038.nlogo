breed [ humans human ]                            ; creating a population of humans who will move around aimlessly
breed [ zombies zombie ]                          ; creating a population of zombies who will move around aimlessly



globals [rad]                                     ; this creates a global variable called rad

zombies-own [ zom_vis_ang zom_vis_rad health ]    ; this creates variables for personalised vision cones

humans-own  [ hum_vis_ang hum_vis_rad             ; this creates variables for personalised vision cones
 zombie_seen zombies_hit                          ; this creates 2 variables for zombies seen and zombies thats collided with humans
 health bravery                                   ; this creates 2 variables for health and bravery
 zom_vis_ang zom_vis_rad  ]                       ; this creates variables for personalised vision cones



to setup                                          ;  this creates a function called setup
  clear-all                                       ;  this clears the world of any previous activities
  reset-ticks                                     ;  this resets the ticks counter
  set rad 3                                       ;  this sets the global variable to 3

  create-humans initial_number_of_humans [        ; this creates the number of humans that your global variable states determined by the slider
    setxy random-xcor   random-ycor               ; this sets the starting position of the humans to a random location in the world
    set color gray                                ; this sets the color of the human to gray
    set size 10                                   ; this sets the size of the humans to 10
    set shape "person"                            ; this sets the shape of the person to humans
    set bravery random 10                         ; this sets the bravery variable to a random value up to 10. lower means the humans does not fight the zombie
    set health 10                                 ; this sets the health of the human to 10.
    adjust_vision_cone2                           ; this calls the adjust_vision_cone2

  ]

  create-zombies initial_number_of_zombies [      ; this creates the number of zombies that your global variable states determined by the slider
    setxy random-xcor random-ycor                 ; this sets the starting position of the zombies to a random location in the world
    set color green                               ; this sets the color of the zombie to green
    set size 10                                   ; this sets the size of the zombies to 10
    set shape "person"                            ; this sets the shape of the person to humans
    set health 10                                 ; this sets the health of the human to 10.
    adjust_vision_cone                            ; this calls the adjust_vision_cone
  ]

end

to make_humans_move                                        ; this creates a function called make_humans_move
  ask humans [                                             ; this asks all of the human in the population to do what is in the brackets
    if health > 0 [                                        ; if health is greater that 0 then (still alive)
    show_visualisations_hum                                ; call the show_visualisations_hum function
    set color gray                                         ; this sets the color of each person to gray
    let have_seen_zombie zombie_function                   ; this creates a local variable called have_seen_zombie the fills it with the return of the function zombie_function
    let hit_confirm zombie_hit_function                    ; this creates a local variable called hit_confirm, which is filled with the return value of zombie_hit_function
    let zombie_hit 0                                       ; this creates a local variable called zombie_hit and sets it to 0
    if (have_seen_zombie = true ) and  (bravery < 6 ) [    ; if local variable have_seen_zombie is true and bravery is lesser than 6...
        right random 180                                   ; set the heading of the human to a random 180 (turn around to avoid)
    ]
    if (hit_confirm = true ) and  (bravery < 6 ) [         ; if local variable hit_confirm is true and bravery is lesser than 6...
        hatch-zombies 1 [                                ; this turtle creates a new turtle of the zombie breed
            set color green                                ; set the color of the new zombie to green
            set size 10                                    ; set the size of the new zombie to 10
            set shape "person"                             ; this sets the shape of the zombie to a person
            adjust_vision_cone                             ; this calls the adjust_vision_cone
          ]
          set zombie_hit who                               ; this sets the local variable zombie_hit to the individual who
          set zombie_hit health - 5                        ; decrease the health by 5
        die                                                ; kill the human
    ]
      if (have_seen_zombie = true ) and (bravery > 5 )[    ; if the local variable have_seen_zombie is true and bravery is more than 5
         set zombie_hit who                                ; this sets the local variable called zombie_hit to the individual who
        let chance random 100                              ; this creates a local variable called chance and sets it to a random value up to 100
        if (chance > 0) and (hit_confirm = true)[          ; if chance is greater than 0 and they did infact collide with a zombie
          ask zombies  in-radius rad [                     ; this sets up a radius around the human to the value of the global variable rad which we are using for collision detection with zombie
            set zombie_hit who                             ; this sets the local variable called person_hit to the individual who
            show zombie_hit                                ;
            ask zombie zombie_hit [die]                    ; kill off the zombie hit
          ]
        ]
        if (chance < 1) and (hit_confirm = true) [         ; if local variable chance is less than 1 and they did infact collide with a zombie
          hatch-zombies 1 [                                ; this turtle creates a new turtle of the zombie breed
            set color green                                ; set the color of the new zombie to green
            set size 10                                    ; set the size of the new zombie to 10
            set shape "person"                             ; this sets the shape of the zombie to a person
            adjust_vision_cone                             ; this calls the adjust_vision_cone
          ]
          set zombie_hit who                               ; this sets the local variable zombie_hit to the individual who
          set zombie_hit health - 5                        ; decrease the health by 5
          die                                              ; kill the good agent
          ]
      ]
    right ( random hwr - ( hwr / 2))                       ; this turns the human right relative to its current heading by a random degree number using the range set within hwr NOTE: if negative it will turn left
    forward human_speed                                    ; this sets the speed at which the humans move
  ]
 ]
end

to make_zombies_move                         ; this creates a function called make_zombies_move
  ask zombies [                              ; this asks all of the zombies in the population to do what is in the brackets
    show_visualisations                      ; call the show_visualisation function
    set color green                          ; this sets the color of zombie to green
    right ( random zwr - ( zwr / 2))         ; this turns the zombie right relative to its current heading by a random degree number using the range set within zwr NOTE: if negative it will turn left
    forward zombie_speed                     ; this sets the speed at which the zombies move
    if (health < 1)[                         ; if the health of the zombies is less than 1
     die                                     ; zombies die
    ]
  ]
end

to go                                        ; this creates a function called go
  reset_patch_colour                         ; this calls the reset_patch_colour function
  make_humans_move                           ; this calls the make_humans_move function
  make_zombies_move                          ; this calls the make_zombies_move function
  tick                                       ; increase by 1 tick
  if (ticks = 1500)[                         ; if the simulation reaches 1500 ticks
   stop                                      ; stop the simulation
  ]
end

to show_visualisations                            ; this creates a function called show_visualisations
  if show_col_rad_zom = true [                    ; this will switch on the visualisation of the collision radius if the switch is set to true
    ask patches in-radius rad [                   ; this sets up a radius around the zombies to the value of the global variable rad which we are using to display the size of the radius by changing the patch color
      set pcolor yellow                           ; this sets the patch color to yellow
    ]
  ]
  if show_vis_cone_zom = true [                   ; this will switch on the visualisation of the vision cone if the switch is set to true
    ask patches in-cone zom_vis_rad zom_vis_ang [ ; this sets up a vision cone in front of the zombie to the value of the global variables zom_vis_rad zom_vis_ang which we are using to display the size of the radius by changing the patch color
      set pcolor red                              ; this sets the patch color to red
    ]
  ]
end

to show_visualisations_hum                      ; this creates a function called show_visualisations_hum
  if show_col_rad_hum = true [                  ; this will switch on the visualisation of the collision radius if the switch is set to true
    ask patches in-radius rad [                 ; this sets up a radius around the humans to the value of the global variable rad which we are using to display the size of the radius by changing the patch color
      set pcolor blue                           ; this sets the patch color to blue
    ]
  ]
  if show_vis_cone_hum = true [                   ; this will switch on the visualisation of the vision cone if the switch is set to true
    ask patches in-cone hum_vis_rad hum_vis_ang [ ; this sets up a vision cone in front of the human to the value of the global variables hum_vis_rad hum_vis_ang which we are using to display the size of the radius by changing the patch color
      set pcolor red                              ; this sets the patch color to red
    ]
  ]
end

to-report zombie_function                         ; this creates a reporting function called zombie_function
  let seen [false]                                ; this creates a local variable called seen
  let hit [false]                                 ; this creates a local variable called hit
  let zombie_hit 0                                ; this creates a local variable calles zombie_hit and sets it to 0

  ask zombies in-cone hum_vis_rad hum_vis_ang [   ; this sets up a vison cone on the humans with the parameters from hum_vis_rad hum_vis_ang and detects what zombies are within this cone
    set color green                               ; this sets the color of the zombie detected within the vision code of the human to green
    set seen true                                 ; this sets the local variable called seen to true indicating that a human has been seen
  ]

  ask zombies in-radius rad [                     ; this sets up a radius around the human to the value of the global variable rad which we are using for collision detection with zombies
    set hit true                                  ; this sets the local variable called hit to true indicating that a human has collided with the zombie
    set zombie_hit who                            ; this sets the local variable called zombie_hit to the individual who
    show zombie_hit
  ]

  ifelse seen = true [                            ; if then else statement based on the local variable seen, if seen = true then...
    set zombie_seen zombie_seen + 1               ; add 1 to the zombie_seen count
    set color white                               ; set color of human to white

  ][
  ]
  report seen                                     ; return true or false based in local variable seen
end

to-report zombie_hit_function
    let hit [false]                               ; this creates a local variable called hit
    let zombie_hit 0                              ; this creates a local variable called zombie_hit and sets it to 0
    ask zombies in-radius rad [                   ; this sets up a radius around the human to the value of the global variable rad which we are using for collision detection with zombies
    set hit true                                  ; this sets the local variable called hit to true indicating that a human has collided with the zombie
    set zombie_hit who                            ; this sets the local variable called zombie_hit to the individual who
    show zombie_hit
  ]
  report hit
end

to adjust_vision_cone                              ; this creates a function called adjust_vision_cone
  set zom_vis_ang (zom_vis_ang + 35)               ; set the zombies vision angle to + 35
  set zom_vis_rad (zom_vis_rad + 20)               ; set the zombie vision radius to + 20
end

to adjust_vision_cone2                             ;  this creates a function called adjust_vision_cone2
  set hum_vis_ang (hum_vis_ang + 35)               ;  set the human vision angle to + 35
  set hum_vis_rad (hum_vis_rad + 20)               ;  set the human vision radius to + 20
end


to reset_patch_colour                       ; this creates a function called reset_patch_color
  ask patches [                             ; this asks all of the patches in the population to do what is in the brackets
    set pcolor black                        ; this sets the color of each patch to black
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
239
10
823
595
-1
-1
2.87
1
10
1
1
1
0
1
1
1
-100
100
-100
100
1
1
1
ticks
30.0

SLIDER
838
125
1032
158
initial_number_of_humans
initial_number_of_humans
1
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
33
122
228
155
initial_number_of_zombies
initial_number_of_zombies
1
100
15.0
1
1
NIL
HORIZONTAL

SLIDER
838
165
1010
198
hwr
hwr
0
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
838
205
1010
238
human_speed
human_speed
0
2
1.0
0.1
1
NIL
HORIZONTAL

BUTTON
36
23
100
56
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
136
23
203
56
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
34
164
206
197
zwr
zwr
0
25
25.0
1
1
NIL
HORIZONTAL

SLIDER
34
204
206
237
zombie_speed
zombie_speed
0
2
0.8
0.1
1
NIL
HORIZONTAL

SWITCH
34
255
207
288
show_vis_cone_zom
show_vis_cone_zom
0
1
-1000

SWITCH
33
301
207
334
show_col_rad_zom
show_col_rad_zom
1
1
-1000

SWITCH
839
252
1011
285
show_col_rad_hum
show_col_rad_hum
1
1
-1000

SWITCH
839
291
1011
324
show_vis_cone_hum
show_vis_cone_hum
0
1
-1000

PLOT
835
342
1035
492
Population
Ticks
Number
0.0
1500.0
0.0
100.0
true
true
"" ""
PENS
"Humans" 1.0 0 -16777216 true "" "plot count humans"
"Zombies" 1.0 0 -2674135 true "" "plot count zombies"

MONITOR
835
498
892
543
Humans
count humans
17
1
11

MONITOR
976
498
1034
543
Zombies
count zombies
17
1
11

TEXTBOX
95
87
168
125
Zombies \n
15
0.0
1

TEXTBOX
891
90
978
112
Humans\n
15
0.0
1

@#$#@#$#@
## WHAT IS IT?

This is an agent-based model to explore the potential outcomes of a Zombiism epidemic.

## HOW IT WORKS

Zombies and humans wander randomly around the landscape, while the zombies look for humans to attack and turn them into zombies. The zombies' health will be affected if they successfully turn a human into a zombie. When the zombies health is severely affected they will die. The humans on the other hand, have bravery and chance variables and depending on each variable which is set to random, the humans will either attack the zombies or avoid them. This will in turn, affects the survival of humans in this model.


## HOW TO USE IT


1. Adjust the slider parameters (see below), or use default settings
2. Adjust the switch parameters (see below), or use default settings
3. Press SETUP button.
4. Press the GO button to begin the simulation
5. Look at the monitors to see the current population sizes
6. Look at the POPULATIONS plot to watch the populations fluctuate over time

Parameters: 
INITIAL_NUMBER_OF_HUMANS  : The initial size of the human population
INITIAL_NUMBER_OF_ZOMBIES : The initial size of zombie population
ZWR                       : This turns the zombie right relative to its current heading 	                            by a random degree number using the range set
HWR                       : This turns the human right relative to its current heading by                             a random degree number using the range set
ZOMBIE_SPEED 		  : The speed of zombies when they move
HUMAN_SPEED  		  : The speed of humans when they move
SHOW_VIS_CONE_ZOM         : Sets up a vision cone in front of the zombies
SHOW_COL_RAD_ZOM          : Sets up the visualisation of the collision radius for zombies
SHOW_VIS_CONE_HUM 	  : Sets up a vision cone in front of the zombies
SHOW_COL_RAD_HUM	  : Sets up the visualisation of the collision radius for humans

There are 2 monitors to show the populations of humans and zombies and a population plot to display the population values over time.


## THINGS TO NOTICE

When running the model, watch as the zombie and human populations fluctuate. Notice that increases and decreases in the sizes of each population are related. In what way are they related? What eventually happens?

Why do you suppose that some variations of the model might be stable while others are not?

## THINGS TO TRY

Try adjusting the parameters under various settings. How sensitive is the stability of the model to the particular parameters?

Can you find any parameters that generate a scenario of humans surviving or going extinct in the model?
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
