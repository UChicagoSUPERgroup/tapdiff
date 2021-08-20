import { Component, OnInit, EventEmitter, ElementRef, ViewChild } from '@angular/core';
import { UnparsedTimelineDiff, TimelineEvent, TimelineState } from '../tdiffbase/tdiffbase.component';
import { MatDialog } from '@angular/material/dialog';
import { UserDataService, Clause } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { MatSelectChange } from '@angular/material/select';

import { Rule } from '../../user-data.service';
import { DiffcomService } from '../../diffcom.service';

import * as introJs from 'intro.js/intro.js';

export interface TimelineDiff {
  sharedEvents: TimelineEvent[]; // this almost definitely only has 1 elt
  sharedStates: TimelineState[];
  diffEvents: TimelineEvent[]; // only 2, 1st being the 1st program's and vv
  diffStates: TimelineState[]; // only 2, 1st being the 1st program's and vv
  diffIndices: number[]; // indices of devs dif between the two choices
}

@Component({
  selector: 'app-tdiff4',
  templateUrl: './tdiff4.component.html',
  styleUrls: ['./tdiff4.component.css']
})
export class Tdiff4Component implements OnInit {
  private INTRO_DONE: number = 0;
  private DROPDOWN_CLICKED: boolean = false;
  private INTERVAL: number = 5;

  //current selection
  public TIMELINE_KEY: string = "";

  public FILTERS: { [id: string]: string } = {
    "device": "",
    "event": "",
    /* init_AC: "=On", init_XXX: "[=<>]YYY" */
  };

  public TIMELINE_KEYS_FILTERED: string[] = [];
  public TIMELINE_KEYS_FILTERED_CONDENSED: string[] = [];
  public TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS: { [id: string]: { [id: string]: boolean } } = {};
  public SHOW_ALL_DEVS_PER_TIMELINE: boolean[] = []; // -1 = unclicked, 0 = false, 1 = true

  //all cache for analysis or UI  (only changed when parsing backend data.)
  public TIMELINE_KEYS_BY_INITSTATE_BY_DEVICE__KEYS: string[] = [];

  private unparsedDiff: UnparsedTimelineDiff[];
  public isLoading: boolean = false;
  public isError: boolean = false;
  public READY: boolean = true;
  public PRGMNUMSDEFINED: boolean = false;

  @ViewChild('timelineControlPanel')
  controlPanel: ElementRef;
  public controlPanelFloating: boolean = false;
  public controlPanelHeight: number = 250;

  public urlParams = {
    "dropdown-style": "none",
    "dropdown-label": "false",
    "condense-enable": "true",
    "dev-mask": "true",
    "tutorial": "false",
  };

  public tutorialParams = {
    'showPrgmButton': 'false',
    'showSavePanel': 'false'
  }

  public TIMELINES: TimelineDiff[];
  // Was hoping have this as a placeholder so that when html loads before the parse fn
  // it doesn't result in a bunch of "TypeError: TIMELINE is undefined"
  // even if the content loads just a sec later. Unfortunately, it doesn't help.
  public TIMELINE: TimelineDiff = {
    sharedEvents: [],
    sharedStates: [],
    diffEvents: [],
    diffStates: [],
    diffIndices: []
  };

  public TIMELINE_KEYS_ORIGINAL: string[] = [];

  private all_choices: { [id: string]: Set<string>; } = {}; // key = cond.device.name + ' ' + cond.parameterVals[0].comparator;
  private all_chosen: { [id: string]: string; } = {}; // like all_devs, but with actual choice as value
  public trigger_events: TimelineEvent[] = []; // list of available trigger events
  private starting_event: string = ''; // the one we start with

  public VERSION_1: number;
  public VERSION_2: number;
  public PROGRAMNUMS: number[];
  public PROGRAMS: { [id: number]: Rule[]; };

  // Keeping track of timelines based on their start states (and maybe trigger events)
  public timelines_dict: { [id: string]: TimelineDiff; } = {}; // key = list of states + event
  public timelines_dict_by_start: { [id: string]: TimelineDiff[]; } = {}; // key = list of states

  // Keeping track of number of options for different device:capabilities
  public num_opts_dict: { [id: string]: number; } = {};

  constructor(
    public dialog: MatDialog,
    public userDataService: UserDataService,
    private route: Router,
    private router: ActivatedRoute,
    public elementRef: ElementRef) {
  }

  ngOnInit() {
    //init style params
    const queryParams = this.router.snapshot.queryParamMap["params"];
    for (let key in queryParams) this.urlParams[key] = queryParams[key];

    function checkTopVisibilityConstructor(currentThis: any) {
      //for force evaluation of "this" and build clousure.
      let thisObj = currentThis;
      function checkTopVisibility() {
        var pageYOffset = window.pageYOffset;
        if (pageYOffset > 100) {
          if (!thisObj.controlPanelFloating) {
            thisObj.controlPanelFloating = true;
            if (thisObj.controlPanel) {
              thisObj.controlPanelHeight = thisObj.controlPanel.nativeElement.offsetHeight + 2;
            }
          }
        }
        else {
          thisObj.controlPanelFloating = false;
        }
      }
      return checkTopVisibility;
    }

    /* ATTENTION! "this" keyword need force evaluate before pass to addEventListener.
    Attach event handlers to resize and scroll event */
    window.addEventListener("resize", checkTopVisibilityConstructor(this), false);
    window.addEventListener("scroll", checkTopVisibilityConstructor(this), false);

    this.userDataService.getCsrfCookie().subscribe(dataCookie => {
      this.router.params.subscribe(params => {
        // then get hashed_id and task_id from router params
        if (!this.userDataService.user_id) {
          this.userDataService.mode = "rules";
          this.userDataService.hashed_id = params["hashed_id"];
          this.userDataService.task_id = params["task_id"];
        }
        this.userDataService.getVersionPrograms(this.userDataService.hashed_id)
          .subscribe(data => {
            this.PROGRAMNUMS = data['version_ids'];
            this.PROGRAMS = {};
            if (this.PROGRAMNUMS.length > 0) {
              this.VERSION_1 = this.PROGRAMNUMS[0]
              if (this.urlParams['dropdown-style'] == 'none' && this.PROGRAMNUMS.length > 2) {
                this.VERSION_2 = -2;
              } else {
                this.VERSION_2 = this.PROGRAMNUMS[1];
              }
              if (this.urlParams['dropdown-style'] == 'onex') this.VERSION_2 = this.PROGRAMNUMS[1];

              //set unparsed rules by version id in PROGRAMS.
              for (let progNum of this.PROGRAMNUMS) this.PROGRAMS[progNum] = data["programs"][progNum]["rules"];

              this.prgmNumsDefined();
              if (this.urlParams['tutorial'] == 'true') {
                setInterval(() => this.startIntroJS(), this.INTERVAL);
              }

              if (this.VERSION_2 >= 0) {
                this.updateDiffAndTimeline(null);
              }
            }
          })
      })
    });
  }

  public tutorialStageComplete(stage: number): boolean {
    if (stage == 0 || stage == 4) { // when the user should next click the task instr button || just need to show save panel
      return true;
    }
    if (stage == 1) { // when the user should have clicked on the task instr button and should next close the task instr
      return this.userDataService.TaskInstrHasBeenFirstClicked();
    }
    if (stage == 2) { // when the user should have closed the task instr and should next click on Prgm 1 in dropdown
      return !this.userDataService.waitForTaskInstr() && this.userDataService.TaskInstrHasBeenFirstClicked();
    }
    if (stage == 3) { // when the user should have clicked on Prgm 1 in dropdown
      return this.DROPDOWN_CLICKED;
    }
    return false;
  }

  public startIntroJS() {
    let thisObj = this;
    if (this.INTRO_DONE == 0) {
      var introJS0 = introJs();
      introJS0.setOptions(this.userDataService.introJsOption0);
      introJS0.start();
      this.INTRO_DONE++;
    } else if (this.INTRO_DONE == 1 && this.tutorialStageComplete(1)) {
      // only trigger once: when task instructions have been clicked and is now in waiting mode
      this.INTRO_DONE++;
      setTimeout(function () {
        var introJS1 = introJs();
        introJS1.setOptions(thisObj.userDataService.introJsOption1);
        introJS1.start();
      }, 500);
    } else if (this.INTRO_DONE == 2 && this.tutorialStageComplete(2)) {
      this.INTRO_DONE++;
      setTimeout(function () {
        var introJS2 = introJs();
        introJS2.setOptions({
          exitOnOverlayClick: thisObj.userDataService.introJsOptions['exitOnOverlayClick'],
          exitOnEsc: thisObj.userDataService.introJsOptions['exitOnEsc'],
          doneLabel: "OK",
          showStepNumbers: thisObj.userDataService.introJsOptions['showStepNumbers'],
          keyboardNavigation: thisObj.userDataService.introJsOptions['keyboardNavigation'],
          disableInteraction: thisObj.userDataService.introJsOptions['disableInteraction'], // doesn't work
          scrollToElement: thisObj.userDataService.introJsOptions['scrollToElement'],
          steps: [
            {
              element: '#rightdropdown',
              intro: "To complete this task, you need to compare the Original Program with Programs #1 and #2.<br><br>Now, <span style='font-weight:bold'>use this dropdown menu to select Program #1.</span>"
            }
          ]
        });
        introJS2.start();
      }, 300);
    } else if (this.INTRO_DONE == 3 && this.tutorialStageComplete(3)) {
      this.INTRO_DONE++;
      this.DROPDOWN_CLICKED = false;
      let thisObj = this;
      setTimeout(function () {
        var introJS3 = introJs();
        introJS3.setOptions({
          exitOnOverlayClick: thisObj.userDataService.introJsOptions['exitOnOverlayClick'],
          exitOnEsc: thisObj.userDataService.introJsOptions['exitOnEsc'],
          doneLabel: "OK",
          showStepNumbers: thisObj.userDataService.introJsOptions['showStepNumbers'],
          keyboardNavigation: thisObj.userDataService.introJsOptions['keyboardNavigation'],
          disableInteraction: thisObj.userDataService.introJsOptions['disableInteraction'], // doesn't work
          scrollToElement: thisObj.userDataService.introJsOptions['scrollToElement'],
          steps: [
            {
              intro: "<span style='font-weight:bold'>This interface does not show the programs, but instead gives you information about them.<br><br>Specifically, it shows <span style='color:rgb(0, 153, 255); font-weight:bold'>how the two selected programs behave differently.</span></span><br><br>Let’s take a closer look at what that means."
            },
            {
              element: document.querySelectorAll('.situation-label')[0],
              intro: "<span style='font-weight:bold'>The interface shows a flowchart for each situation in which the two programs behave differently.</span><br><br>This is the first situation (out of 2 total) on this page. We will explain more precisely what a <span style='font-weight:bold'>situation</span> is and why there are <span style='font-weight:bold'>2 situations</span> on this page.",
              position:'bottom'
            },
            {
              intro:"Recall that rules look like this:<br>* \"<span style='font-weight:bold'>If</span> [an event happens] <span style='font-weight:bold'>while</span> [a state is true] <span style='font-weight:bold'>then</span> [have the smart home do something].\"<br><br><span style='font-weight:bold'>Having lots of rules can make it hard to know exactly what they will do in a situation, so <span style='color:rgb(0, 153, 255)'>this interface figures that out for you, and then show you all the situations in which their behaviors are different</span>.</span>"
            },
            {
              element: '.flowchart-situation',
              intro: "In each situation, the flowchart shows:<br><span style='font-weight:bold; color:rgb(0, 153, 255)'>1)</span> The <span style='font-weight:bold'>\"while\"</span> part: <span style='font-weight:bold'>what is true</span> about the smart home or the environment and people that affect it, and<br><span style='font-weight:bold; color:rgb(0, 153, 255)'>2)</span> The <span style='font-weight:bold'>\"if\"</span> part: what <span style='font-weight:bold'>event</span> happens that triggers a program to do something.</span><br><br>For example, Alice coming home (event) when the lights are off during the day (what is already true about the home) is a situation.",
              position: "right"
            },
            {
              element: '.flowchart-outcome',
              intro: "<span style='color:rgb(0, 153, 255); font-weight:bold'>A situation will appear on this page if the two programs <span style='font-weight:bold'>do different things in it.</span></span><br><br>In this situation, if Alice comes home during the day while the HUE lights are off, the Original Program would keep the lights off while Program #1 would turn them on.",
              position: "left"
            },
            {
              intro: "<span style='font-weight:bold'>So, there are 2 situations in which the Original Program and Program #1 will do different things.</span><br><br>Likewise, <span style='color:rgb(0, 153, 255); font-weight:bold'>in situations that are <span style='font-weight:bold'>not</span> on this page, the two programs will <span style='font-weight:bold'>do the same things</span>.</span>"
            },
            {
              element: document.querySelectorAll('.flowchart-bar-dev')[1],
              intro: "By the way, <span style='font-weight:bold'>each row shows how some factor</span> (e.g. a device, where someone is, weather) <span style='font-weight:bold'>is affected during this situation.</span><br><br>For example, this row shows that the HUE lights are originally off. After Alice comes home, the HUE lights turn on in the first outcome but stay off in the second.<br><br><span style='font-weight:bold'>If you forget what's happening on the flowchart, use the blue text at the top to guide you.</span>",
              position: "bottom"
            },
            {
              element: document.querySelectorAll('.flowchart-big-box')[1],
              intro: "In Situation #2, when someone or another rule turns on the TV (event) while the speakers are on (what is true about the home), the Original Program will leave the speakers on while Program #1 will turn them off."
            }
          ]
        });
        introJS3.start();
        introJS3.oncomplete(function () {
          setTimeout(function () {
            var introJS4 = introJs();
            introJS4.setOptions({
              exitOnOverlayClick: thisObj.userDataService.introJsOptions['exitOnOverlayClick'],
              exitOnEsc: thisObj.userDataService.introJsOptions['exitOnEsc'],
              doneLabel: "OK",
              showStepNumbers: thisObj.userDataService.introJsOptions['showStepNumbers'],
              keyboardNavigation: thisObj.userDataService.introJsOptions['keyboardNavigation'],
              disableInteraction: thisObj.userDataService.introJsOptions['disableInteraction'], // doesn't work
              scrollToElement: thisObj.userDataService.introJsOptions['scrollToElement'],
              steps: [
                {
                  element: '#savepanel',
                  intro: 'Now, try to complete the task by using what you have learned about the interface. <span style="font-weight:bold">Use this part to select your answer, and click on "Submit" to see if your answer is correct.</span>'
                },
                {
                  element: '#rightdropdown',
                  intro: "Don't forget to use the dropdown menu to see Program #2!"
                }
              ]
            });
            thisObj.tutorialParams['showSavePanel'] = 'true';
            introJS4.start();
          }, 500);
        });
      }, 1500);
    } else if (this.INTRO_DONE == 4 && this.userDataService.SUBMIT_ATTEMPT_CORRECT) {
      this.INTRO_DONE++;
      setTimeout(function () {
        var introJS_final = introJs();
        var answerExplanation:string = "Nice! Program 2 is correct because it does exactly what the Original Program does, except it also turns off the speakers when the TV turns on.<br><br>Program #1 does the latter but not the former, which makes it incorrect.";
        introJS_final.setOptions(thisObj.userDataService.getIntroJsOptionsFinal(answerExplanation));
        introJS_final.start();
      }
      );
    }
  }

  public dropdownValue(i: number): String {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams);
  }

  public getShortProgramName(i: number): string {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams).split("(")[0];
  }

  private getDevName(c: Clause) {
    if (c.device.name == 'Location Sensor') {
      // this is technically a backend problem but we decided to handle it here
      // add the person's name to the end of both dev name and cap name
      return c.device.name + ' ' + c.parameterVals[1].value + ': ' + c.capability.name.split('/').join(' ') + ' ' + c.parameterVals[1].value;
    }
    return c.device.name + ': ' + c.capability.name.split('/').join(' ');
  }

  public updateInitRadioSuggestions() {
    if (Object.keys(this.all_choices).length != Object.keys(this.all_chosen).length) {
      return; //currently do this.
    }

    for (let chosen_key in this.all_choices) {
      let vals = this.all_choices[chosen_key];
      for (let val of vals) {
        let tmp_chosen = {};  //copy this.all_chosen
        for (let key in this.all_chosen) tmp_chosen[key] = this.all_chosen[key];
        tmp_chosen[chosen_key] = val;
      }
    }

  }

  public updateTriggers($event: EventEmitter<MatSelectChange>) {
    // Called whenever the starting states change, this function
    // updates the list of trigger_events based on the starting states
    this.starting_event = null;
    const key: string = this.updateStartKey();

    this.updateInitRadioSuggestions(); //update suggestions for init state radios.
    const relevantTimelines = this.timelines_dict_by_start[key];
    const keepingtrack: string[] = [];
    this.trigger_events = [];
    // this.userDataService.appendLog('relevant timeline: '+relevantTimelines);
    if (relevantTimelines) {
      for (var i = 0; i < relevantTimelines.length; i++) {
        const t = relevantTimelines[i];
        // this.userDataService.appendLog('t: '+JSON.stringify(t));
        if (keepingtrack.indexOf(t.sharedEvents[0].description[0]) == -1) {
          keepingtrack.push(t.sharedEvents[0].description[0]);
          this.trigger_events.push(t.sharedEvents[0]);
        }
      }
    }
    else {
      //no trigger events
    }
    if (this.urlParams['event-autoselect'] == 'one' && this.trigger_events.length == 1) {
      this.starting_event = this.trigger_events[0][0].description; //if only one event, chose this.
      this.updateDisplay(null);
    }
  }

  public updateDisplay($event: EventEmitter<MatSelectChange>) {
    // Called when the triggering event changes, this function
    // updates the timeline based on the starting states and the trigger event
    const key: string = this.updateTriggerKey();
    this.TIMELINE = this.timelines_dict[key];
  }

  private updateStartKey() {
    // This function generates dictionary key based on only the current starting states
    return this.updateStartKeyCore(this.all_chosen);
  }

  public updateStartKeyCore(chosen: { [id: string]: string; }) {
    // This function generates dictionary key based on only the current starting states
    const strs = [];
    var keys = Object.keys(chosen).slice();
    keys.sort();
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      strs.push(key); // includes dev name and comp
      strs.push(chosen[key]);
      strs.push('&');
    }
    return strs.join(' ');
  }

  private updateTriggerKey() {
    // This function generates dictionary key based on the starting states and the trigger event
    const strs = [];
    var keys = Object.keys(this.all_chosen).slice();
    keys.sort();
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      strs.push(key); // includes dev name and comp
      strs.push(this.all_chosen[key]);
      strs.push('&');
    }
    strs.push(this.starting_event);
    return strs.join(' ');
  }

  private genStartKeyForTimeline(timeline: TimelineDiff) {
    // This function generates dictionary key based on only the starting states of the timeline
    // devs, caps, triggering event
    const strs = [];
    const start = timeline.sharedStates[0];

    for (var i = 0; i < start.devs.length; i++) {
      // ignore icons
      var s = [];
      s.push(start.devs[i]);
      s.push(start.comps[i]);
      s.push(start.vals[i]);
      strs.push(s.join(' '));
    }
    let sorted_devs_caps = strs.sort();
    return sorted_devs_caps.join(' & ');
  }

  private genTriggerKeyForTimeline(timeline: TimelineDiff) {
    // This function generates dictionary key based on the starting states and trigger event of the timeline
    // devs, caps, triggering event
    const strs = [];
    const start = timeline.sharedStates[0];
    const trigger = timeline.sharedEvents[0];
    for (var i = 0; i < start.devs.length; i++) {
      // ignore icons
      var s = [];
      s.push(start.devs[i]);
      s.push(start.comps[i]);
      s.push(start.vals[i]);
      strs.push(s.join(' '));
    }
    let sorted_devs_caps = strs.sort();
    var results = [sorted_devs_caps.join(' & ')];
    results.push(trigger.description[0]);
    return results.join(' & '); // change if want to delimit event from states specially
  }

  private equivalentEvents(event1: TimelineEvent, event2: TimelineEvent) {
    return event1.description == event2.description;
  }

  private equivalentStates(state1: TimelineState, state2: TimelineState) {
    // NOTE: this assumes that the states are sorted (e.g. by alphabetical order of devs)
    const state1_internals = state1.devs.map(function (e, i) {
      return [e, state1.comps[i], state1.vals[i]];
    });

    const state2_internals = state2.devs.map(function (e, i) {
      return [e, state2.comps[i], state2.vals[i]];
    });

    if (state1_internals.length != state2_internals.length) {
      return false;
    }

    for (var i: number = 0; i < state1_internals.length; i++) {
      for (var j: number = 0; j < state1_internals[i].length; j++) {
        if (state1_internals[i][j] !== state2_internals[i][j]) {
          return false;
        }
      }
    }

    return true;
  }

  private equivalentTimelines(t1: TimelineDiff, t2: TimelineDiff): boolean {
    if ((t1.sharedEvents.length == t2.sharedEvents.length)
      && (t1.sharedStates.length == t2.sharedStates.length)
      && (t1.diffEvents.length == t2.diffEvents.length)
      && (t1.diffStates.length == t2.diffStates.length)
      && (t1.diffIndices.length == t2.diffIndices.length)) {
      for (var i: number = 0; i < t1.sharedEvents.length; i++) {
        if (!this.equivalentEvents(t1.sharedEvents[i], t2.sharedEvents[i])) {
          return false;
        }
      }
      for (var i: number = 0; i < t1.sharedStates.length; i++) {
        if (!this.equivalentStates(t1.sharedStates[i], t2.sharedStates[i])) {
          return false;
        }
      }
      for (var i: number = 0; i < t1.diffEvents.length; i++) {
        if (!this.equivalentEvents(t1.diffEvents[i], t2.diffEvents[i])) {
          return false;
        }
      }
      for (var i: number = 0; i < t1.diffStates.length; i++) {
        if (!this.equivalentStates(t1.diffStates[i], t2.diffStates[i])) {
          return false;
        }
      }
      for (var i: number = 0; i < t1.diffIndices.length; i++) {
        if (t1.diffIndices[i] != t2.diffIndices[i]) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  public getUnits(dev_str: string): string {
    if (dev_str.includes('Brightness Sensor')) {
      return ' lux';
    }
    if (dev_str.includes('Temperature')) {
      return '°F';
    }
    return '';
  }

  private showComp(comp: string): string {
    if (comp == '=') {
      return '';
    }
    if (comp == '!=') {
      return 'Not';
    }
    return comp;
  }

  public showClause(c: string) {
    return this.userDataService.showClause(c);
  }

  public showVal(comp: string, val: any, start: boolean, dev_str: string): string {
    // a dev is only condensed if it's state doesn't matter and won't change, else it'd be separated
    // start indicated whether this is the leftmost col (i.e. init state)
    let val_str = String(val); // because it could be an int like "70" for temperature
    if (val_str.includes('/ =')) {
      if (start) {
        return ("(doesn't matter)");
      } else {
        return '(no change from before)';
      }
    } else {
      let real_comp: string = this.showComp(comp);
      if (dev_str.includes('Brightness Sensor')) {
        return real_comp + ' ' + val_str + ' lux';
      } else if (dev_str.includes('Temperature')) {
        return real_comp + ' ' + val_str + '°F';
      } else {
        return real_comp + ' ' + val_str;
      }
    }
  }

  public parseTimelineDiffs() {
    const unparsedTimelines = this.unparsedDiff;
    const trigger_events_lst: TimelineEvent[] = [];

    this.timelines_dict = {};
    this.timelines_dict_by_start = {};
    this.TIMELINE = null;
    this.TIMELINES = [];
    this.TIMELINE_KEYS_ORIGINAL = [];

    if (this.unparsedDiff.length == 0) {
      return;
    }

    this.TIMELINES = unparsedTimelines.map((diff => {
      const shared_events: TimelineEvent[] = [];
      const shared_states: TimelineState[] = [];
      const diff_events: TimelineEvent[] = [];
      const diff_states: TimelineState[] = [];
      const ch_ind: number[] = [-1];

      // all nodes on timeline share 'condition'. after event, beh1/2 occur.
      const event = diff.event; // NOTE: assumes that there is only one shared event
      var conditions = diff.condition;

      function condcmp_generator(obj: any) {  //build closure
        return function (a: Clause, b: Clause) {
          const a_name = obj.getDevName(a);
          const b_name = obj.getDevName(b);
          if (a_name < b_name) { return -1; }
          if (a_name > b_name) { return 1; }
          return 0;
        }
      }
      conditions.sort(condcmp_generator(this));

      const beh1 = diff.behavior1;
      const beh2 = diff.behavior2;

      // parse event into format with descriptions (text) and icons
      const eventRep: TimelineEvent = {
        icon: [event.channel.icon],
        description: [event.text],
        devs: [this.getDevName(event)]
      }
      shared_events.push(eventRep);
      trigger_events_lst.push(eventRep);

      // Figure out what to show as the behaviors. 
      // If a behavior has two actions but they're the same action, then only show one.
      var beh1Text: string[] = [];
      var beh1Icon: string[] = [];
      var beh1Devs: string[] = [];
      var beh2Text: string[] = [];
      var beh2Icon: string[] = [];
      var beh2Devs: string[] = [];
      if (beh1 && beh1.length) {
        for (var b of beh1) {
          if (!beh1Text.includes(b.text)) {
            beh1Text.push(b.text);
            beh1Icon.push(b.channel.icon);
            beh1Devs.push(this.getDevName(b));
          }
        }
      } else {
        beh1Text.push('(Do nothing)');
        beh1Icon.push('block');
        // beh1Devs is left empty
      }
      if (beh2 && beh2.length) {
        for (var b of beh2) {
          if (!beh2Text.includes(b.text)) {
            beh2Text.push(b.text);
            beh2Icon.push(b.channel.icon);
            beh2Devs.push(this.getDevName(b));
          }
        }
      } else {
        beh2Text.push('(Do nothing)');
        beh2Icon.push('block');
        // beh2Devs is left empty
      }

      const beh1Rep: TimelineEvent = {
        icon: beh1Icon,
        description: beh1Text,
        devs: beh1Devs,
      }
      const beh2Rep: TimelineEvent = {
        icon: beh2Icon,
        description: beh2Text,
        devs: beh2Devs,
      }
      diff_events.push(beh1Rep);
      diff_events.push(beh2Rep);

      // Initial state: parse conditions into format with descriptions (text) and icons
      const unsorted_condDevs: string[] = [];
      const unsorted_condComps: string[] = [];
      const unsorted_condVals: string[] = [];
      const unsorted_condIcons: string[] = [];
      for (let i = 0; i < conditions.length; i++) {
        let cond = conditions[i];
        unsorted_condDevs.push(this.getDevName(cond));
        unsorted_condIcons.push(cond.channel.icon);
        if (cond.parameterVals.length > 1) { // this.getDevName(cond).startsWith('Location Sensor')
          unsorted_condVals.push(cond.text);
          unsorted_condComps.push('=');
        } else {
          if (this.getDevName(cond) == 'Security Camera: Record') {
            unsorted_condVals.push(cond.parameterVals[0].value == 'On' ? 'Recording' : 'Not recording');
          } else {
            unsorted_condVals.push(cond.parameterVals[0].value);
          }
          unsorted_condComps.push(cond.parameterVals[0].comparator);
        }

        var key = this.getDevName(cond) + ' ' + cond.parameterVals[0].comparator;
        if (!this.all_choices[key]) {
          this.all_choices[key] = new Set<string>();
        }
        this.all_choices[key].add(cond.parameterVals[0].value);
      }

      const condDevsVals = unsorted_condDevs.map(function (a, b) {
        return [a, unsorted_condVals[b]].join(' ');
      });
      const condSortKey = condDevsVals.sort();
      const condDevs = unsorted_condDevs.sort(function (a, b) {
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });
      const condIcons = unsorted_condIcons.sort(function (a, b) {
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });
      const condComps = unsorted_condComps.sort(function (a, b) {
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });
      const condVals = unsorted_condVals.sort(function (a, b) {
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });

      const initState: TimelineState = {
        icons: condIcons,
        devs: condDevs,
        comps: condComps,
        vals: condVals
      }
      shared_states.push(initState);

      // Intermediate state: get event, find the dev state it changes, and change accordingly
      var trigIcons: string[] = condIcons.map(x => x);
      var trigComps: string[] = condComps.map(x => x);
      var trigVals: string[] = condVals.map(x => x);
      var ind = -1;
      if (!this.getDevName(event).startsWith('Location Sensor')) { // this.getDevName(event) != 'Location Sensor: Detect Presence'
        ind = condDevs.indexOf(this.getDevName(event));
      } else {
        for (var i = 0; i < condVals.length; i++) {
          var person: string = event.parameterVals[1].value;
          var condDev = condDevs[i].toString();
          if (condDev.endsWith(person)) {
            ind = i;
            break;
          }
        }
      }
      ch_ind.push(ind);
      trigIcons.splice(ind, 1, event.channel.icon);
      if (event.parameterVals.length > 1) {
        if (this.getDevName(event).startsWith('Location Sensor')) {
          let comp = '=';
          let val = '';
          for (let ii in event.parameters) {
            if (event.parameters[ii].name == 'location') {
              comp = event.parameterVals[ii].comparator;
              val = event.parameterVals[ii].value;
              break;
            }
          }
          trigComps.splice(ind, 1, comp);
          trigVals.splice(ind, 1, val);
        } else {
          console.error('there is a cap with 2 params but not location sensor: ' + this.getDevName(event));
        }
      } else {
        if (this.getDevName(event) == 'Security Camera: Record') {
          trigVals.splice(ind, 1, event.parameterVals[0].value == 'On' ? 'Recording' : 'Not recording');
        } else {
          trigVals.splice(ind, 1, event.parameterVals[0].value);
        }
        trigComps.splice(ind, 1, event.parameterVals[0].comparator);
      }

      const triggeredState: TimelineState = {
        icons: trigIcons,
        devs: condDevs, // note that dev names (condDevs) doesn't change for any states
        comps: trigComps,
        vals: trigVals
      }
      shared_states.push(triggeredState);

      // Final state #1: get event, find the dev state it changes, and change accordingly
      var beh1Icons: string[], beh1Comps: string[], beh1Vals: string[];
      if (beh1 && beh1.length) {
        for (var b of beh1) {
          beh1Icons = trigIcons.map(x => x);
          beh1Comps = trigComps.map(x => x);
          beh1Vals = trigVals.map(x => x);
          var ind1 = -1;
          if (!this.getDevName(b).startsWith('Location Sensor')) {
            ind1 = condDevs.indexOf(this.getDevName(b));
          } else {
            for (var i = 0; i < beh1Vals.length; i++) {
              var person: string = b.parameterVals[1].value;
              var cap_match: string = person.split(' ').length == 1 ? beh1Vals[i].split(' ')[0] : beh1Vals[i].split(' ')[0] + ' ' + beh1Vals[i].split(' ')[1];
              if (person == cap_match) {
                ind1 = i;
                break;
              }
            }
          }
          ch_ind.push(ind1);
          beh1Icons.splice(ind1, 1, b.channel.icon);
          if (b.parameterVals.length > 1) { // this.getDevName(b).startsWith('Location Sensor')
            beh1Comps.splice(ind1, 1, '=');
            var in_at: string = b.text.includes('Home') ? 'at' : 'in';
            beh1Vals.splice(ind1, 1, b.text.replace('Enters', 'is ' + in_at).replace('Exits', 'is not ' + in_at));
          } else {
            if (this.getDevName(b) == 'Security Camera: Record') {
              beh1Vals.splice(ind1, 1, b.parameterVals[0].value == 'On' ? 'Recording' : 'Not recording');
            } else {
              beh1Vals.splice(ind1, 1, b.parameterVals[0].value);
            }
            beh1Comps.splice(ind1, 1, b.parameterVals[0].comparator);
          }
        }
      } else {
        beh1Icons = trigIcons;
        beh1Comps = trigComps;
        beh1Vals = trigVals;
        ch_ind.push(-1);
      }

      const beh1State: TimelineState = {
        icons: beh1Icons,
        devs: condDevs,
        comps: beh1Comps,
        vals: beh1Vals
      }
      diff_states.push(beh1State);

      // Final state #2: get event, find the dev state it changes, and change accordingly
      var beh2Icons: string[], beh2Comps: string[], beh2Vals: string[];
      if (beh2 && beh2.length) {
        beh2Icons = trigIcons.map(x => x);
        beh2Comps = trigComps.map(x => x);
        beh2Vals = trigVals.map(x => x);
        for (var b of beh2) {
          var ind2 = -1;
          if (!this.getDevName(b).startsWith('Location Sensor')) {
            ind2 = condDevs.indexOf(this.getDevName(b));
          } else {
            for (var i = 0; i < beh2Vals.length; i++) {
              var person: string = b.parameterVals[1].value;
              var cap_match: string = person.split(' ').length == 1 ? beh2Vals[i].split(' ')[0] : beh2Vals[i].split(' ')[0] + ' ' + beh2Vals[i].split(' ')[1];
              if (person == cap_match) {
                ind2 = i;
                break;
              }
            }
          }
          ch_ind.push(ind2);
          beh2Icons.splice(ind2, 1, b.channel.icon);
          if (b.parameterVals.length > 1) { // this.getDevName(b).startsWith('Location Sensor')
            beh2Comps.splice(ind2, 1, '=');
            var in_at: string = b.text.includes('Home') ? 'at' : 'in';
            beh2Vals.splice(ind2, 1, b.text.replace('Enters', 'is ' + in_at).replace('Exits', 'is not ' + in_at));
          } else {
            if (this.getDevName(b) == 'Security Camera: Record') {
              beh2Vals.splice(ind2, 1, b.parameterVals[0].value == 'On' ? 'Recording' : 'Not recording');
            } else {
              beh2Vals.splice(ind2, 1, b.parameterVals[0].value);
            }
            beh2Comps.splice(ind2, 1, b.parameterVals[0].comparator);
          }
        }
      } else {
        beh2Icons = trigIcons;
        beh2Comps = trigComps;
        beh2Vals = trigVals;
        ch_ind.push(-1);
      }

      const beh2State: TimelineState = {
        icons: beh2Icons,
        devs: condDevs,
        comps: beh2Comps,
        vals: beh2Vals
      }
      diff_states.push(beh2State);

      const diff_ind: number[] = [];
      for (var i = 0; i < beh1State.devs.length; i++) {
        if ((beh1State.devs[i] != beh2State.devs[i])
          || (beh1State.comps[i] != beh2State.comps[i])
          || (beh1State.vals[i] != beh2State.vals[i])) {
          diff_ind.push(i);
        }
      }

      if (!this.equivalentStates(diff_states[0], diff_states[1])) {
        const timeline: TimelineDiff = {
          sharedEvents: shared_events,
          sharedStates: shared_states,
          diffEvents: diff_events,
          diffStates: diff_states,
          diffIndices: diff_ind
        }

        const triggerKey = this.genTriggerKeyForTimeline(timeline);
        if (this.timelines_dict[triggerKey]) {
          // there is already a timeline here -- if it's different from
          // the one we're about to add, then it's a problem
          if (!this.equivalentTimelines(this.timelines_dict[triggerKey], timeline)) {
            console.error('two conflicting timelines with the same init state and event');
            console.error('current timeline' + JSON.stringify(timeline));
            console.error('existing timeline' + JSON.stringify(this.timelines_dict[triggerKey]));
          }
        }
        this.timelines_dict[triggerKey] = timeline;

        const startKey = this.genStartKeyForTimeline(timeline);
        if (!this.timelines_dict_by_start[startKey]) {
          this.timelines_dict_by_start[startKey] = [];
        }
        this.timelines_dict_by_start[startKey].push(timeline);
        return timeline;
      } else {
        return null;
      }
    }));
    this.TIMELINES = this.TIMELINES.filter((x): x is TimelineDiff => x !== null);

    if (this.TIMELINES.length > 0) {
      this.TIMELINE = this.TIMELINES[0];
      this.TIMELINE_KEYS_ORIGINAL = Object.keys(this.timelines_dict);

      if (this.urlParams["skip-init"] != "true") {
        // populate the original setting
        for (var i = 0; i < this.TIMELINE.sharedStates[0].devs.length; i++) {
          var key: string = this.TIMELINE.sharedStates[0].devs[i] + ' ' + this.TIMELINE.sharedStates[0].comps[i];
          this.all_chosen[key] = this.TIMELINE.sharedStates[0].vals[i];
        }

        this.updateTriggers(null);
      }
      else {
      }
    }
  }

  public getPrgmRespText(event: TimelineEvent): string {
    if (event.devs.length > 0) {
      return ' responds...';
    }
    // return '('+prgm+' does nothing...)';
    return ' does nothing...';
  }

  public getTrigger(timeline: TimelineDiff): TimelineEvent {
    return timeline.sharedEvents[0];
  }

  public getStartDevState(timeline: TimelineDiff, j: number): string {
    return timeline.sharedStates[0].devs[j];
  }

  public getTriggerIfDev(timeline: TimelineDiff, j: number): string[] {
    // j = index of dev we are querying. 
    // If this dev is (in) the trigger (which should just be one dev), then return the icon and description 
    let trigger = this.getTrigger(timeline); // TimelineEvent
    let dev = this.getStartDevState(timeline, j);
    for (let d in trigger.devs) { // usually only one item here
      if (trigger.devs[d] == dev) {
        let res = [trigger.icon[d], this.showClause(trigger.description[d])];
        return res;
      }
    }
    return ['none', 'none'];
  }

  public getFinalDevState(timeline: TimelineDiff, prgmInd: number, devInd: number) {
    // getFinalDevState(thisTIMELINE, base, j)
    return this.showVal(timeline.diffStates[prgmInd].comps[devInd], timeline.diffStates[prgmInd].vals[devInd], false, timeline.diffStates[prgmInd].devs[devInd]);
  }

  private updateNumOptsName() {
    let new_num_opts_dict = {};
    for (let key in this.num_opts_dict) {
      let new_key = key.split('/').join(' ');
      new_num_opts_dict[new_key] = this.num_opts_dict[key];
    }
    this.num_opts_dict = new_num_opts_dict;
  }

  public timelineValid() {
    if (!this.TIMELINE) return false;
    if (!this.TIMELINE_KEY) {
      // console.warn("# timelineValid this.TIMELINE is null, but TIMELINE_KEY exist.");
      return false;
    }
    if (this.TIMELINE_KEYS_FILTERED_CONDENSED.length == 0) {
      console.warn("# timelineValid TIMELINE_KEYS_FILTERED_CONDENSED is [], TIMELINE_KEY should be null.");
    }
    return true;
  }

  public filterValid(filterName: string) {
    if (!this.FILTERS[filterName]) return false;
    if (this.FILTERS[filterName].trim().length == 0) return false;
    return true;
  }

  public filtersValid() {
    if (this.filterValid('device') && this.filterValid('event')) return true;
    return false;
  }

  public getCurrentTimelineIndex() {
    for (let i = 0; i < this.TIMELINE_KEYS_FILTERED_CONDENSED.length; i++) {
      if (this.TIMELINE_KEY == this.TIMELINE_KEYS_FILTERED_CONDENSED[i]) {
        return i + 1;
      }
    }
    return -1;
  }

  public getViewableTimelineCount() {
    return this.TIMELINE_KEYS_FILTERED_CONDENSED.length;
  }

  public getDeviceIndexByCurrentMask(devs: string[], ti: number) {
    // the indices that should be shown (not hidden)
    // this.userDataService.appendLog('devs: '+devs);
    let idxs = [];
    for (let i = 0; i < devs.length; i++) {
      if (this.getCurrentMask(devs[i], ti)) idxs.push(i);
    }
    // this.userDataService.appendLog('getDeviceIndexByCurrentMask: '+JSON.stringify(idxs));
    return idxs;
  }

  public devInds(ti: number) {
    return [...Array(this.getDeviceIndexByCurrentMask(this.TIMELINES[ti].sharedStates[0].devs, ti).length).keys()];
  }

  public getCurrentMask(dev: string, ti: number): boolean { // currently this fn just needs to decide whether there is mask, not what the mask is
    // this.userDataService.appendLog('getCurrentMask: '+dev);
    if (!this.SHOW_ALL_DEVS_PER_TIMELINE[ti]) {
      //use mask
      let tk = this.TIMELINE_KEYS_FILTERED_CONDENSED[ti];
      if (this.TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS[tk]) {
        //if found mask, use mask.
        if (dev in this.TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS[tk]) {
          return false; // hidden
        }
      }
      return true; //show this device
    }
    else {
      //don't use mask
      return true; //always show this device
    }
  }

  public trimDevName(dev: string): string {
    return this.userDataService.trimDevName(dev, true);
  }

  private condenseTimelineKeysFiltered() {
    var transFkeys = [];
    for (let fkey of this.TIMELINE_KEYS_FILTERED) transFkeys.push(fkey);

    if (this.urlParams['condense-enable'] != 'false') {
      while (true) {
        const fkeysize = transFkeys.length;
        let combinedFlagFkeys: boolean[] = new Array(fkeysize);
        combinedFlagFkeys.fill(false);
        let anyCombine = false;
        for (let i = 0; i < fkeysize; i++) {
          if (combinedFlagFkeys[i]) {
            continue;
          }
          for (let j = i + 1; j < fkeysize; j++) {
            if (combinedFlagFkeys[j]) {
              continue;
            }
            let fkeyi = transFkeys[i];
            let fkeyj = transFkeys[j];
            let initi = this.getInitStatesFromKey(fkeyi);
            let initj = this.getInitStatesFromKey(fkeyj);

            let initDiff = this.getDiffStates(initi, initj);
            let diffSize = Object.keys(initDiff).length;

            if (diffSize == 1) {
              let tlinei = this.timelines_dict[fkeyi];
              let tlinej = this.timelines_dict[fkeyj];
              let unchangedDevi = this.getUnchangedDevicesFromTimeline(tlinei);
              let unchangedDevj = this.getUnchangedDevicesFromTimeline(tlinej);
              let checkDev = Object.keys(initDiff)[0];
              if (unchangedDevi[checkDev] && unchangedDevj[checkDev] && this.checkTimelineEventEqual(tlinei, tlinej)) {
                //checkDev remain the same in both timelines.
                combinedFlagFkeys[j] = true;
                let newKey = this.getNewKeyByOldKeyAndDiff(fkeyi, initDiff);
                transFkeys[i] = newKey;
                this.generateTimelineForCondensedKey(newKey);
                anyCombine = true;
              }
            }
          }
        }
        transFkeys = transFkeys.filter(function (value, index) { return !combinedFlagFkeys[index] });
        if (!anyCombine) break;
      }
    }

    this.TIMELINE_KEYS_FILTERED_CONDENSED = transFkeys;
    //add mask.
    this.TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS = {};
    let devs = this.TIMELINE_KEYS_BY_INITSTATE_BY_DEVICE__KEYS;
    for (let ckey of transFkeys) {
      this.TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS[ckey] = {};
      let maskDevs = this.getMaskDevicesFromKey(ckey);
      for (let dev of devs) this.TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS[ckey][dev] = true;
      for (let dev of maskDevs) this.TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS[ckey][dev] = false;
    }
  }

  public getEventFromKey(timeLineKey: string) {
    let tokens = timeLineKey.split("&").map(x => x.trim()).filter(x => x != "");
    let eventstr = tokens[tokens.length - 1];
    return eventstr;
  }

  public getInitStatesFromKey(timeLineKey: string) {
    let tokens = timeLineKey.split("&").map(x => x.trim()).filter(x => x != "");
    let initStates: { [id: string]: string[] } = {};
    for (let i = 0; i < tokens.length - 1; i++) {
      let token = tokens[i];
      let words = token.split(/(!=|=|>|<|\/)/).map(x => x.trim()).filter(x => x != "");
      if ((words.length) % 3 != 0) console.error("# getInitStatesFromKey. unexpected key:", timeLineKey, " | words:", words);
      initStates[words[0]] = words.slice(1); //initStates[device] = [op, value, '/', op2, value2....]
    }
    return initStates;
  }

  public getMaskDevicesFromKey(condensedTimeLineKey: string) {
    let initStates = this.getInitStatesFromKey(condensedTimeLineKey);
    let maskDevs = [];
    for (let dev in initStates) {
      if (initStates[dev].length == this.num_opts_dict[dev] * 3 - 1) {
        if (initStates[dev][2] != '/') {
          console.error("# getMaskDevicesFromKey unexpected initStates:", initStates[dev]);
          continue;
        }
        maskDevs.push(dev);
      }
    }
    return maskDevs;
  }

  public generateTimelineForCondensedKey(condensedKey: string) {
    //first: get a normal key.
    let env = this.getEventFromKey(condensedKey);
    let initState = this.getInitStatesFromKey(condensedKey);
    let reduceInitState: { [id: string]: string } = {};
    for (let dev in initState) {
      reduceInitState[dev] = initState[dev].slice(0, 2).join(" ");
    }
    let startKey = this.updateStartKeyCore(reduceInitState);
    let normalKey = [startKey, env].join(" ");
    let normalTimeline = this.timelines_dict[normalKey];
    if (!normalTimeline) {
      console.error("# generateTimelineForCondensedKey normalKey invalid.", normalKey);
      alert("error");
      return;
    }
    let condensedTimeline = <TimelineDiff>DiffcomService.deepCopy(normalTimeline);
    function checkUpdateState(st: TimelineState) {
      let stSize = st.devs.length;
      for (let i = 0; i < stSize; i++) {
        let dev = st.devs[i];
        if (initState[dev].length > 2) {
          //special date
          let ap = initState[dev].join("");
          // alert(ap);
          if (ap.indexOf("/") < 0) {
            console.error("# generateTimelineForCondensedKey find initState.length > 2 but no '/'.", initState);
            alert("error");
          }
          st.vals[i] = initState[dev].slice(1).join(" ");
        }
      }
    }
    for (let st of condensedTimeline.sharedStates) checkUpdateState(st);
    for (let st of condensedTimeline.diffStates) checkUpdateState(st);
    this.timelines_dict[condensedKey] = condensedTimeline;

  }

  public getNewKeyByOldKeyAndDiff(oldKey: string, diff: { [id: string]: string[] }) {
    let evt = this.getEventFromKey(oldKey);
    let inits = this.getInitStatesFromKey(oldKey);
    if (Object.keys(diff).length != 1) {
      console.log("# getNewKeyByOldKeyAndDiff error. diff unexpected.", diff);
      alert("error");
    }
    let dkey = Object.keys(diff)[0];
    inits[dkey] = diff[dkey];
    let comInits: { [id: string]: string } = {};
    for (let key in inits) {
      comInits[key] = inits[key].join(" ");
    }

    let startKey = this.updateStartKeyCore(comInits);
    let fullKey = [startKey, evt].join(" ");
    return fullKey;
  }

  private getDiffStates(
    state1: { [id: string]: string[] },
    state2: { [id: string]: string[] }) {
    let result: { [id: string]: string[] } = {};
    for (let dev in state1) {
      let ap1 = state1[dev];
      let ap2 = state2[dev];
      let apEqual = true;
      let strap1 = ap1.join("")//.replace(" ", "");
      let strap2 = ap2.join("")//.replace(" ", "");
      if (strap1 != strap2) apEqual = false;
      if (apEqual == false) {
        let slap1 = strap1.split("/").map(x => x.trim()).filter(x => x != "");
        let slap2 = strap2.split("/").map(x => x.trim()).filter(x => x != "");
        let mergeap = [...new Set(slap1.concat(slap2))];
        if (mergeap.length == slap1.length && mergeap.length == slap2.length) {
          console.error("# getDiffStates find same states but key different. ap1:", ap1, " | ap2:", ap2);
        }
        let strmergeap = mergeap.sort().join("/");
        let words = strmergeap.split(/(!=|=|>|<|\/)/).map(x => x.trim()).filter(x => x != "");
        result[dev] = words;
      }
    }
    return result;
  }

  private getUnchangedDevicesFromTimeline(tline: TimelineDiff): { [id: string]: boolean } {
    if (!tline) {
      console.error("# getUnchangedDevicesFromTimeline invalid input.");
      alert("error");
      return null;
    }
    let initStates = tline.sharedStates[0];
    let deviceDict = {};
    for (let dev of tline.sharedStates[0].devs) deviceDict[dev] = true;
    function updateDeviceDict(ts1: TimelineState, ts2: TimelineState) {
      let t1 = {};
      let t2 = {};
      for (let i in ts1.devs) t1[ts1.devs[i]] = (ts1.comps[i] + ts1.vals[i]).replace(/[ ]/g, "");
      for (let i in ts2.devs) t2[ts1.devs[i]] = (ts2.comps[i] + ts2.vals[i]).replace(/[ ]/g, "");
      for (let dev in t1) {
        if (t1[dev] != t2[dev]) deviceDict[dev] = false;
      }
    }
    for (let sts of tline.sharedStates) {
      updateDeviceDict(initStates, sts);
    }
    for (let dts of tline.diffStates) {
      updateDeviceDict(initStates, dts);
    }
    return deviceDict;
  }

  private checkTimelineEventEqual(tline1: TimelineDiff, tline2: TimelineDiff) {
    if (tline1.sharedEvents.length != tline2.sharedEvents.length) return false;
    if (tline1.diffEvents.length != tline2.diffEvents.length) return false;
    for (let i in tline1.sharedEvents) {
      if (tline1.sharedEvents[i].description[0].trim() != tline2.sharedEvents[i].description[0].trim()) return false;
    }
    for (let i in tline1.diffEvents) {
      if (tline1.diffEvents[i].description[0].trim() != tline2.diffEvents[i].description[0].trim()) return false;
    }
    return true;
  }

  public updateTimelineNew() {
    // this.userDataService.appendLog('start of updateTimelineNew');
    let resultSet = DiffcomService.deepCopy(this.TIMELINE_KEYS_ORIGINAL);
    // this.userDataService.appendLog('resultSet: '+JSON.stringify(resultSet));
    this.TIMELINE_KEYS_FILTERED = resultSet;
    this.condenseTimelineKeysFiltered();

    this.userDataService.appendLog(
      "timeline FILTER update | " + this.FILTERS['device'] + " | " + this.FILTERS['event'] +
      " | filtered count: " + this.TIMELINE_KEYS_FILTERED.length +
      " | condensed count: " + this.TIMELINE_KEYS_FILTERED_CONDENSED.length);
    if (!this.TIMELINE_KEYS_FILTERED_CONDENSED.length) {
      this.TIMELINE = null;
      return;
    }
    this.TIMELINE_KEY = this.TIMELINE_KEYS_FILTERED_CONDENSED[0];
    // this.userDataService.appendLog('timeline key: '+this.TIMELINE_KEY);

    if (this.TIMELINE_KEY.length == 0) {
      console.error("# updateTimeline. TIMELINE_KEY is invalid.");
      alert("error");
      return;
    }
    //should check or something?
    this.TIMELINE = this.timelines_dict[this.TIMELINE_KEY];
    this.userDataService.appendLog("updateTimeline | " + this.TIMELINE_KEY);
  }

  public updateDiffAndTimeline($event: EventEmitter<MatSelectChange>) {
    if (this.urlParams['tutorial'] == 'true' && this.INTRO_DONE < 4 && this.VERSION_2 != 1) {
      return
    }

    // Called when selecting a program on the top of the page
    // this.userDataService.appendLog('updateDiff');
    this.isLoading = true;
    this.isError = false;
    this.userDataService.compareRules(this.userDataService.hashed_id, 'timeline', this.VERSION_1, this.VERSION_2)
      .subscribe(data => {
        this.unparsedDiff = data['diff'];
        this.num_opts_dict = data['num_opts'];
        this.updateNumOptsName();
        if (this.unparsedDiff) {
          this.parseTimelineDiffs();

          this.FILTERS['device'] == '(Any Devices)';
          this.FILTERS['event'] == '(Any Events)';
          this.updateTimelineNew();
        }
        else {
          this.isError = true;
        }
        this.isLoading = false;
      }
      );
    if (this.VERSION_2 == this.PROGRAMNUMS[1]) {
      this.DROPDOWN_CLICKED = true;
    } else {
      this.DROPDOWN_CLICKED = false;
    }
  }

  public updateTimeline() {
    if (this.TIMELINE_KEY.length == 0) {
      console.error("# updateTimeline. TIMELINE_KEY is invalid.");
      alert("error");
      return;
    }
    //should check or something?
    this.TIMELINE = this.timelines_dict[this.TIMELINE_KEY];
    this.userDataService.appendLog("updateTimeline | " + this.TIMELINE_KEY);
  }

  public getCondensedTimelines() {
    let res = [];
    for (let k of this.TIMELINE_KEYS_FILTERED_CONDENSED) {
      res.push(this.timelines_dict[k]);
    }
    return res;
  }

  public devIsDif(timeline: TimelineDiff, j: number): Boolean {
    // if this returns false, use flowchart-cap-gray
    // else, use flowchart-cap-del/add
    return timeline.diffIndices.includes(j);
  }

  public setReady() {
    this.READY = true;
  }

  private prgmNumsDefined() {
    this.PRGMNUMSDEFINED = true;
  }
}
