const S_M1 = `
<p>Failed to find task instructions! Please contact the researchers to see why this is happening.</p>
`;

const S_1 = `
<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to automate her smart home. 
Now, she wants the smart home to do the <span style="font-weight:bold; color:rgb(0, 153, 255)">same things as before</span> (i.e. the same things as in the Original Program), except it should also automatically <span style="font-weight:bold; color:rgb(0, 153, 255)">turn off the faucet when she leaves the bathroom.</span>
<br><br>
Help Alice determine whether her goal can be achieved by <span style="font-weight:bold; color:rgb(0, 153, 255)">replacing</span> the <span style="text-decoration:underline">Original Program</span> with the <span style="text-decoration:underline">Modified Program</span>.
`;
//  Both features are described below:
// <br><span style="font-weight:bold; color:rgb(0, 153, 255)">Continue to close all windows (in the bathroom, bedroom, and living room) when it starts raining, but also turn off the faucet when Alice leaves the bathroom.</span>
// <span style="font-weight:bold; color:rgb(0, 153, 255)">Does the Modified Version meet the new goal *WHILE* keeping the Original Program's desirable behavior?</span><br><br>
// The Original Program's desirable behavior is:<br>--> <span style="font-weight:bold">The HUE lights turn on when it becomes nighttime; </span><br>--> Either <span style="font-weight:bold">the bedroom or bathroom windows (but not both) are open when it starts raining; </span>and<br>--> <span style="font-weight:bold">The bedroom window opens if the bathroom window is already closed when it stops raining.</span><br><br>You want to see if the Modified Version will keep the original desirable behaviors while also meeting the new goal, which is: <span style="font-weight:bold">guests can use the fridge even when Alice is not in the kitchen to unlock it for them.</span><br><br>This is because Alice has been forgetting to unlock the fridge when she has guests over.

// - The original program <span style="font-weight:bold">turns on the lights when it becomes night time.</span><br>--> It also makes sure that <span style="font-weight:bold">either the bedroom or bathroom windows are open (not both) when it starts raining.</span><br>--> It <span style="font-weight:bold">opens the bedroom window if the bathroom window is already closed when the sky no longer rains.</span> <br><br>Your task is to make sure that <span style="font-weight:bold">in addition to these behaviors, the system also lets guests use the fridge even when your roommate, Alice, is not in the kitchen to unlock it for them.</span>
// Recently, Alice has been forgetting to unlock the fridge when she has guests over. You want to modify the program so that, in addition to the behaviors above, <span style="font-weight:bold">guests can use the fridge even when she is not in the kitchen to unlock it for them.</span> Your task is to see whether the modified version will meet these goals.

// <span style="font-weight:bold">Problem:</span> Alice's Original Program automatically <span style="font-weight:bold; color:rgb(0, 153, 255)">closes all windows (in the bathroom, bedroom, and living room) when it starts raining.</span> 
// This is good, but she now wants to add a new feature that automatically <span style="font-weight:bold; color:rgb(0, 153, 255)">turn off the faucet when she leaves the bathroom.</span>
// <br><br>
// Help Alice with this task by deciding whether the Modified Version <span style="font-weight:bold">does exactly what the Original Program does while adding the new feature.</span>
// `;

const S_2 = `<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to automate her AC and save on electricity. Now, her brother <span style="font-weight:bold">(Bobbie)</span> is temporarily staying with her, and <span style="font-weight:bold">he complains that sometimes he can’t use the AC when he is at home.</span>
<br><br>
Help Alice fix this issue by deciding <span style="font-weight:bold; color:rgb(0, 153, 255)">which</span> of Program #1 and Program #2, <span style="font-weight:bold; color:rgb(0, 153, 255)">if any</span>, will meet Alice’s goal below:
<br>
<span style="font-weight:bold; color:rgb(0, 153, 255)">Let anyone (Alice or Bobbie) who is home to use the AC freely, but keep the AC off when no one is home.</span>
`;
// <span style="font-weight:bold; color:rgb(0, 153, 255)">Which of Programs #1 and #2, if any, meets your goals?</span><br><br>
// Your goal is to have <span style="font-weight:bold">the AC off when no one is at home</span>, but when someone is at home they can turn on the AC whenever they would like.<br><br><i>(For this task, assume that your name is Bobbie, and only you and Alice live in this home.)</i><br><br>Unfortunately, with the Original Program in effect, <span style="font-weight:bold">sometimes the AC shuts off even when you (Bobbie) try to turn it on at home.</span><br><br>You do not want either of these, and therefore are considering whether Program #1 or Program #2 can replace the Original Program to fix these issues.

const S_3 = `<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to automate her home security system. It worked perfectly, but then a visiting friend modified it behind her back! Now Alice is not sure if the program still protects her home.
<br><br>
Help Alice decide whether the Modified Program still meets the same <span style="font-weight:bold">goal</span> below as the Original Program, <span style="font-style:italic; font-weight:bold">even if the home behaves differently</span>:
<br>
<span style="font-weight:bold; color:rgb(0, 153, 255)">The security camera is always recording the house when she is asleep, when the front door is unlocked, or both.</span>

`;

// <span style="font-weight:bold; color:rgb(0, 153, 255)">Does the Modified Version *KEEP* the Original Program's behaviors?</span><br><br>
// The Original Program's behaviors are:<br>--> <span style="font-weight:bold">The security camera is recording the house when you are asleep and/or when the front door is unlocked.</span><br>--> <span style="font-weight:bold">The Roomba turns off when the security camera starts recording.</span><br><br>However, you found out that your roommate modified the program without you knowing!<br><br>You want to see if the Modified Version <span style="font-weight:bold">has the exact same behavior as the original program.</span>

// - The original program makes sure <span style="font-weight:bold">the security camera is recording the house when you are asleep or when the front door is unlocked, or both.</span><br><br>--> It also <span style="font-weight:bold">turns off the Roomba when the security camera starts recording.</span> <br><br>Your task is to see if the modified version keeps these behaviors.

const S_4 = `
<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to automate her smart home for good air circulation.</span> 
It worked perfectly, but her friend thinks she should replace this Original Program with either Program #1 or Program #2.
<br><br>
Help Alice decide <span style="font-weight:bold">which</span> of Program #1 and Program #2, <span style="font-weight:bold">if any</span>, will meet the same goal below as her Original Program <span style="font-style:italic; font-weight:bold">even if the home behaves differently</span>:
<br>
<span style="font-weight:bold; color:rgb(0, 153, 255)">There is always one window open in the house, no more and no less. Any window (in the bathroom, bedroom, or living room) is fine.</span>
<span style="font-style:italic">(<span style="font-weight:bold">Note</span>: As long as the smart home opens/closes some window (no matter which one) to make sure that exactly one window is open at the end, <span style="font-weight:bold">it's okay if there are zero or two windows open temporarily.</span>)</span>
`;
// For this task, if a rule undoes an action, like "If the window opens Then turn off this window", the smart home will simply <span style="font-weight:bold">not</span> open the window in the first place.)
// <span style="font-weight:bold; color:rgb(0, 153, 255)">Which of Programs #1 and #2, if any, meets your goals?</span><br><br>
// Your goal is to have <span style="font-weight:bold">exactly one window open in the house at any time.</span><br><br>(Assume that there are only three windows in your home: one in the bedroom, one in the bathroom, and one in the living room.)<br><br>However, with the Original Program in effect, you notice that:<br>--> <span style="font-weight:bold">Sometimes more than one window is open in the house,</span> and<br>--> <span style="font-weight:bold">Sometimes all the windows are closed.</span><br><br>You do not want either of these, and therefore are considering whether Program #1 or Program #2 can replace the Original Program to fix these issues.
// Alice's Original Program <span style="font-weight:bold">always keeps one window open in the house, no more and no less. She doesn't care which window (in the bathroom, bedroom, or living room).</span> 
// this goal can also be met with two alternative programs.

const S_5 = `
<span style="font-weight:bold; color:rgb(0, 153, 255)">Which of Programs #1 and #2, if any, meets your goals?</span><br><br>
You goal is to make sure that <span style="font-weight:bold">the AC and the heater never work against each other by being on at the same time,</span> even when someone tries to turn them on manually.<br><br>You came up with an Original Program for this, but then thought of two alternative options (Programs #1 and #2) as well. You are not sure if any of the three programs will meet your goal.<br><br>In this task, please select which of Program #1 and Program #2 (not the Original Program) will meet your goal.
`;
// Your goal is to control the temperature in the house by automatically turning on the AC when it's too hot and automatically turning on the heater when it's too cold. <i>(Assume that there is nothing else that will change the temperature of your house.)</i> However, you <span style="font-weight:bold">don't want them to work against each other by being on at the same time.</span><br><br>Originally you had a program in mind for this, but then came up with two alternative options. You're not sure which of these three, if any, will meet your goal.

const S_6 = `
<span style="font-weight:bold; color:rgb(0, 153, 255)">Does the Modified Version meet the new goal *WHILE* keeping the Original Program's desirable behavior?</span><br><br>
The original program's desirable behavior is that <span style="font-weight:bold">the HUE lights are always on when the living room window curtains are closed and/or at night.</span><br><br>You want to see if the Modified Version will keep the original desirable behaviors while also meeting the new goal, which is: <span style="font-weight:bold">the bedroom window will only ever be open during daytime</span> to let air in.
`;

const S_7 = `<span style="font-weight:bold">Problem:</span> When Alice is watching TV with both the Roomba on and the living room window open, the combination of noise from the Roomba and the outside drowns out the TV. 
There are 27 programs that lets the smart home avoid this situation, each by closing the window or turning off the Roomba. 
<span style="font-weight:bold">However, Alice prefers fresh air over having the Roomba clean the floor.</span>
<br><br>
Help Alice find <span style="font-weight:bold; color:rgb(0, 153, 255)">all</span> programs out of the 27 ("Programs #1", "Program #2", etc.) that meet the goal below:
<br><span style="font-weight:bold; color:rgb(0, 153, 255)">Never interrupt the TV. If there is combined noise from the living room window open and the Roomba on, prioritize the fresh air from the open window.</span>
`;

// `<span style="font-weight:bold">Problem:</span> It usually doesn't matter to Alice when her noisy Roomba is on, even while watching TV. 
// However, when she is watching TV with the Roomba on <span style="font-weight:bold">and</span> the living room window open, then the <span style="font-weight:bold">combination</span> of noise from the Roomba and from the traffic outside completely drowns out the TV. 
// <span style="font-weight:bold">When this happens, Alice prefers having the window open over having the Roomba on.</span>
// <br><br>
// Help Alice solve this problem by choosing <span style="font-weight:bold; color:rgb(0, 153, 255)">all</span> programs out of the 27 given to you ("Programs 1-27") that meet the goal below:
// <br><span style="font-weight:bold; color:rgb(0, 153, 255)">When the living room window is open, don't close it, but make sure the noisy Roomba isn’t disrupting Alice’s TV time.</span>
// `;

// <span style="font-weight:bold">For Alice during her TV time, having fresh air (when she wants) is more important than having a clean floor.</span>
// <span style="font-weight:bold; color:rgb(0, 153, 255)">Which program(s) meet all of your goals?</span><br><br>
// You can assume that all 27 programs ("Programs 1-27") meet your original goal.<br><br><span style="font-weight:bold">From these 27 programs, you want all of the programs</span> that ensure that <span style="font-weight:bold">when the living room window is open, the noisy Roomba never disrupts your TV time.</span><br><br>There may be more than one program that meets your goals.

// All 27 programs meet your original goal, which is to minimize the noise level in the home by making sure that the TV is never on when the Roomba is on and the living room window is open at the same time.

const S_8 = `<span style="font-weight:bold">Problem:</span> When Alice is in the living room during the day, she doesn’t want to be left in the dark. 
<span style="font-weight:bold">There are 16 programs</span> that ensure this by turning on the HUE lights or opening the living room window curtains, <span style="font-weight:bold">but Alice doesn't like all of them.</span>
<br><br>
Help Alice find <span style="font-weight:bold; color:rgb(0, 153, 255)">all</span> programs out of the 16 ("Programs #1", "Program #2", etc.) that meet all of her preferences below:
<br>
<span style="font-weight:bold; color:rgb(0, 153, 255)">
* If the HUE lights turn off, the house should open the curtains to let natural light in; and<br>
* If the curtains close, the lights should turn on.<br>
* In all other situations, whatever the programs choose to do is fine.</span>
`;
// <span style="font-weight:bold; color:rgb(0, 153, 255)">Which program(s) meet all of your goals?</span><br><br>
// You can assume that all 16 programs ("Programs 1-16") meet your original goal, which is to have light in the living room when Alice is there during the day by either turning on the lights or opening the living room window curtains.<br><br><span style="font-weight:bold">From these 16 programs, you want all of the programs</span> that would meet these two new goals: <br>--> <span style="font-weight:bold">When Alice is already in the living room during the day and the HUE lights turn off: the living room window curtains will open</span> to let natural light in; and<br>--> <span style="font-weight:bold">When Alice is already in the room during the day and the curtains close: the lights will turn on.</span><br><br>There may be more than one program that meets your goals.

// Out of these programs, you also want to make sure that: <ul><li><u>when it becomes day time while Alice is in the room without HUE lights, the living room window curtains open to let sunlight in; and</li><li>when she enters the living room with the window curtains closed during the day, the living room window curtains also open to let sunlight in.</u></li></ul><br>Besides those, the program can do whatever it wants.

const S_885 = `<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to make sure that <span style="font-weight:bold; color:rgb(0, 153, 255)">the lights are on when she's at home at night</span>. Now, she wants the smart home to <span style="font-weight:bold; color:rgb(0, 153, 255)">meet that same goal (even if the actual smart home behavior differs from that of Original Program)</span>, except it should also make sure that <span style="font-weight:bold; color:rgb(0, 153, 255)">the speakers will never turn on when the TV is on.</span>
<br><br> 
Help Alice determine whether her goal can be achieved by <span style="font-weight:bold; color:rgb(0, 153, 255)">replacing</span> the <span style="text-decoration:underline">Original Program</span> with <span style="text-decoration:underline">Program #1</span>, <span style="text-decoration:underline">Program #2</span>, or <span style="text-decoration:underline">either #1 or #2.</span>
`;
// `<span style="font-weight:bold">Problem:</span> Alice’s Original Program automatically <span style="font-weight:bold; color:rgb(0, 153, 255)">keep the HUE lights on whenever she is at home at night.</span> This has been working well so far. Now, Alice would like her home to <span style="font-weight:bold; color:rgb(0, 153, 255)">continue doing this, but also make sure that the speakers are off whenever TV is on.</span>
// <br><br> 
// Help Alice determine whether her goal can be achieved by <span style="font-weight:bold; color:rgb(0, 153, 255)">replacing</span> the <span style="text-decoration:underline">Original Program</span> with <span style="text-decoration:underline">Program #1</span>, <span style="text-decoration:underline">Program #2</span>, or <span style="text-decoration:underline">either #1 or #2.</span>
// `

const S_887 = `<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to automate her smart home. Now, she wants the smart home to do the <span style="font-weight:bold; color:rgb(0, 153, 255)">same things as before</span> (i.e. the same things as in the Original Program), except it should also automatically <span style="font-weight:bold; color:rgb(0, 153, 255)">turn off the speakers whenever the TV turns on.</span>
<br><br> 
Help Alice determine whether her goal can be achieved by <span style="font-weight:bold; color:rgb(0, 153, 255)">replacing</span> the <span style="text-decoration:underline">Original Program</span> with <span style="text-decoration:underline">Program #1</span>, <span style="text-decoration:underline">Program #2</span>, or <span style="text-decoration:underline">either #1 or #2.</span>
`;

const S_881 = `<span style="font-weight:bold">Problem:</span> Alice wants to make sure that the air conditioning and the heater in her smart home are never on at the same time. 
<span style="font-weight:bold">There are 4 programs that ensure this, but Alice doesn't like all of them.</span>
<br><br>
Help Alice find <span style="font-weight:bold; color:rgb(0, 153, 255)">all</span> programs out of the 4 ("Program #1", "Program #2", etc.) that meet all of her preferences below:
<br>
<span style="font-weight:bold; color:rgb(0, 153, 255)">
* When the heater turns on, the AC should turn off.<br>
* In all other situations, whatever the programs choose to do is fine.</span>
`

// const S_886 = `<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to automate her smart home. Now, her friend wants her to switch to another program: either Program #1 or Program #2.<br><br>
// <span style="font-weight:bold; color:rgb(0, 153, 255)">Alice doesn't really care which of the three programs to use or what these programs do, as long as:<br>* The lights turn on when she comes home at night, and<br>* The speakers turn off whenever the TV turns on.</span>
// <br><br> 
// Help Alice determine whether her goal can be achieved by <span style="font-weight:bold; color:rgb(0, 153, 255)">replacing</span> the <span style="text-decoration:underline">Original Program</span> with <span style="text-decoration:underline">Program #1</span>, <span style="text-decoration:underline">Program #2</span>, or <span style="text-decoration:underline">either #1 or #2.</span>
// `;

const S_889 = S_887;

const S_9 = `<span style="font-weight:bold">Problem:</span> In the past, Alice used the Original Program to help her smart home save energy. 
It worked perfectly, but then her 6-year-old nephew modified it! 
Now Alice is not sure if the program is still helping her save energy.
<br><br>
Help Alice decide whether the Modified Program still meets the same <span style="font-weight:bold">goal</span> below as the Original Program, <span style="font-style:italic; font-weight:bold">even if the home behaves differently</span>:
<br>
<span style="font-weight:bold; color:rgb(0, 153, 255)">Never have all of these ON at the same time: AC, coffee pot, HUE lights, smart TV, speakers, and the Roomba (it has a rechargeable battery). <span style='font-weight:bold;color:black; font-style:italic'>(In other words: <span style='font-weight:normal'>one or more of these appliances should be off if the others are on, but Alice doesn’t care which is off. It's also okay if they are all off.)</span></span>
`;

const S_12 = `<span style="font-weight:bold">Problem:</span> Alice tried using the Original Program to help her smart home save energy. 
Unfortunately, <span style="font-weight:bold">this program didn't always do what she hoped for.</span> 
Her friend suggests that she replaces this program with either Program #1 or Program #2 instead.
<br><br>
Help Alice decide <span style="font-weight:bold">which</span> of Program #1 and Program #2, <span style="font-weight:bold">if any</span>, will meet Alice's goal below and solve the problem <span style="font-style:italic; font-weight:bold">even if it changes when the home turns on/off the devices</span>:
<br>
<span style="font-weight:bold; color:rgb(0, 153, 255)">Never have all of these ON at the same time: AC, coffee pot, HUE lights, smart TV, speakers, and the Roomba (it has a rechargeable battery). <span style='font-weight:bold;color:black; font-style:italic'>(In other words: <span style='font-weight:normal'>one or more of these appliances should be off if the others are on, but Alice doesn’t care which is off. It's also okay if they are all off.)</span></span>
`;

export const TASK_DETAIL_DICT: { [id: string]: string } = {
    '-1': S_M1,
    '1': S_1,
    '2': S_2,
    '3': S_3,
    '4': S_4,
    // '5': S_5,
    // '6': S_6,
    '7': S_7,
    '8': S_8,
    // '9': S_9,
    '12': S_12,
    '881': S_881,
    '885': S_885,
    '887': S_887,
    '889': S_889
};