turtles-own
[
  susceptible?        ;; if true, the node is susceptible
  exposed?            ;; if true, the node already received the virus
  infected?           ;; if true, the node is infectious
  resistant?          ;; if true, the node can't be infected
]

globals
[
  new-node            ;; the last node we created
  degrees             ;; an array that contains each node in proportion to its degree
]

to setup
  clear-all
  setup-network
  initialize          ;; to set the initial infected nodes
  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;
;;; Create Network  ;;;
;;;;;;;;;;;;;;;;;;;;;;;

;; setups the contact network
to setup-network
  set-default-shape turtles "circle"
  set degrees [ ]     ;; at the begining the array is empty
  construct-network
  ask turtles [ become-susceptible ]
  ask links [ set color white ]
  repeat 20           ;; optimize the display of network
  [ layout-spring turtles links 0.3 (world-width / (sqrt number-of-nodes)) 50 ]
end

;; creates the scale free network,using preferential attachment method
to construct-network
  make-node                             ;; add the first node
  let first-node new-node               ;; remember the first node
  ;; to create a line(when the average degree is 2) or a cycle,then can start to create the scale network 
  let prev-node new-node
  ifelse average-node-degree - 1 = 0    ;; create a line
  [ make-node
    make-edge new-node prev-node        ;; make the edge
    set prev-node new-node
  ]
  [ repeat average-node-degree - 1      ;; create a cycle
    [ make-node
      make-edge new-node prev-node
      set prev-node new-node
    ]
  ]
  make-edge new-node first-node 
  while [count turtles < number-of-nodes]
  [ make-node                           ;; add one new node,it's going to have average-node-degree edges
    repeat average-node-degree 
    [ let partner find-partner new-node ;; find a partner for the new node
      make-edge new-node partner        ;; connect it to the partner we picked before
    ]
  ]
end

to make-node
  create-turtles 1
  [ set new-node self ]                 ;; set new node as last node we created
end

;; finds the node to which we connect
to-report find-partner [node1]
  let partner one-of degrees     
  ;; check the partner chosen isn't the node itself and also isn't a node that our node is already connected to
  let checkit true
  while [ checkit ]
  [ ask partner 
    [ ifelse ((link-neighbor? node1) or (partner = node1))
      [ set partner one-of degrees ]
      [ set checkit false ]            ;; the partner selected is legal,ends checking
    ] 
  ]
  report partner
end

;; connects the two turtles
to make-edge [node1 node2]
  ask node1
  [ ifelse (node1 = node2)
    [ stop ]
    [ create-link-with node2
      set degrees lput node1 degrees    ;; once a node is been added an edge,adds the node to the array
      set degrees lput node2 degrees
    ]
  ]
end

;; select the initial infected nodes
to initialize
  ifelse initial-outbreak-size > number-of-nodes
  [ show "initial outbreak number can't be bigger than the number of nodes" stop ]
  [ ask n-of initial-outbreak-size turtles [ become-infected ] ]
end

to go
  if count turtles with [infected?] = 0
  [ stop ]  
  check
  tick
end

;;;;;;;;;;;;;;;;;;;;;;;
;;;  Change States  ;;;
;;;;;;;;;;;;;;;;;;;;;;;

to become-susceptible
  set susceptible? true
  set exposed? false
  set infected? false
  set resistant? false
  set color green
end

to become-exposed
  set susceptible? false
  set exposed? true
  set infected? false
  set resistant? false
  set color yellow
end

to become-infected  
  set exposed? false
  set infected? true
  set resistant? false
  set color red
end

to become-resistant  
  set susceptible? false
  set exposed? false
  set infected? false
  set resistant? true
  set color gray
  ask my-links [ set color gray - 2 ]
end

;;;;;;;;;;;;;;;;;;;;;;;
;;;     Actions     ;;;
;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;to spread-virus                                                      ;;  
;;  ask turtles with [infected?]                                       ;;
;;  [ let choice one-of link-neighbors with [susceptible?]             ;;
;;    if choice != nobody and random-float 100 < virus-spread-chance-α ;;
;;    [ ask choice [ become-exposed ] ]                                ;;
;;  ]                                                                  ;;
;;end                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to spread-virus
  ask turtles with [infected?]                    
  [ ask link-neighbors  with [susceptible?]       
    [ if random-float 100 < virus-spread-chance-α 
      [ become-exposed ]                          
    ]                                             
  ]                                               
end                                               

to active-virus
  ask turtles with [exposed?]
  [ if random-float 100 < virus-active-chance-β
    [ become-infected ]
  ]
end

;; get resistance from susceptible state
to get-resistance-sus
  ask turtles with [susceptible?]
  [ if random-float 100 < gain-resistance-chance-ω
    [ become-resistant ] 
  ]
end

;; get resistance from exposed state
to get-resistance-exp
  ask turtles with [exposed?]
  [ if random-float 100 < gain-resistance-chance-δ
    [ become-resistant ]
  ]
end

to recover
  ask turtles with [infected?]
  [ if random-float 100 < recover-chance-γ
    [ become-resistant ]
  ]
end

;; start the whole spreading process
to check
  spread-virus
  active-virus
  get-resistance-sus
  get-resistance-exp
  recover
end
@#$#@#$#@
GRAPHICS-WINDOW
223
10
684
492
20
20
11.0
1
10
1
1
1
0
0
0
1
-20
20
-20
20
1
1
1
ticks
30.0

SLIDER
9
10
214
43
number-of-nodes
number-of-nodes
100
500
300
1
1
NIL
HORIZONTAL

SLIDER
9
53
214
86
average-node-degree
average-node-degree
1
50
25
1
1
NIL
HORIZONTAL

BUTTON
34
371
96
404
setup
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
106
371
175
404
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
9
96
214
129
initial-outbreak-size
initial-outbreak-size
1
50
1
1
1
NIL
HORIZONTAL

SLIDER
9
140
214
173
virus-spread-chance-α
virus-spread-chance-α
0
20
20
1
1
%
HORIZONTAL

SLIDER
9
184
214
217
virus-active-chance-β
virus-active-chance-β
0
20
5
1
1
%
HORIZONTAL

SLIDER
9
229
214
262
recover-chance-γ
recover-chance-γ
0
10
1.5
0.1
1
%
HORIZONTAL

SLIDER
9
273
215
306
gain-resistance-chance-δ
gain-resistance-chance-δ
0
10
0.5
0.1
1
%
HORIZONTAL

PLOT
693
66
1029
339
Number
time
number
0.0
10.0
0.0
500.0
true
true
"" ""
PENS
"susceptible" 1.0 0 -10899396 true "" "plot count turtles with[susceptible?]"
"exposed" 1.0 0 -1184463 true "" "plot count turtles with[exposed?]"
"infected" 1.0 0 -2674135 true "" "plot count turtles with[infected?]"
"resistant" 1.0 0 -7500403 true "" "plot count turtles with[resistant?]"

MONITOR
693
11
768
60
susceptible
count turtles with [susceptible?]
1
1
12

MONITOR
778
11
853
60
exposed
count turtles with [exposed?]
1
1
12

MONITOR
863
11
940
60
infected
count turtles with [infected?]
1
1
12

MONITOR
950
11
1029
60
resistant
count turtles with [resistant?]
1
1
12

PLOT
693
347
1029
492
Degree Distribution
degree
# of node
1.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "let max-degree max [count link-neighbors] of turtles\nplot-pen-reset\nset-plot-x-range 1 (max-degree + 1)\nhistogram [count link-neighbors] of turtles"

SLIDER
9
319
215
352
gain-resistance-chance-ω
gain-resistance-chance-ω
0
10
0.1
0.1
1
%
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

A modified model based on SEIR model which is used to simulate the spreading pattern of virus among mobile phones by means of SMS.This is a part of the project "The study of the spreading pattern of mobile phone virus".

It can also be used to study the MMS virus spreading pattern,because essentially these two patterns are similar.  

## HOW IT WORKS

Using the scale free network to simulate the real contact network of the mobile phone.
The algorithm used to create the network is : first,creates a cycle of m nodes(when average degree > 1,m equals to the average degree,otherwise m = 2 and create a line),then adds new node with m edges one by one.Use preferential attachment to create edges for the newly created node.

The spreading pattern is based on the SEIR model.It contains 4 states:susceptible (S), exposed (E), infected (I), and recovered or resistant (R).

At each time step the infected agent will send a text message with malicious URL to all of its contacts,some users may click the URL then a malware will be downloaded automatically.After downloading the malware,the agent becomes exposed (E),but is not infectious;only when the malware is installed by users the virus will be activated and the new agent is infected (I) too.The newly infected agent attempts to send a same message to all of its contacts,and so forth.

A virus can be cleared from the mobile phone.This can happen at different stages(susceptible,exposed,infected) of the spreading.After removing the malware,the agent will become recovered or resistant (R),and can not be infected by the same virus again.  

## HOW TO USE IT

Set the parameters then click "setup" and "go" to observe the spreading and final result of experiment.By varying the same parameters to observe if there is any difference between the results of each experiment.

NUMBER-OF-NODES :
Control the number of nodes.Each node represents a mobile phone.

AVERAGE-NODE-DEGREE :
Set the average edges a node can have,and a node has more edges signifies has more contacts.

INITIAL-OUTBREAK-SIZE :
The initial number of infected agents from where the spreading of virus starts.

VIRUS-SPREAD-CHANCE-Α :
The chance that user click malicious URL(then malware is downloaded).

VIRUS-ACTIVE-CHANCE-B :
The chance that a malware be installed(virus is actived) by user.

RECOVER-CHANCE-Γ :
The recovery chance of an infected agent,which indicates how many infected agents can recover from infected state at each time step.

GAIN-RESISTANCE-CHANCE-Δ :
The chance that an exposed agent can gain resistance from the exposed state.

GAIN-RESISTANCE-CHANCE-Ω
The chance that an susceptible agent can gain resistance from the susceptible state.After gaining resistance,the state is changed to resistant and the agent can't be infected by the same virus again.

The plot DEGREE DISTRIBUTION can display the degree distribution of the scale free contact network

## THINGS TO NOTICE

The algorithem used to create a scale free network has a limit,that the number of nodes must be larger than the average degree.

Add a control to the interface,the minimum value of slider "number-of-nodes" is bigger than the maximum value of slider "average-node-degree".

Can modify manually the number of nodes by inputting an integer smaller than 101,when doing this ensure you select a smaller number for average degree.

## THINGS TO TRY

Use different parameters to observe if there are differences between the spreadings?

## EXTENDING THE MODEL

Can calculate the average distance between the infected nodes and the initial infected node,and by analying the result you can find even only after a few steps of spreading the virus can reach a long distance .The reason is that through the telephone network a virus can be sent to any of its contacts no matter how far it is.

## NETLOGO FEATURES

1.A modified SEIR model is propsed accordingAccording to the real spreading pattern of mobile phone viruses.

2.Using "preferential attachment" to create a scale free network with precise average  degree which is realized in a different way from the model "Virus on a Network" and the model "Preferential Attachment"

## RELATED MODELS

Virus on a Network : SIR model. The network created is based on proximity between nodes 

Preferential Attachment : Another method of “preferential attachment” to create a scale free network

## CREDITS AND REFERENCES

This model is based on the SEIR epidemic model.An overview of Epidemic Model :
WIKIPEDIA : http://en.wikipedia.org/wiki/Epidemic_model#The_SEIR_model

A model for understanding SEIR :
Global Health - SEIR Model : http://www.public.asu.edu/~hnesse/classes/seir.html?Beta=0.9&Gamma=0.2&Sigma=0.5&Mu=0&Nu=0&initialS=10&initialE=1&initialI=0&initialR=0&iters=15

An instance of the spreading of mobile virus :
http://www.securelist.com/en/blog/8131/Obad_a_Trojan_now_being_distri%20buted_via_mobile_botnets
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
NetLogo 5.0.5
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
