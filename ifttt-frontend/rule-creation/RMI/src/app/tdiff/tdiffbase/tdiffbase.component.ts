import { Component, OnInit, EventEmitter, ElementRef, ViewChild } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UserDataService, Clause, Channel, Device, Capability, Parameter } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { MatSelectChange } from '@angular/material/select';

import { HelpInfoDialogCommonComponent } from '../../help-info-dialog/help-info-dialog-common/help-info-dialog-common.component';

import { Rule } from '../../user-data.service';
import { DiffcomService, RuleUIRepresentation } from '../../diffcom.service';

export interface TimelineDiff {
  sharedEvents: TimelineEvent[]; // this only has 1 elt and will also double as the TimelineDiff's id
  sharedStates: TimelineState[];
  diffEvents: TimelineEvent[]; // only 2, 1st being the 1st program's and vv
  diffStates: TimelineState[]; // only 2, 1st being the 1st program's and vv
  indices: number[]; // just [0, ..., num of states+events-1 in timeline]
  changedIndices: number[][]; // list of num[]s, each representing index of the changed dev in the state
  diffIndices: number[]; // indices of devs dif between the two choices
}

export interface TimelineEvent {
  icon: string[];
  description: string[];
  devs: string[];
}

export interface TimelineState {
  icons: string[];
  devs: string[];
  comps: string[];
  vals: string[];
}

export interface UnparsedTimelineDiff {
  event: Clause;
  condition: Clause[];
  behavior1: Clause[];
  behavior2: Clause[];
}

@Component({
  selector: 'app-tdiffbase',
  template: ''
})

// 1. User chooses the starting states
// 2. Using those starting states we find the timelines that correspond to them,
// 3. We get the set of trigger events from those timelines
// 4. We display the trigger events
export class TdiffbaseComponent implements OnInit {
  private unparsedDiff: UnparsedTimelineDiff[];
  public phrase: number = 0;
  public isLoading: boolean = false;
  public isError: boolean = false;

  @ViewChild('timelineControlPanel')
  controlPanel: ElementRef;
  public controlPanelFloating: boolean = false;
  public controlPanelHeight: number = 250;

  @ViewChild('flowChartResizeOracle')
  flowChartResizeOracle: ElementRef;

  public urlParams = {
    "dropdown-style": "none",
    "dropdown-label": "false",
    'card-state-bgcolor': "less", //for mat-card, show less style on card.
    "condense-enable": "true",
    "dev-mask": "true",
    "timeline-style": "basic" //"flowchart"
  };

  public TIMELINES: TimelineDiff[];
  // Was hoping have this as a placeholder so that when html loads before the parse fn
  // it doesn't result in a bunch of "TypeError: TIMELINE is undefined"
  // even if the content loads just a sec later. Unfortunately, it doesn't help.
  public TIMELINE: TimelineDiff = {
    sharedEvents: [],
    sharedStates: [],
    diffEvents: [],
    diffStates: [],
    indices: [],
    changedIndices: [],
    diffIndices: []
  };

  public TIMELINE_KEYS_ORIGINAL: string[] = [];

  private all_suggestions: { [id: string]: { [id: string]: boolean; } } = {};
  private all_choices: { [id: string]: Set<string>; } = {}; // key = cond.device.name + ' ' + cond.parameterVals[0].comparator;
  private all_chosen: { [id: string]: string; } = {}; // like all_devs, but with actual choice as value
  public trigger_events: TimelineEvent[] = []; // list of available trigger events
  private starting_event: string = ''; // the one we start with

  // the first of the two consecutive states to focus on (alias for the gap between two states on UI);
  public FOCUSINDEX: number; // bound to slider value

  public VERSION_1: number;
  public VERSION_2: number;
  public PROGRAMNUMS: number[];
  public DESIREDPROGRAM: number; // the program that the user chooses at the end to save
  public PROGRAMS: { [id: number]: Rule[]; } = {};

  // Keeping track of timelines based on their start states (and maybe trigger events)
  public timelines_dict: { [id: string]: TimelineDiff; } = {}; // key = list of states + event
  public timelines_dict_by_start: { [id: string]: TimelineDiff[]; } = {}; // key = list of states

  // Keeping track of number of options for different device:capabilities
  public num_opts_dict: { [id: string]: number; } = {};

  //flowchart resize update function
  public flowchartResizeHandler: Function = null;

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
        var viewportHeight = window.innerHeight;
        if (pageYOffset > 100 && thisObj.urlParams['select-style'] != 'radio') {
          if (!thisObj.controlPanelFloating){
            thisObj.controlPanelFloating = true;
            if(thisObj.controlPanel){
              // console.log("# checkTopVisibilityConstructor: controlPanel", thisObj.controlPanel.nativeElement);
              thisObj.controlPanelHeight = thisObj.controlPanel.nativeElement.offsetHeight + 2;
            }
          }
        }
        else {
          thisObj.controlPanelFloating = false;
        }
        // console.log("# checkTopVisibility:", pageYOffset, viewportHeight);
      }
      return checkTopVisibility;
    }

    /* ATTENTION! "this" keyword need force evaluate before pass to addEventListener.
    Attach event handlers to resize and scroll event */
    window.addEventListener("resize", checkTopVisibilityConstructor(this), false);
    window.addEventListener("scroll", checkTopVisibilityConstructor(this), false);

    let thisObj = this;
    function flowchartResizeHandler(){
      const divide_distance = 50;
      const half_divide_dis = divide_distance / 2;
      if(thisObj.flowChartResizeOracle){
          var ora_width = thisObj.flowChartResizeOracle.nativeElement.clientWidth;
          var ora_height = thisObj.flowChartResizeOracle.nativeElement.clientHeight;
          var t_up_offset = - ((ora_height / 2 + half_divide_dis) / 2 - ora_height / 2);
          var t_top_offset = - half_divide_dis;
          var big_box_margin = half_divide_dis + 50;
          var t_up_angle = - Math.atan((ora_height / 2 + half_divide_dis) / ora_width) / Math.PI * 180;
          // console.log("# oracle size:", ora_width, ora_height, " | offset:", t_up_offset);
          thisObj.elementRef.nativeElement.style.setProperty('--t-up-angle', t_up_angle + 'deg');
          thisObj.elementRef.nativeElement.style.setProperty('--t-up-offset', t_up_offset + 'px');
          thisObj.elementRef.nativeElement.style.setProperty('--t-top-offset', t_top_offset + 'px');
          thisObj.elementRef.nativeElement.style.setProperty('--big-box-margin', big_box_margin + 'px');
          thisObj.elementRef.nativeElement.style.setProperty('--oracle-width', ora_width + 'px');
          thisObj.elementRef.nativeElement.style.setProperty('--oracle-height', ora_height + 'px')
      }
    }
    window.addEventListener("resize", flowchartResizeHandler);
    setInterval(flowchartResizeHandler, 2000);
    this.flowchartResizeHandler = flowchartResizeHandler;

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
            if (this.PROGRAMNUMS.length > 0) {
              this.VERSION_1 = this.PROGRAMNUMS[0]
              this.VERSION_2 = this.PROGRAMNUMS[1];
              if (this.urlParams['radio-style'] == 'onex') this.VERSION_2 = this.PROGRAMNUMS[1];
              if (this.urlParams['select-style'] != 'radio') this.VERSION_2 = null;
              if (this.urlParams['dropdown-style'] == 'none') this.VERSION_2 = -2;
              if (this.urlParams['dropdown-style'] == 'onex') this.VERSION_2 = this.PROGRAMNUMS[1];
              // this.DESIREDPROGRAM = this.PROGRAMNUMS[0];

              //set unparsed rules by version id in PROGRAMS.
              for (let progNum of this.PROGRAMNUMS) this.PROGRAMS[progNum] = data["programs"][progNum]["rules"];

              if(this.VERSION_2 >= 0){
                console.log("# ngOnInit.getVersionPrograms prepare init: ", this.VERSION_1, " <-> ", this.VERSION_2);
                this.isLoading = true;
                this.userDataService.compareRules(this.userDataService.hashed_id, 'timeline', this.VERSION_1, this.VERSION_2)
                  .subscribe(data => {
                    this.unparsedDiff = data['diff'];
                    this.num_opts_dict = data['num_opts'];
                    this.updateNumOptsName();
                    if (this.unparsedDiff) {
                      this.parseTimelineDiffs();
                    }
                    console.log("# unparsedDiff:", this.unparsedDiff);
                    this.isLoading = false;
                  }
                );
              }
            }
          })
      })
    });
  }

  public dropdownValue(i: number): String {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams);
  }

  public getShortProgramName(i: number): string{
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams).split("(")[0];
  }

  private getDevName(c: Clause) {
    return c.device.name + ': ' + c.capability.name.split('/').join(' ');
  }

  public updateDiff($event: EventEmitter<MatSelectChange>) {
    // Called when selecting a program on the top of the page
    this.isLoading = true;
    this.isError = false;
    this.userDataService.compareRules(this.userDataService.hashed_id, 'timeline', this.VERSION_1, this.VERSION_2)
      .subscribe(data => {
        this.unparsedDiff = data['diff'];
        this.num_opts_dict = data['num_opts'];
        this.updateNumOptsName()
        if (this.unparsedDiff) {
          this.parseTimelineDiffs();
        }
        else{
          this.isError = true;
        }
        this.isLoading = false;
      }
      );
  }

  public eventSelectAvailable() {
    // console.log("# eventSelectAvailable", this.trigger_events && this.trigger_events.length > 0);
    return this.trigger_events && this.trigger_events.length > 0;
  }

  public timelinePartVisible(index: number) {
    // console.log("# timelinePartVisible. phrase = ", this.phrase);
    if (index == 1) return this.eventSelectAvailable();
    return index <= this.phrase;
  }

  public isTimelineDiverge() {
    const diffStates = this.TIMELINE.diffStates;
    const st0 = diffStates[0];
    const st1 = diffStates[1];
    if (st0.vals.length != st1.vals.length) {
      console.error("# isTimelineDiverge find different length:", st0, st1);
      return true;
    }
    const stlen = st0.vals.length;
    const std0 = {};
    const std1 = {};
    try {
      for (let i = 0; i < stlen; i++) {
        let key0 = st0.devs[i] + st0.comps[i];
        std0[key0] = st0.vals[i];
        let key1 = st1.devs[i] + st1.comps[i];
        std1[key1] = st1.vals[i];
      }
      for (let k in std0) {
        if (std1[k] != std0[k]) return true;
      }
    }
    catch{
      return true;
    }
    return false;
  }


  public updateInitRadioSuggestions() {
    //should called whenever init state radios change.
    for (let key in this.all_choices) {
      this.all_suggestions[key] = {};
    }
    if (Object.keys(this.all_choices).length != Object.keys(this.all_chosen).length) {
      return; //currently do this.
    }

    for (let chosen_key in this.all_choices) {
      let vals = this.all_choices[chosen_key];
      for (let val of vals) {
        let tmp_chosen = {};  //copy this.all_chosen
        for (let key in this.all_chosen) tmp_chosen[key] = this.all_chosen[key];
        tmp_chosen[chosen_key] = val;
        let startKey = this.updateStartKeyCore(tmp_chosen);
        if (this.timelines_dict_by_start[startKey] && this.timelines_dict_by_start[startKey].length > 0) {
          this.all_suggestions[chosen_key][val] = true;
        }
        else {
          this.all_suggestions[chosen_key][val] = false;
        }
      }
    }

  }

  public updateTriggers($event: EventEmitter<MatSelectChange>) {
    // Called whenever the starting states change, this function
    // updates the list of trigger_events based on the starting states
    this.starting_event = null;
    const key: string = this.updateStartKey();
    if (Object.keys(this.all_choices).length != Object.keys(this.all_chosen).length)
      this.phrase = 0; //change phrase to <initstate selected>
    else
      this.phrase = 1;

    this.updateInitRadioSuggestions(); //update suggestions for init state radios.

    const relevantTimelines = this.timelines_dict_by_start[key];
    const keepingtrack: string[] = [];
    this.trigger_events = [];
    if (relevantTimelines) {
      for (var i = 0; i < relevantTimelines.length; i++) {
        const t = relevantTimelines[i];
        if (keepingtrack.indexOf(t.sharedEvents[0][0].description) == -1) {
          keepingtrack.push(t.sharedEvents[0][0].description);
          this.trigger_events.push(t.sharedEvents[0]);
        }
      }
    }
    else {
      //no trigger events
      console.warn("# updateTriggers: no trigger_events.")
    }
    if (this.urlParams['event-autoselect'] == 'one' && this.trigger_events.length == 1) {
      this.starting_event = this.trigger_events[0][0].description; //if only one event, chose this.
      this.updateDisplay(null);
    }
    // console.log("# updateTriggers Done:", this.trigger_events);
  }

  public updateDisplay($event: EventEmitter<MatSelectChange>) {
    // Called when the triggering event changes, this function
    // updates the timeline based on the starting states and the trigger event
    this.phrase = 3; //change phrase to <action selected.>
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

  public timelineTrigger(timeline: TimelineDiff) {
    return timeline.sharedEvents[0];
  }

  private equivalentEvents(event1: TimelineEvent, event2: TimelineEvent) {
    return event1.description == event2.description;
  }

  private equivalentStates(state1: TimelineState, state2: TimelineState) {
    for (var i: number; i < state1.comps.length; i++) {
      if (state1.comps[i] != state2.comps[i]) {
        return false;
      }
    }
    for (var i: number; i < state1.devs.length; i++) {
      if (state1.devs[i] != state2.devs[i]) {
        return false;
      }
    }
    for (var i: number; i < state1.vals.length; i++) {
      if (state1.vals[i] != state2.vals[i]) {
        return false;
      }
    }
    return true;
  }

  private equivalentTimelines(t1: TimelineDiff, t2: TimelineDiff): boolean {
    if ((t1.sharedEvents.length == t2.sharedEvents.length)
      && (t1.sharedStates.length == t2.sharedStates.length)
      && (t1.diffEvents.length == t2.diffEvents.length)
      && (t1.diffStates.length == t2.diffStates.length)
      && (t1.indices.length == t2.indices.length)
      && (t1.changedIndices.length == t2.changedIndices.length)
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
      for (var i: number = 0; i < t1.indices.length; i++) {
        if (t1.indices[i] != t2.indices[i]) {
          return false;
        }
      }
      for (var i: number = 0; i < t1.indices.length; i++) {
        if (t1.changedIndices[i] != t2.changedIndices[i]) {
          return false;
        }
      }
      for (var i: number = 0; i < t1.indices.length; i++) {
        if (t1.diffIndices[i] != t2.diffIndices[i]) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  public getUnits(dev_str:string):string {
    if (dev_str.includes('Brightness Sensor')) {
      return ' lux';
    }
    if (dev_str.includes('Temperature')) {
      return ' °F';
    }
    return '';
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
      const ch_ind: number[][] = [];

      // all nodes on timeline share 'condition'. after event, beh1/2 occur.
      const event = diff.event; // NOTE: assumes that there is only one shared event
      var conditions = diff.condition;

      // ====================== CORRECT VERSION ======================
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
      // ====================== CORRECT VERSION ======================

      // ====================== ERROR VERSION ======================
      // function condcmp(a:Clause, b:Clause){
      //   const a_name = this.getDevName(a);
      //   const b_name = this.getDevName(b);
      //   if (a_name < b_name) { return -1; }
      //   if (a_name > b_name) { return 1; }
      //   return 0;
      // }
      // conditions.sort(condcmp);
      // ====================== ERROR VERSION ======================

      const beh1 = diff.behavior1;
      const beh2 = diff.behavior2;

      // parse event into format with descriptions (text) and icons
      const eventRep: TimelineEvent = {
        icon: [event.channel.icon],
        description: [event.text],
        devs: [this.getDevName(event)],
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
        beh1Icon.push('');
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
        beh2Icon.push('');
        // beh1Devs is left empty
      }

      const beh1Rep: TimelineEvent = {
        icon: beh1Icon,
        description: beh1Text,
        devs: beh1Devs,
      }
      const beh2Rep: TimelineEvent = {
        icon: beh2Icon,
        description: beh2Text,
        devs: beh2Devs
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
      // console.log(this.all_choices);

      const condDevsVals = unsorted_condDevs.map(function(a, b) {
        return [a, unsorted_condVals[b]].join(' ');
      });
      const condSortKey = condDevsVals.sort();
      const condDevs = unsorted_condDevs.sort(function(a, b){  
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });
      const condIcons = unsorted_condIcons.sort(function(a, b){  
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });
      const condComps = unsorted_condComps.sort(function(a, b){  
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });
      const condVals = unsorted_condVals.sort(function(a, b){  
        return condSortKey.indexOf(a) - condSortKey.indexOf(b);
      });

      const initState: TimelineState = {
        icons: condIcons,
        devs: condDevs,
        comps: condComps,
        vals: condVals
      }
      shared_states.push(initState);

      // Intermediate state: get trigger event (always just one), find the dev state it changes, and change accordingly
      var trigIcons: string[] = condIcons.map(x => x);
      var trigComps: string[] = condComps.map(x => x);
      var trigVals: string[] = condVals.map(x => x);
      var ind = -1;
      if (!this.getDevName(event).startsWith('Location Sensor')) { // this.getDevName(event) != 'Location Sensor: Detect Presence'
        ind = condDevs.indexOf(this.getDevName(event));
      } else {
        for (var i=0; i < condVals.length; i++) {
          var person : string = event.parameterVals[1].value;
          var condVal = condVals[i].toString();
          var cap_match : string = person.split(' ').length==1 ? condVal.split(' ')[0] : condVal.split(' ')[0]+' '+condVal.split(' ')[1];
          if (person==cap_match) {
            ind = i;
            break;
          }
        }
      }
      ch_ind.push([ind]);
      trigIcons.splice(ind, 1, event.channel.icon);
      if (event.parameterVals.length > 1) { // this.getDevName(cond).startsWith('Location Sensor')
        trigComps.splice(ind, 1, '=');
        var in_at : string = event.text.includes('Home') ? 'at' : 'in';
        trigVals.splice(ind, 1, event.text.replace('Enters', 'is '+in_at).replace('Exits', 'is not '+in_at));
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
        var beh1_chgs : number[] = [];
        for (var b of beh1) {
          beh1Icons = trigIcons.map(x => x);
          beh1Comps = trigComps.map(x => x);
          beh1Vals = trigVals.map(x => x);
          var ind1 = -1;
          if (!this.getDevName(b).startsWith('Location Sensor')) {
            ind1 = condDevs.indexOf(this.getDevName(b));
          } else {
            for (var i=0; i < beh1Vals.length; i++) {
              var person : string = b.parameterVals[1].value;
              var cap_match : string = person.split(' ').length==1 ? beh1Vals[i].split(' ')[0] : beh1Vals[i].split(' ')[0]+' '+beh1Vals[i].split(' ')[1];
              if (person==cap_match) {
                ind1 = i;
                break;
              }
            }
          }
          beh1_chgs.push(ind1);
          beh1Icons.splice(ind1, 1, b.channel.icon);
          if (b.parameterVals.length > 1) { // this.getDevName(b).startsWith('Location Sensor')
            beh1Comps.splice(ind1, 1, '=');
            var in_at : string = b.text.includes('Home') ? 'at' : 'in';
            beh1Vals.splice(ind1, 1, b.text.replace('Enters', 'is '+in_at).replace('Exits', 'is not '+in_at));
          } else {
            if (this.getDevName(b) == 'Security Camera: Record') {
              beh1Vals.splice(ind1, 1, b.parameterVals[0].value == 'On' ? 'Recording' : 'Not recording');
            } else {
              beh1Vals.splice(ind1, 1, b.parameterVals[0].value);
            }
            beh1Comps.splice(ind1, 1, b.parameterVals[0].comparator);           
          }
        }
        ch_ind.push(beh1_chgs);
      } else {
        beh1Icons = trigIcons;
        beh1Comps = trigComps;
        beh1Vals = trigVals;
        ch_ind.push([-1]);
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
        var beh2_chgs : number[] = [];
        beh2Icons = trigIcons.map(x => x);
        beh2Comps = trigComps.map(x => x);
        beh2Vals = trigVals.map(x => x);
        for (var b of beh2) {
          var ind2 = -1;
          if (!this.getDevName(b).startsWith('Location Sensor')) {
            ind2 = condDevs.indexOf(this.getDevName(b));
          } else {
            for (var i=0; i < beh2Vals.length; i++) {
              var person : string = b.parameterVals[1].value;
              var cap_match : string = person.split(' ').length==1 ? beh2Vals[i].split(' ')[0] : beh2Vals[i].split(' ')[0]+' '+beh2Vals[i].split(' ')[1];
              if (person==cap_match) {
                ind2 = i;
                break;
              }
            }
          }
          beh2_chgs.push(ind2);
          beh2Icons.splice(ind2, 1, b.channel.icon);
          if (b.parameterVals.length > 1) { // this.getDevName(b).startsWith('Location Sensor')
            beh2Comps.splice(ind2, 1, '=');
            var in_at : string = b.text.includes('Home') ? 'at' : 'in';
            beh2Vals.splice(ind2, 1, b.text.replace('Enters', 'is '+in_at).replace('Exits', 'is not '+in_at));
          } else {
            if (this.getDevName(b) == 'Security Camera: Record') {
              beh2Vals.splice(ind2, 1, b.parameterVals[0].value == 'On' ? 'Recording' : 'Not recording');
            } else {
              beh2Vals.splice(ind2, 1, b.parameterVals[0].value);
            }            
            beh2Comps.splice(ind2, 1, b.parameterVals[0].comparator);
          }
        }
        ch_ind.push(beh2_chgs);
      } else {
        beh2Icons = trigIcons;
        beh2Comps = trigComps;
        beh2Vals = trigVals;
        ch_ind.push([-1]);
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

      const timeline: TimelineDiff = {
        sharedEvents: shared_events,
        sharedStates: shared_states,
        diffEvents: diff_events,
        diffStates: diff_states,
        indices: [...Array(shared_states.length + shared_events.length + (diff_states.length + diff_events.length) / 2 - 1).keys()],
        changedIndices: ch_ind,
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
    }));
    this.TIMELINE = this.TIMELINES[0];
    this.TIMELINE_KEYS_ORIGINAL = Object.keys(this.timelines_dict);
    // ----------- code below have bug ------------
    // const justtracking : string[] = [];
    // this.trigger_events = [];
    // for (var i = 0; i < trigger_events_lst.length; i++) {
    //   if (justtracking.indexOf(trigger_events_lst[i].description)==-1) {
    //     this.trigger_events.push(trigger_events_lst[i]);
    //     justtracking.push(trigger_events_lst[i].description);
    //   }
    // }
    // console.log("# update trigger_events in parse:", this.trigger_events);
    // ------------ code above have bug ------------

    if (this.urlParams["skip-init"] != "true") {
      // populate the original setting
      for (var i = 0; i < this.TIMELINE.sharedStates[0].devs.length; i++) {
        var key: string = this.TIMELINE.sharedStates[0].devs[i] + ' ' + this.TIMELINE.sharedStates[0].comps[i];
        this.all_chosen[key] = this.TIMELINE.sharedStates[0].vals[i];
      }
      // this.starting_event = this.TIMELINE.sharedEvents[0].description; cancelled.

      this.updateTriggers(null);
    }
    else {
      console.log("# init skipped.");
    }

  }

  public getStartChoices(j: number) {
    var key: string = this.TIMELINE.sharedStates[0].devs[j] + ' ' + this.TIMELINE.sharedStates[0].comps[j];
    // console.log(key)
    var choices = [...this.all_choices[key]];
    var finalChoices: string[] = choices.sort((n1, n2) => {
      if (['Open', 'Unlocked', 'On', 'Recording'].indexOf(n1) != -1) {
        return -1;
      }

      if (n1 == n2) {
        return 0;
      }

      return 1;
    });
    return finalChoices;
  }

  public eventIndex(i: number) {
    return Math.floor(i / 2);
  }

  public stateIndex(i: number) {
    return i / 2;
  }

  public flowDevChanged(i: number, j:number){
    for(let k = i; k > 1; k-=2) if(this.devChanged(k, j)) return true;
    if(this.devChanged(1, j)) return true;
    return false;
  }

  public devChanged(i: number, j: number) {
    return this.TIMELINE.changedIndices[i].includes(j);
  }

  public devDiff(j: number) {
    return this.TIMELINE.diffIndices.indexOf(j) >= 0;
  }

  public saveProgram() {
    alert('saving ' + this.DESIREDPROGRAM);
  }

  public openHelp() {
    let dialogRef = this.dialog.open(HelpInfoDialogCommonComponent, {
      data: { preset: "tdiff" }
    });
  }

  private updateNumOptsName() {
    let new_num_opts_dict = {};
    for (let key in this.num_opts_dict) {
      let new_key = key.split('/').join(' ');
      new_num_opts_dict[new_key] = this.num_opts_dict[key];
    }
    this.num_opts_dict = new_num_opts_dict;
  }

  public updateFocus(event: any, index: number) {
    this.FOCUSINDEX = event.value - 1; // event.value is index 1, but we want index 0 for easier computation
  }

  public focusState(index: number): boolean {
    // Given an index of a card, determine whether it should be focused
    // based on whether the slider value (this.FOCUSINDEX) is equal or the one before

    return (index == this.FOCUSINDEX) || ((index - 1) == this.FOCUSINDEX);
  }
}
