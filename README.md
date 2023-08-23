# Deep Menu 

### Interaction
![Diagram](/Resouces/Interaction.png)

### Purpose

#### Deep Menu packages

+ MuMenu - a namespace tree that warps realtime control
+ MuFlo - a functional dataflow graph that wraps closures
+ MuSkyFlo - the Menu for a toy visual music synth
+ MuMenuSky - a helper to load the MuSkyFlo fmenu
+ MuPeer - synchonize MuFlo state (and manus) accross devices

#### Use cases 

+ DeepMuse - test Deepmuse menu without the shaders and canvas
+ visionOS - eyetracking and handpose testings
+ Touch.AI - base gesture tracking for a future device

## Design 

### Quesitons

How to navigate through thousands of apps containing millions of nodes?

What is the smallest gesture cost to navigate between nodes using eyes, hand pose, and speech?

What is the synergy where mixing speech and namespace improves precision?

How to mix a personalized language model with muscle memory?

### Background

In 1983, I consulted with Xerox to design a project management system. The first thing they did was plunk down a book of research on the D* machines. What impressed me most was their analytics for text editors. The study tracked the gesture cost between various tasks, such as cut and paste. I forget the names of the editors, but the idea of gesture cost stuck with me.

In 1989, I showed a hypertext system to Jef Raskin. It consisted of a hierarchy of unfolding windows. He suggested that it resembled UI work that Adele Goldberg was doing at Xerox PARC. It was somewhat akin to the MacOS Finder's column view. The main takeaway from that meeting with Jef was his recommendation of a book by Card, Moran, and Newell, called: "The Psychology of Human-Computer Interaction." Within those pages is Fitt's Law. It laid out the equations for gesture cost.

One final tributary was a conversation with David Huffman. He invented Huffman codes, which is theoretically the most efficient way of compressing information. I had played with Huffman codes a few years earlier -- tweaking them with bigrams. More than once, I've heard that every problem in IT turns into a compression problem.

So, what if you were to create a Huffman codec for gesture cost? Instead of letters or words, you are compressing your path through a menu? That menu could span millions of concepts and values. And through analytics, capture your journey through that namespace. What you would wind up with is a personal corpus. And then: what if you were to apply transformers to that corpus? What you'd have is a way of anticipating where you'd want to go next. In a sense, a kind of Huffman tree for your personal intent.

Deep Menu is exploring those questions. Starting with a toy visual music synthesizer. The nice thing about using a toy, at first, is that if something goes wrong, nobody gets hurt. In fact, they might be intrigued.
