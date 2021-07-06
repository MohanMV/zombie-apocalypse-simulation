# Zombie Apocalypse Simulation

Coursework from the University of Hertfordshire

## Overview 

We seek to understand the rapid spread of the infectious disease, Zombiism in a large number of people in a given population within a short period of time. How many people will be turned into zombies and how fast will this occur? What factors could aﬀect the outbreak and prevent the zombies from taking over? 

My programming partner and I developed an agent-based model to explore the potential outcomes of a Zombiism epidemic.

### Agents

The agents in the model are humans and zombies, however, humans turn into zombies if they encounter a zombie and get bitten.

Zombies are reﬂex agents that always attack when confronted by a human. Zombies wander away from their initial start position moving in random directions until they find themselves co-located with a human.

Humans are rational agents that make decisions based on their immediate environment and the actions they can take at that moment. They should have the ability to see zombies around them using a NetLogo primitive such as in-radius or in-cone.

### Interactions

Humans and zombies interact when they are co-located. Each interaction is deﬁned as occurring between a single zombie and a single human.

Humans and zombies see and recognise each other (zombies do not bite zombies etc.). If a zombie wins a ﬁght, it bites the human, and the human turns into a zombie. On the other hand, the human may ﬂee from the zombie or ﬁght and kill the zombie to avoid being infected.

### Variables

It's possible to vary the initial number of zombies and humans; this will aﬀect the outcome.

### Outcomes

To ensure your model is not deterministic, we added some randomness. The probability of a human killing a zombie is one example.

This is based on a variable called ‘bravery’. What would be the outcome of setting bravery very low? (the probability of killing a zombie is small). Would the human population survive (longer, at all) if they were cowardly and more likely to run away from zombies?

### Output

We provided feedback on the progress of our model by adding suitable plots, monitors or text output. It's possible to see different outcomes from varying the initial conditions.

### Schedule

Time is an essential aspect of the model, therefore each simulation was run for the same amount of ticks.

## Contact me!

For more information about this project, please email me at mohankumaar08@outlook.com

