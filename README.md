# ComplexSystems
Project for the exam of complex systems.

It simulates the spreading pattern of mobile phone  virus  by  means  of  SMS  spam  and  Bluetooth.  By  varying  all  the parameters  of  correspondent  model  and  analyzing  the  different  results,  the study will find out how each parameter will influence the propagation of mobile phone virus.

There are two files can be excuted in NetLogo.

## Simulation of SMS Virus Infection

Virus-SMS.nlogo simulates the virus propagation pattern through SMS.

![image](https://github.com/KaiYangCHN/ComplexSystems/blob/master/Screenshots/sms.png)

### WHAT IS IT?

A modified model based on SEIR model which is used to simulate the spreading pattern of virus among mobile phones by means of SMS.This is a part of the project “The study of the spreading pattern of mobile phone virus”.
It can also be used to study the MMS virus spreading pattern,because essentially these two patterns are similar.

### HOW IT WORKS

Using the scale free network to simulate the real contact network of the mobile phone. The algorithm used to create the network is : first,creates a cycle of m nodes(when average degree > 1,m equals to the average degree,otherwise m = 2 and create a line),then adds new node with m edges one by one.Use preferential attachment to create edges for the newly created node.

The spreading pattern is based on the SEIR model.It contains 4 states:susceptible (S), exposed (E), infected (I), and recovered or resistant (R).
At each time step the infected agent will send a text message with malicious URL to all of its contacts,some users may click the URL then a malware will be downloaded automatically.After downloading the malware,the agent becomes exposed (E),but is not infectious;only when the malware is installed by users the virus will be activated and the new agent is infected (I) too.The newly infected agent attempts to send a same message to all of its contacts,and so forth.
A virus can be cleared from the mobile phone.This can happen at different stages(susceptible,exposed,infected) of the spreading.After removing the malware,the agent will become recovered or resistant (R),and can not be infected by the same virus again.

### HOW TO USE IT

Set the parameters then click “setup” and “go” to observe the spreading and final result of experiment.By varying the same parameters to observe if there is any difference between the results of each experiment.

NUMBER-OF-NODES : Control the number of nodes.Each node represents a mobile phone.

AVERAGE-NODE-DEGREE : Set the average edges a node can have,and a node has more edges signifies has more contacts.

INITIAL-OUTBREAK-SIZE : The initial number of infected agents from where the spreading of virus starts.

VIRUS-SPREAD-CHANCE-Α : The chance that user click malicious URL(then malware is downloaded).

VIRUS-ACTIVE-CHANCE-B : The chance that a malware be installed(virus is actived) by user.

RECOVER-CHANCE-Γ : The recovery chance of an infected agent,which indicates how many infected agents can recover from infected state at each time step.

GAIN-RESISTANCE-CHANCE-Δ : The chance that an exposed agent can gain resistance from the exposed state.

GAIN-RESISTANCE-CHANCE-Ω The chance that an susceptible agent can gain resistance from the susceptible state.After gaining resistance,the state is changed to resistant and the agent can’t be infected by the same virus again.

The plot DEGREE DISTRIBUTION can display the degree distribution of the scale free contact network

### THINGS TO NOTICE

The algorithem used to create a scale free network has a limit,that the number of nodes must be larger than the average degree.
Add a control to the interface,the minimum value of slider “number-of-nodes” is bigger than the maximum value of slider “average-node-degree”.
Can modify manually the number of nodes by inputting an integer smaller than 101,when doing this ensure you select a smaller number for average degree.

### THINGS TO TRY

Use different parameters to observe if there are differences between the spreadings?

### EXTENDING THE MODEL

Can calculate the average distance between the infected nodes and the initial infected node,and by analying the result you can find even only after a few steps of spreading the virus can reach a long distance .The reason is that through the telephone network a virus can be sent to any of its contacts no matter how far it is.

### NETLOGO FEATURES

1.A modified SEIR model is propsed accordingAccording to the real spreading pattern of mobile phone viruses.
2.Using “preferential attachment” to create a scale free network with precise average degree which is realized in a different way from the model “Virus on a Network” and the model “Preferential Attachment”

### RELATED MODELS

Virus on a Network : SIR model. The network created is based on proximity between nodes
Preferential Attachment : Another method of “preferential attachment” to create a scale free network

### CREDITS AND REFERENCES

This model is based on the SEIR epidemic model.An overview of Epidemic Model : WIKIPEDIA : http://en.wikipedia.org/wiki/Epidemic_model#The_SEIR_model
A model for understanding SEIR : Global Health - SEIR Model : http://www.public.asu.edu/~hnesse/classes/seir.html?Beta=0.9Γ=0.2Σ=0.5Μ=0Ν=0&initialS=10&initialE=1&initialI=0&initialR=0&iters=15
An instance of the spreading of mobile virus : http://www.securelist.com/en/blog/8131/Obad_a_Trojan_now_being_distri%20buted_via_mobile_botnets

## Bluetooth Virus Spreading: A Modified SIR Model

Virus-Bluetooth.nlogo simulates the virus propagation pattern through bluetooth.

![image](https://github.com/KaiYangCHN/ComplexSystems/blob/master/Screenshots/Bluetooth.png)

### WHAT IS IT?

A model based on SIR model used to study the spreading pattern of mobile virus by means of Bluetooth.A part of the project “The study of the spreading pattern of mobile phone virus”.

### HOW IT WORKS

The model contains 3 primary states: susceptible (S), infected (I), recovered (R) and 1 auxiliary state : connected (C).The connected state is used to make the spreading model more clear and more understandable.

At each time step,the infected agents scan the nodes that are in its coverage area and select one of them to connect to.After the creation of connection,both these two nodes becomes connected (C),and the infected agent starts to send virus.For all nodes move continually,the distance between each node changes always;and once the distance is bigger than the coverage radius,the connection breaks off so the transfer fails,then the infected agent starts to select a new node to connect to.

An infected agent can get resistance and becomes recoverd (R),then it can not be infected by the same virus again.

Using the random network to simulate the distribution of agents.

### HOW TO USE IT

Set the parameters then click "setup" and "go" to observe the spreading and final result of simulation.By varying the same parameters to observe if there is any difference between the results of each simulation.

NUMBER-OF-NODES : 
Control the number of nodes.Each node represents a mobile phone.

TIME : 
The time needed to complete the transfer of virus.

SPEED : 
Indicates in which speed the nodes move.

RADIUS :
The radius that Bluetooth signal can reach and influence.

ACCEPT-CHANCE :
The chance an angent accept the request of creating connection and being sent the file.

INSTALL-CHANCE :
The chance an user will install the received file.

RECOVERY-CHANCE :
The chance an infected node can recover.

INITIAL-BREAK :
The number of initial infected nodes.

### THINGS TO NOTICE

Each infected node can only connect to one of other nodes once time.It can connect to a new node only after interrupting existing connection.

### THINGS TO TRY

Varying the values of "time","speed" and "radius",there are differences between the results?

### EXTENDING THE MODEL

By adopting the model,you can calculate the average distantce between the infected nodes and the initial infected node,and by analyzing the result you can find the distance augments gradually.It is because that a virus can only be sent to the nodes nearby,and with the movement of the infected nodes, the virus can reach in a longer distance slowly.

### NETLOGO FEATURES

Take into account the influence of movement speed and transfer time.The probability of a successful transfer mostly depends on the relation between speed and time.

### RELATED MODELS

Virus : this model simulates the transmission and perpetuation of a virus in a human population.

### CREDITS AND REFERENCES

Supporting Online Material :
http://mobilephonevirus.barabasilab.com/paper/som.pdf
