import { Component, OnInit, EventEmitter, ElementRef } from '@angular/core';
import { TimelineEvent, TimelineState } from '../tdiffbase/tdiffbase.component';
import { MatDialog } from '@angular/material/dialog';
import { UserDataService, Clause } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { MatSelectChange } from '@angular/material/select';
import { MatListOption } from '@angular/material/list';

import { Rule } from '../../user-data.service';
import { HelpInfoDialogCommonComponent } from '../../help-info-dialog/help-info-dialog-common/help-info-dialog-common.component';
import { DiffcomService } from '../../diffcom.service';

import * as introJs from 'intro.js/intro.js';

export interface TimelineEventVers {
  icon: string[];
  description: string[];
  vers: number[];
}

export interface TimelineDiff {
  sharedEvents: TimelineEvent[]; // this only has 1 elt and will also double as the TimelineDiff's id
  sharedStates: TimelineState[]; // sharedStates[0] = event in qdiff
  diffEvents: TimelineEvent[]; // 1st being the 1st program's and vv
  diffStates: TimelineState[]; // diffStates = choices in qdiff, 1st being the 1st program's and vv
  choices: TimelineEventVers[]; // what user can choose from, an array of vers (which is a number[]) from TimelineEventVers
  answer: number[]; // what user actually chose (can be multiple because of checkbox)
}

export interface TimelineFilter {
  all_icons: string[];
  devs: string[];
  all_devs: string[];
}

export interface unparsedQuestion {
  event: Clause;
  condition: Clause[];
  behaviors: any[];
  vers: any[];
}

@Component({
  selector: 'app-tdiff6',
  templateUrl: './tdiff6.component.html',
  styleUrls: ['./tdiff6.component.css']
})
export class Tdiff6Component implements OnInit {
  //current selection
  public TIMELINE_KEY: string = "";
  public showAllDevicesClicked = false;

  public TIMELINE_KEYS_FILTERED: string[] = [];
  public TIMELINE_KEYS_FILTERED_CONDENSED: string[] = []; // init in condenseTimelineKeysFiltered()
  public TIMELINE_DEVICE_MASK_BY_CONDENSED_KEYS: { [id: string]: { [id: string]: boolean } } = {};
  public SHOW_ALL_DEVS_PER_TIMELINE: boolean[] = []; // -1 = unclicked, 0 = false, 1 = true

  //all cache for analysis or UI  (only changed when parsing backend data.)
  public TIMELINE_KEYS_BY_DEVICE: { [id: string]: string[] } = {};
  public TIMELINE_KEYS_BY_EVENT: { [id: string]: string[] } = {};
  public TIMELINE_KEYS_BY_INITSTATE_BY_DEVICE__KEYS: string[] = [];

  // private unparsedDiff: UnparsedTimelineDiff[];
  public phrase: number = 0;
  public isLoading: boolean = false;
  public isError: boolean = false;

  // qdiff
  private unparsedQuestions: unparsedQuestion[];
  public CURRENTQNUM: number;
  public TOGGLES: boolean[] = [];
  public PROGRAMCHOICECOUNTS: { [id: number]: number } = {};
  public PROGRAMCHOICERESULTS: { [id: number]: number[] } = {};
  public IDEALPRGMS = [];
  public OTHERPRGMS = [];

  // for filter
  public ALL_DEVS: TimelineFilter;
  public ALL_TIMELINES: TimelineDiff[];

  private INTRO_DONE: number = 0;
  private FIRST_ANSWERED: boolean = false;
  private SECOND_ANSWERED: boolean = false;
  private INTERVAL: number = 5;

  public urlParams = {
    "tutorial": "false",
    
    // NOTE: To see the experimental error that affected Task 6 (but no other tasks) in the study, as mentioned in the CHI '21 paper,
    // add the URL param "showError=true", i.e. localhost/user/12/mcdiff?save-style=selectfromtwo&showError=true
    'showError': 'false',
  };

  public tutorialParams = {
    'showPrgmButton': 'false',
    'showSavePanel': 'false'
  }

  public TIMELINES: TimelineDiff[];
  // Need to init this as placeholder, else html loads before the parse fn
  // and it results in a bunch of "TypeError: TIMELINE is undefined"
  // even if the content loads just a sec later
  // NOTE: no it doesn't help
  public TIMELINE: TimelineDiff = {
    sharedEvents: [],
    sharedStates: [],
    diffEvents: [],
    diffStates: [],
    choices: [],
    answer: [],
  };

  public TIMELINE_KEYS_ORIGINAL: string[] = [];

  private all_suggestions: { [id: string]: { [id: string]: boolean; } } = {};
  private all_choices: { [id: string]: Set<string>; } = {}; // key = cond.device.name + ' ' + cond.parameterVals[0].comparator;
  private all_chosen: { [id: string]: string; } = {}; // like all_devs, but with actual choice as value
  public trigger_events: TimelineEvent[] = []; // list of available trigger events
  private starting_event: string = ''; // the one we start with

  public VERSION_1: number = 0;
  public VERSION_2: number = 1;
  public PROGRAMNUMS: number[];
  public PROGRAMS: { [id: number]: Rule[]; };
  public PRGMNUMSDEFINED: boolean = false;

  // Keeping track of timelines based on their start states (and maybe trigger events)
  public TIMELINES_DICT: { [id: string]: TimelineDiff; } = {}; // key = list of states + event
  public TIMELINES_DICT_BY_START: { [id: string]: TimelineDiff[]; } = {}; // key = list of states

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
              //set unparsed rules by version id in PROGRAMS.
              for (let progNum of this.PROGRAMNUMS) this.PROGRAMS[progNum] = data["programs"][progNum]["rules"];
              this.prgmNumsDefined();
              if (this.urlParams['tutorial'] == 'true') {
                setInterval(() => this.startIntroJS(), this.INTERVAL);
              }

              this.isLoading = true;
              this.isError = false;

              this.userDataService.compareAllVersions(this.userDataService.hashed_id, this.PROGRAMNUMS)
                .subscribe(data => {
                  this.isLoading = false;
                  this.unparsedQuestions = data['diff'];

                  if (this.unparsedQuestions) {
                    this.parseQuestions();
                    this.updateTimelineNew();
                    this.CURRENTQNUM = 0;
                    this.TOGGLES = this.PROGRAMNUMS.map((
                      // index = ver id, elt = tally >.< (this tally also includes the original program)
                      ver_id => { return false; }
                    ));
                  }
                  else {
                    this.isError = true;
                  }
                }
                );
            }
          })
      })
    });
  }

  public dropdownValue(i: number): String {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams);
  }

  public getShortProgramName(i: number): string {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams).split("(")[0];
  }

  private getDevName(c: Clause) {
    if (c.device.name == 'Location Sensor') {
      // this is technically a backend problem but since i'm a bad coder...
      // add the person's name to the end of both dev name and cap name
      return c.device.name + ' ' + c.parameterVals[1].value + ': ' + c.capability.name.split('/').join(' ') + ' ' + c.parameterVals[1].value;
    }
    return c.device.name + ': ' + c.capability.name.split('/').join(' ');
  }

  public eventSelectAvailable() {
    return this.trigger_events && this.trigger_events.length > 0;
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
        if (this.TIMELINES_DICT_BY_START[startKey] && this.TIMELINES_DICT_BY_START[startKey].length > 0) {
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
    const relevantTimelines = this.TIMELINES_DICT_BY_START[key];
    const keepingtrack: string[] = [];
    this.trigger_events = [];
    if (relevantTimelines) {
      for (var i = 0; i < relevantTimelines.length; i++) {
        const t = relevantTimelines[i];
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
    this.phrase = 3; //change phrase to <action selected.>
    const key: string = this.updateTriggerKey();
    this.TIMELINE = this.TIMELINES_DICT[key];
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
      // if (i < keys.length-1) {
      strs.push('&');
      // }
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
      && (t1.diffStates.length == t2.diffStates.length)) {
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

  private equivalentClauses(a: Clause, b: Clause): boolean {
    const a_name = this.getDevName(a);
    const b_name = this.getDevName(b);
    return (a_name == b_name) && (a.parameterVals[0].value == b.parameterVals[0].value)
      && (a.parameterVals[0].comparator == b.parameterVals[0].comparator)
  }

  public parseQuestions() {
    const questions = this.unparsedQuestions;
    const trigger_events_lst: TimelineEvent[] = [];

    this.TIMELINES_DICT = {};
    this.TIMELINES_DICT_BY_START = {};
    this.TIMELINE = null;
    this.TIMELINES = [];
    this.TIMELINE_KEYS_ORIGINAL = [];

    if (this.unparsedQuestions.length == 0) {
      return;
    }

    this.TIMELINES = questions.map((diff => {
      const shared_events: TimelineEvent[] = [];
      const shared_states: TimelineState[] = [];
      const diff_events: TimelineEvent[] = [];
      const diff_states: TimelineState[] = [];

      // all nodes on timeline share 'condition'. After event, behs lead to the outcomes
      const event = diff.event; // NOTE: assumes that there is only one shared event
      var conditions = diff.condition;
      const beh_list = diff.behaviors;

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

      // parse event into format with descriptions (text) and icons
      var eventRep: TimelineEvent = {
        icon: [event.channel.icon],
        description: [event.text],
        devs: [this.getDevName(event)]
      }

      // Figure out what to show as the behaviors. 
      // If a behavior has two actions but they're the same action, then only show one.
      // NOTE: this code just converts blank behs to "do nothing"
      var behTexts: any[] = [];
      var behIcons: any[] = [];
      for (let beh of beh_list) {
        var behText = [];
        var behIcon = [];
        if (beh && beh.length) {
          for (var b of beh) {
            // if (!beh1Text.includes(b.text)) { // from tdiff
            behText.push(b.text);
            behIcon.push(b.channel.icon);
            //behDevs.push(this.getDeviceName(b.dev));
          }
        } else { // blank beh = the prgm does nothing here
          behText.push('Do nothing');
          behIcon.push('block');
        }
        behTexts.push(behText);
        behIcons.push(behIcon);
        // behDevs
      }
      // TODO: either -- push behs and None (if do nothing) into a new list for new_beh_list,
      // or use beh_list for new_beh_list

      // questionChoices before filtering
      var behReps: TimelineEventVers[] = []; // behReps in qdiff
      for (let ii in behTexts) {
        var behRep: TimelineEventVers = {
          icon: behIcons[ii],
          description: behTexts[ii],
          vers: diff.vers[ii]
        }
        behReps.push(behRep);
      }

      var choicesRep: TimelineEventVers[] = behReps;

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

        // if the event doesn't change the init state, make it null (and cut out the question later)
        if (this.equivalentClauses(event, cond)) {
          eventRep = null; // will get filtered out so don't add to all_choices?
        } else {
          // if needed, move out of this else scope
          var key = this.getDevName(cond) + ' ' + cond.parameterVals[0].comparator;
          if (!this.all_choices[key]) {
            this.all_choices[key] = new Set<string>();
          }
          this.all_choices[key].add(cond.parameterVals[0].value);
        }

        // this part will be confusing... it creates a new_beh_list 
        // that's like beh_list (w/ objs for dev/comp/val info), but 
        // add null behs (in replacement of the blank ones in beh_list) 
        // and skip over choices that are redundant with intermediate state
        var new_beh_list = [];
        // for (let beh of beh_list) {
        //   new_beh_list.push(beh);
        // }
        for (let beh of beh_list) {
          if (beh && beh.length) {
            if (beh.length == 1) {
              // NOTE: cond & event should NEVER be identical at this point

              // this is to get the latest dev state, which is either the initial cond (if not affected by event) or the event itself
              var candidate: Clause = this.getDevName(cond) == this.getDevName(event) ? event : cond;

              // if a choice isn't dif from the intermediate state (candidate) then delete it
              if (this.equivalentClauses(beh[0], candidate)) {
                // this line first gets the form that each choice text would end up looking like
                // (specifically, the condensation of simultaneous actions w/o redundancies among them (e.g. x & y),
                // and then filters out the choice text that looks like this one (because it's redundant with intermediate state)
                choicesRep = choicesRep.filter(obj => obj.description.join(' & ') != beh.map(b => b.text));
              } else {
                new_beh_list.push(beh);
              }
            } else {
              alert('0 or multiple behaviors?');
            }
          } else {
            new_beh_list.push(null);
          }
        }

      }

      shared_events.push(eventRep);
      trigger_events_lst.push(eventRep);

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

      for (let c in choicesRep) {
        // for each choice (behavior), find out what the outcome would look like
        let beh = new_beh_list[c];

        var finalBehIcons: string[], finalBehComps: string[], finalBehVals: string[];
        if (beh && beh.length) {
          for (var b of beh) {
            finalBehIcons = trigIcons.map(x => x);
            finalBehComps = trigComps.map(x => x);
            finalBehVals = trigVals.map(x => x);
            var ind1 = -1;
            if (!this.getDevName(b).startsWith('Location Sensor')) {
              ind1 = condDevs.indexOf(this.getDevName(b));
            } else {
              for (var i = 0; i < finalBehVals.length; i++) {
                var person: string = b.parameterVals[1].value;
                var cap_match: string = person.split(' ').length == 1 ? finalBehVals[i].split(' ')[0] : finalBehVals[i].split(' ')[0] + ' ' + finalBehVals[i].split(' ')[1];
                if (person == cap_match) {
                  ind1 = i;
                  break;
                }
              }
            }
            // This should be okay: for pair tdiffs, it's only pushed 2x (and after intermediate shared by both)
            // while here, after the intermediate shared by both, it's pushed as many times as there are choices
            finalBehIcons.splice(ind1, 1, b.channel.icon);
            if (b.parameterVals.length > 1) { // this.getDevName(b).startsWith('Location Sensor')
              finalBehComps.splice(ind1, 1, '=');
              var in_at: string = b.text.includes('Home') ? 'at' : 'in';
              finalBehVals.splice(ind1, 1, b.text.replace('Enters', 'is ' + in_at).replace('Exits', 'is not ' + in_at));
            } else {
              if (this.getDevName(b) == 'Security Camera: Record') {
                finalBehVals.splice(ind1, 1, b.parameterVals[0].value == 'On' ? 'Recording' : 'Not recording');
              } else {
                finalBehVals.splice(ind1, 1, b.parameterVals[0].value);
              }
              finalBehComps.splice(ind1, 1, b.parameterVals[0].comparator);
            }
          }
        } else {
          finalBehIcons = trigIcons;
          finalBehComps = trigComps;
          finalBehVals = trigVals;
        }

        // Final states: get event, find the dev state it changes, and change accordingly
        const finalBehState: TimelineState = {
          icons: finalBehIcons,
          devs: condDevs,
          comps: finalBehComps,
          vals: finalBehVals
        }
        diff_states.push(finalBehState);
      }

      const timeline: TimelineDiff = {
        sharedEvents: shared_events,
        sharedStates: shared_states,
        diffEvents: diff_events,
        diffStates: diff_states,
        choices: choicesRep,
        answer: [],
      }

      const triggerKey = this.genTriggerKeyForTimeline(timeline);
      if (this.TIMELINES_DICT[triggerKey]) {
        // there is already a timeline here -- if it's different from
        // the one we're about to add, then it's a problem
        if (!this.equivalentTimelines(this.TIMELINES_DICT[triggerKey], timeline)) {
          console.error('two conflicting timelines with the same init state and event');
          console.error('current timeline' + JSON.stringify(timeline));
          console.error('existing timeline' + JSON.stringify(this.TIMELINES_DICT[triggerKey]));
        }
      }
      this.TIMELINES_DICT[triggerKey] = timeline;

      const startKey = this.genStartKeyForTimeline(timeline);
      if (!this.TIMELINES_DICT_BY_START[startKey]) {
        this.TIMELINES_DICT_BY_START[startKey] = [];
      }
      this.TIMELINES_DICT_BY_START[startKey].push(timeline);
      return timeline;
    }));
    this.ALL_DEVS = {
      all_icons: this.TIMELINES[0].sharedStates[0].icons,
      devs: [],
      all_devs: this.TIMELINES[0].sharedStates[0].devs,
    }
    this.ALL_TIMELINES = this.TIMELINES;
    this.TIMELINES = this.TIMELINES.filter((x): x is TimelineDiff => x !== null);
    this.TIMELINES = this.TIMELINES.filter(function (q) {
      // if q has the trigger event that overlaps with a starting dev state, 
      // or only one possible choice at most, then delete the question
      if (q.sharedEvents[0] == null || q.diffStates.length <= 1) {
        return false;
      }
      return true;
    });

    if (this.urlParams['showError'] == 'true') {
      this.TIMELINES = this.questionCompressor(this.TIMELINES);
    }

    if (this.TIMELINES.length > 0) {
      this.TIMELINE = this.TIMELINES[0];
      this.TIMELINE_KEYS_ORIGINAL = Object.keys(this.TIMELINES_DICT);

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

  public questionFilter(): TimelineDiff[] {
    // let's try this: for each regKey, count the number of
    // assumptions: if neither the event nor the result dif involves the chosen devs then it's not a relevant situation;
    // if two situations have the same event + vers, then an irrelevant dev is dif between the situations (assume binary?)
    let registerBoard: { [id: string]: boolean } = {};
    let compressedQs: TimelineDiff[] = [];
    for (let q of this.ALL_TIMELINES) {
      alert('loop');
      let regKey = q.sharedEvents[0].description.join(',');
      for (let ch of q.choices) regKey += " | " + String(ch.vers);
      //regKey stands for unique event+choice ver
      // if (registerBoard[regKey]) {
      // assumes that sharedEvents is one elt which has one dev, and that no two devs have dif caps...
      var eventChosen = false;
      var diffChosen = false;
      for (let i of this.ALL_DEVS.devs) {
        let chosenDev = this.ALL_DEVS.all_devs[i];
        if (chosenDev == q.sharedEvents[0].devs[0]) { // event has chosen dev
          eventChosen = true;
          break; // no need to check for dif in end states
        }

        for (let diffEvent of q.diffEvents) {
          if (diffEvent.devs.includes(chosenDev)) {
            diffChosen = true;
            break;
          }
          if (diffChosen) {
            break;
          }
        }
      }

      if (eventChosen || diffChosen) {
        // }
        compressedQs.push(q);
        // registerBoard[regKey] = true;
      }
    }
    return compressedQs;
  }

  public questionCompressor(qs: TimelineDiff[]): TimelineDiff[] {
    let registerBoard: { [id: string]: boolean } = {};
    let compressedQs: TimelineDiff[] = [];
    for (let q of qs) {
      let regKey = q.sharedEvents[0].description.join(',');
      for (let ch of q.choices) regKey += " | " + String(ch.vers);
      console.log("# questionCompressor regKey: ", regKey);
      //regKey stands for unique event+choicever
      if (registerBoard[regKey]) continue;
      compressedQs.push(q);
      registerBoard[regKey] = true;
    }
    return compressedQs;
  }

  private getResults() {
    if (!this.allQuestionsAnswered()) {
      return;
    }
    // tally answers for all questions
    var tally: number[] = this.PROGRAMNUMS.map((
      // index = ver id, elt = tally >.< (this tally also includes the original program)
      ver_id => { return 0; }
    ));
    // what were the actual questions that matched each answer
    var results: number[][] = this.PROGRAMNUMS.map((
      // index = ver id, elt = the questions that this prgm satisfy
      ver_id => { return []; }
    ));

    // for each question, look at its answer
    // if answer == -1, then continue (because user said that none of the options work)
    // else, record all the answer vers
    for (var q: number = 0; q < this.TIMELINES.length; q++) {
      var question: TimelineDiff = this.TIMELINES[q];
      if (question.answer.length == 0 && this.TOGGLES[q]) {
        // if this.TOGGLES[q]==true, then user explicitly answered "none are acceptable"
        continue;
      }

      var chosen_vers: number[] = [];
      for (let cc of question.answer) { // this includes if the user selected all options
        chosen_vers = chosen_vers.concat(question.choices[cc].vers);
      }
      for (var i: number = 0; i < chosen_vers.length; i++) {
        var ver = chosen_vers[i];
        tally[this.PROGRAMNUMS.indexOf(ver)]++;
        // update prgm ver with this q, but only if it wasn't already included
        // (in case there are any prgms that do multiple actions in the same scenario)
        if (!(results[this.PROGRAMNUMS.indexOf(ver)].includes(q + 1))) {
          results[this.PROGRAMNUMS.indexOf(ver)].push(q + 1);
        }
      }
    }
    // update (replace) total tally for all questions
    this.PROGRAMCHOICECOUNTS = {};
    this.PROGRAMCHOICERESULTS = {};
    for (let i = 0; i < this.PROGRAMNUMS.length; i++) {
      this.PROGRAMCHOICECOUNTS[this.PROGRAMNUMS[i]] = tally[i];
      this.PROGRAMCHOICERESULTS[this.PROGRAMNUMS[i]] = results[i];
    }

    [this.IDEALPRGMS, this.OTHERPRGMS] = this.dividePrgms();
  }

  public noPrgmsWork() {
    return this.IDEALPRGMS.length == 0 && this.OTHERPRGMS.length != 0 && this.getTally(this.OTHERPRGMS[0][0]) == 0;
  }

  public getResultToggle(qn: number) {
    // update the answer to current question
    if (this.TOGGLES[qn]) {// true = none of the outcomes are acceptable
      this.TIMELINES[qn].answer = [];
    }
    this.getResults();
  }

  public getResultCheckbox(qn: number, options: MatListOption[]) {
    // update the answer to current question
    if (this.TIMELINES[qn].answer.length != 0) {
      this.TOGGLES[qn] = false;
    }
    this.getResults();
  }

  public filterSituations() {
    this.TIMELINES = this.questionFilter();
    alert(JSON.stringify(this.ALL_DEVS));
    alert(this.TIMELINES.length);
  }

  public checkAnswer(qn: number) {
    // for the tutorial
    if (qn == 0) {
      if (this.TOGGLES[qn]) {
        alert('Incorrect. Please refer to the part of the task instructions where it says "When the heater turns on...", and try again.')
      } else if (this.TIMELINES[qn].answer.length == 1 && this.TIMELINES[qn].answer[0] == 1) {
        alert('Incorrect. Please refer to the part of the task instructions where it says "When the heater turns on...", and try again.')
      } else if (this.TIMELINES[qn].answer.length == 2) {
        alert('Incorrect. Please refer to the part of the task instructions where it says "When the heater turns on...", and try again.')
      } else if (this.TIMELINES[qn].answer.length == 1 && this.TIMELINES[qn].answer[0] == 0) {
        this.FIRST_ANSWERED = true;
      }
    }
    if (qn == 1) {
      if (this.TOGGLES[qn]) {
        alert('Incorrect. Please refer to the part of the task instructions where it says "In all other situations...", and try again.')
      } else if (this.TIMELINES[qn].answer.length == 1) {
        alert('Incorrect. Please refer to the part of the task instructions where it says "In all other situations...", and try again.')
      } else if (this.TIMELINES[qn].answer.length == 2) {
        this.SECOND_ANSWERED = true;
      }
    }
  }

  public allQuestionsAnswered() {
    if (!this.TIMELINES) {
      return false;
    }
    var allSelected: boolean = true;
    for (var q: number = 0; q < this.TIMELINES.length; q++) {
      var question: TimelineDiff = this.TIMELINES[q];
      if (question.answer.length == 0 && !this.TOGGLES[q]) {
        allSelected = false;
        break;
      }
    }
    return allSelected;
  }

  public getProgramNameForTally(i: number): string {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams);
  }

  public getTally(prgm: any) {
    return this.PROGRAMCHOICECOUNTS[prgm];
  }

  public getPercentage(pnum: number) {
    if (this.TIMELINES.length == 0) {
      return String(100);
    }
    return Math.round((this.PROGRAMCHOICECOUNTS[pnum] / this.TIMELINES.length) * 100).toString();
  }

  public sortedTally() {
    var prgm_choice_counts = [];
    for (var key in this.PROGRAMCHOICECOUNTS) {
      prgm_choice_counts.push([key, this.PROGRAMCHOICECOUNTS[key]]);
    }

    var tally = prgm_choice_counts.sort(function (first, second) {
      return second[1] - first[1];
    });
    return tally;
  }

  public dividePrgms() {
    var ideal_prgms = [];
    var other_prgms = [];
    var all_tally_prgms = this.sortedTally();
    for (let t of all_tally_prgms) {
      if (this.getPercentage(t[0]) == '100') {
        ideal_prgms.push(t);
      } else {
        other_prgms.push(t);
      }
    }
    return [ideal_prgms, other_prgms];
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


  public getDeviceIndexByCurrentMask(devs: string[], ti: number) {
    // the indices that should be shown (not hidden)
    let idxs = [];
    for (let i = 0; i < devs.length; i++) {
      if (this.getCurrentMask(devs[i], ti)) idxs.push(i);
    }
    return idxs;
  }

  public devInds(ti: number) {
    return [...Array(this.getDeviceIndexByCurrentMask(this.TIMELINES[ti].sharedStates[0].devs, ti).length).keys()];
  }

  public devKeyIter(ti: number) {
    return [...Array(this.TIMELINES[ti].choices.length - 1).keys()];
  }

  public showShowAllDevicesCheckbox(t: TimelineDiff, ti: number): boolean {
    // if it was already clicked, then always show:
    if (this.SHOW_ALL_DEVS_PER_TIMELINE[ti]) {
      return true;
    } else {
      // only show the checkbox for "show all devices" if there are any devices not being shown
      // i.e. num devs shown != total num devs
      return this.getDeviceIndexByCurrentMask(t.sharedStates[0].devs, ti).length != t.sharedStates[0].devs.length;
    }
  }

  public getCurrentMask(dev: string, ti: number): boolean { // currently this fn just needs to decide whether there is mask, not what the mask is
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

  public trimDevNameInFilter(dev: string): string[] {
    let device_name = dev.split(': ')[0];
    let cap_name = dev.split(': ')[1];
    if (!cap_name) { cap_name = ''; }
    let cap_name_s = '';

    var dev_name = device_name == 'Thermostat' ? 'AC' : device_name;
    if (cap_name_s != '') {
      if (cap_name_s == 'Curtains') {
        dev_name = device_name + ' ' + cap_name_s;
      } else {
        dev_name = device_name + ' (' + cap_name_s + ')';
      }
    }
    if (cap_name == '') { return [dev_name, '']; }
    if (dev_name == 'AC') { return [dev_name, ' (Power On/Off)']; }
    return [dev_name, ' (' + cap_name.replace('Open Close', 'Open/Close').replace('On Off', 'On/Off').replace('Lock Unlock', 'Lock/Unlock') + ')'];
  }

  private condenseTimelineKeysFiltered() {
    var transFkeys = [];
    for (let fkey of this.TIMELINE_KEYS_FILTERED) transFkeys.push(fkey);

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
            let tlinei = this.TIMELINES_DICT[fkeyi];
            let tlinej = this.TIMELINES_DICT[fkeyj];
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
    let normalTimeline = this.TIMELINES_DICT[normalKey];
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
    this.TIMELINES_DICT[condensedKey] = condensedTimeline;

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
    let resultSet = DiffcomService.deepCopy(this.TIMELINE_KEYS_ORIGINAL);
    this.TIMELINE_KEYS_FILTERED = resultSet;
    this.condenseTimelineKeysFiltered();

    if (!this.TIMELINE_KEYS_FILTERED_CONDENSED.length) {
      this.TIMELINE = null;
      return;
    }
    this.TIMELINE_KEY = this.TIMELINE_KEYS_FILTERED_CONDENSED[0];

    if (this.TIMELINE_KEY.length == 0) {
      console.error("# updateTimeline. TIMELINE_KEY is invalid.");
      alert("error");
      return;
    }
    this.phrase = 3;
    //should check or something?
    this.TIMELINE = this.TIMELINES_DICT[this.TIMELINE_KEY];
    this.userDataService.appendLog("updateTimeline | " + this.TIMELINE_KEY);
  }

  public stateIsDif(thisTIMELINE: TimelineDiff, j: number): Boolean {
    // if this returns false, use flowchart-cap-gray
    // else, use flowchart-cap-dif

    let compsSet = new Set();
    let valsSet = new Set();
    for (let diffState of thisTIMELINE.diffStates) {
      compsSet.add(diffState.comps[j]);
      valsSet.add(diffState.vals[j]);
    }
    var res = compsSet.size == 1 && valsSet.size == 1;
    return !res
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
    return this.showVal(timeline.diffStates[prgmInd].comps[devInd], timeline.diffStates[prgmInd].vals[devInd], false, timeline.diffStates[prgmInd].devs[devInd]);
  }

  public iterSubsequentBranches(t: TimelineDiff) {
    return [...Array(t.diffStates.length - 1).keys()];
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
      return this.FIRST_ANSWERED;
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
              // element: '#rightdropdown',
              intro: "To complete this task, you need to determine which of the 4 programs, if any, would do what the instructions say to do.<br><br><span style='font-weight:bold'>This interface does not show the programs, but instead give you information about them.</span>"
            },
            {
              intro: "Specifically, <span style='color:rgb(0, 153, 255); font-weight:bold'>it shows all of the situations in which the programs offer different outcomes.<br><br>For each situation, you will select the acceptable outcomes.<br><br>At the end, the interface will show how well each program match the selected outcomes.</span>"
            },
            {
              element: '#instr',
              intro: "This is the instructions for the interface, which you can refer to later. We will also go over the interface now."
            },
            {
              element: document.querySelectorAll('.situation-label')[0],
              intro: "<span style='font-weight:bold'>The interface shows a flowchart for each situation in which the programs behave differently.</span><br><br>This is the first situation.",
              //  (out of 2 total) on this page. We will explain more precisely what a <span style='font-weight:bold'>situation</span> is and why there are <span style='font-weight:bold'>2 situations</span> on this page.
              position:'bottom'
            },
            {
              intro:"Recall that rules look like this:<br>* \"<span style='font-weight:bold'>If</span> [an event happens] <span style='font-weight:bold'>while</span> [a state is true] <span style='font-weight:bold'>then</span> [have the smart home do something].\"<br><br><span style='font-weight:bold'>Having lots of rules can make it hard to know exactly what they will do in a situation, especially if you have many programs to choose from.<br><br>So, <span style='color:rgb(0, 153, 255)'>this interface:<br>1) Figures out what the programs would do in a situation;<br>2) Shows you all the situations in which the program behaviors are different;<br>3) Asks you what outcomes are acceptable for each of these situations;<br>4) And decide which programs are suitable for you based on your responses.</span></span>"
            },
            {
              element: '.flowchart-situation',
              intro: "In each situation, the flowchart shows:<br><span style='font-weight:bold; color:rgb(0, 153, 255)'>1)</span> The <span style='font-weight:bold'>\"while\"</span> part: <span style='font-weight:bold'>what is true</span> about the smart home or the environment and people that affect it, and<br><span style='font-weight:bold; color:rgb(0, 153, 255)'>2)</span> The <span style='font-weight:bold'>\"if\"</span> part: what <span style='font-weight:bold'>event</span> happens that triggers a program to do something.</span><br><br>For example, Alice coming home (event) when the lights are off during the day (what is already true about the home) is a situation.",
              position: "right"
            },
            {
              element: '.flowchart-outcome',
              intro: "For each situation, you will <span style='font-weight:bold'>select all of the acceptable outcomes that the programs can offer.</span> This tells the interface what a suitable program should do.<br><br>(If an outcome isn't here, it is not offered by any program.)",
              position: "left"
            },
            {
              element: '.flowchart-outcome',
              intro: "Here, some programs turn off the AC and leave the heater on (the first outcome), while others leave the AC on and turn the heater off (the second outcome).",
              position: "left"
            },
            {
              element: '#toggle',
              intro: "<span style='font-weight:bold; color:rgb(0, 153, 255)'>If none of the outcome choices are acceptable, make sure to click on this to indicate so, instead of just unselecting all of the checkboxes!</span><br><br>Otherwise, the interface can't tell if you simply forgot to make a choice here.",
              position: "top"
            },
            {
              element: document.querySelectorAll('.flowchart-bar-dev')[0],
              intro: "<span style='font-weight:bold'>Each row shows how some factor</span> (e.g. a device, where someone is, weather) <span style='font-weight:bold'>is affected during this situation.</span> For example, this row shows that, at first, the AC is on.",
            },
            {
              element: document.querySelectorAll('.flowchart-bar-dev')[2],
              intro: "After someone or a rule turns on the heater, the AC turns <span style='font-style:italic'>off</span> in the first outcome but stays <span style='font-style:italic'>on</span> in the second outcome."
            },
            {
              element: document.querySelectorAll('.flowchart-situation')[0],
              intro: "Now let's try to complete the first situation.<br><br>To recap, in this situation, someone (or a rule) turns on the heater when the AC is on.",
              position: "right"
            },
            {
              element: document.querySelectorAll('.flowchart-outcome')[0],
              intro: "The two possible outcomes are:<br>a) having the AC off (leaving the heater on) and<br>b) having the AC on (with the heater off).",
            },
            {
              intro: "<span style='font-weight:bold'>Open the task instructions to see what Alice wants in this situation, and then select the acceptable outcomes for this situation.<br><br>Click on the \"Check my answer!\" button to continue with the tutorial.</span>",
            }
          ]
        });
        introJS2.start();
      }, 300);
    } else if (this.INTRO_DONE == 3 && this.tutorialStageComplete(3)) {
      this.INTRO_DONE++;
      this.FIRST_ANSWERED = false;
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
              element: document.querySelectorAll('.flowchart-big-box')[0],
              intro: 'Good! When the heater turns on, Alice wants the AC to turn off.'
            },
            {
              element: '#instr',
              intro: "<span style='font-weight:bold'>For this task, there are 2 situations in which the programs do different things (offer different outcomes).</span><br><br>Likewise, <span style='color:rgb(0, 153, 255); font-weight:bold'>in situations that are <span style='font-weight:bold'>not</span> on this page, the programs will <span style='font-weight:bold'>do the same things (offer the same outcomes)</span>.</span>"
            },
            {
              element: document.querySelectorAll('.flowchart-situation')[1],
              intro: "This is the second situation. Someone or a rule turns on the AC (event) while the heater is on (what is true about the home).<br><br><span style='font-weight:bold'>Please select the acceptable outcomes for this situation.</span>"
            },
          ]
        });
        introJS3.start();
      }, 500);
    } else if (this.INTRO_DONE == 4 && this.SECOND_ANSWERED) {
      this.INTRO_DONE++;
      this.SECOND_ANSWERED = false;
      let thisObj = this;
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
              element: document.querySelectorAll('.flowchart-big-box')[1],
              intro: "Good! Both outcomes are acceptable here because <span style='font-weight:bold'>this is a situation in which whatever the program chooses to do is fine.</span>"
            },
            {
              element: "#results",
              intro: "You've answered all of these situations, so now the results will appear."
            },
            {
              element: "#yay100",
              intro: 'First, it will show the list of programs that matched your selected outcomes for <span style="font-weight:bold">all of the situations above</span>.<br><br>Program #1 and #3 are listed here.'
            },
            {
              element: "#therest",
              intro: "Below that, it shows the results for the other programs. The percentages refer to the percentage of situations above that the program matches."
            },
            {
              element: "#therest",
              intro: "In this case, Program #2 matches a selected outcome for half of the situations (Situation #2), which is 50%. Same goes for Program #4."
            }
          ]
        });
        introJS4.start();
        introJS4.oncomplete(function () {
          setTimeout(function () {
            var introJS5 = introJs();
            introJS5.setOptions({
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
                  intro: 'Now that the interface has given you results based on your response, <span style="font-weight:bold">use this part to select your answer, and click on "Submit" to see if your answer is correct.</span>'
                },
              ]
            });
            thisObj.tutorialParams['showSavePanel'] = 'true';
            introJS5.start();
          }, 500);
        });
      }, 500);
    } else if (this.INTRO_DONE == 5 && this.userDataService.SUBMIT_ATTEMPT_CORRECT) {
      this.INTRO_DONE++;
      setTimeout(function () {
        var introJS_final = introJs();
        var answerExplanation: string = "Nice! Program #1 and #3 are the correct programs because when the AC turns on, they would both turn off the heater (Situation #1).<br><br>In other situations (Situation #2) whatever the program does is fine."
        introJS_final.setOptions(thisObj.userDataService.getIntroJsOptionsFinal(answerExplanation));
        introJS_final.start();
      }
      );
    }
  }

  private prgmNumsDefined() {
    this.PRGMNUMSDEFINED = true;
  }
}
