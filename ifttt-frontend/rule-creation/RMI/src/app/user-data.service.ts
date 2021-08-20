import { Injectable } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment } from '../environments/environment';
import { publish, refCount } from 'rxjs/operators';

export interface Task {
  description: String;
  rules: Object[];
}

export interface Rule {
  ifClause: Clause[];
  thenClause: Clause[];
  priority?: number;
  temporality: string;
  id?: number;
}

export interface Sp1 {
  thisState: Clause[];
  thatState: Clause[];
  compatibility: boolean;
}

export interface Sp2 {
  stateClause: Clause[];
  compatibility: boolean;
  comparator?: String;
  time?: Time;
  alsoClauses?: Clause[];
}

export interface Sp3 {
  triggerClause: Clause[];
  compatibility: boolean;
  timeComparator?: string;
  otherClauses?: Clause[];
  afterTime?: Time;
}

export interface Time {
  seconds: number;
  minutes: number;
  hours: number;
}

export interface Clause {
  channel: Channel;
  device: Device;
  capability: Capability;
  parameters?: Parameter[];
  parameterVals?: any[];
  text: string;
  id?: number;
}

export interface Channel {
  id: number;
  name: string;
  icon: string;
}

export interface Device {
  id: number;
  name: string;
}

export interface Capability {
  id: number;
  name: string;
  label: string;
}

export interface Parameter {
  id: number;
  name: string;
  type: string;
  values: any[];
}


@Injectable()
export class UserDataService {

  // user variables
  private taskList: Task[];
  private currentTaskIndex: number = 0;
  public hashed_id: string;
  public user_id: number;
  public task_id: number;
  public version: number = 0;
  public use_version: boolean = false;
  public mode: string;

  // rule variables
  public currentlyStagedRuleIndex: number = 0;
  public currentlyStagedRule: Rule | null = null;
  public currentObjectType: string = "trigger";

  // temporality variables
  public isCurrentObjectEvent: boolean = false;
  public currentObjectIndex: number = -1;
  public temporality: string = "event-state";

  //sp variables
  public currentlyStagedSp1: Sp1 | null = null;
  public currentlyStagedSp2: Sp2 | null = null;
  public currentlyStagedSp3: Sp3 | null = null;
  public currentlyStagedSpIndex: number = 0;
  public currentSpType: number;
  public currentSpClauseType: string;
  public compatibilityPhrase: string = '';
  public comparator: string = '';
  public hasAfterTime: boolean;
  public whileOrAfter: boolean = true;
  public hideSp2Time: boolean = false;
  public hideSp2Also: boolean = false;

  // clause variables
  public channels: Channel[];
  public selectedChannel: Channel;
  public selectedDevice: Device;
  public selectedCapability: Capability;
  public parameters: Parameter[];
  public currentClause: Clause;

  // meta clause variables
  public currentHistoryObjectIndex: number;
  public historyClause: Clause;
  public historyClauseParameterIndex: number;
  public isCurrentHistoryEvent: string = '';
  public currentHistoryObjectType: string = '';

  // editing variables
  public editing: boolean;
  public editingRuleID: number;
  public stopLoadingEdit: boolean;
  public editingSpID: number;

  // timer for diff pages
  public pageStartTime: Date;
  // page operation log for diff pages
  public diffLog: string[] = [];
  // random identifier of this Object
  public randObjectId: number;

  public SUBMIT_ATTEMPT_CORRECT: boolean = false; // only for the tutorials

  private apiUrl: string = environment.apiUrl;

  private TASK_INSTR_PANELS: number = 0;
  private TASK_INSTR_FIRST_CLICKED: string = 'no';

  public introJsOptions = {
    'exitOnOverlayClick': false,
    'exitOnEsc': false,
    'showStepNumbers': false,
    'keyboardNavigation': false,
    'disableInteraction': true, // doesn't work
    'scrollToElement': true
  }

  public introJsOption0 = {
    exitOnOverlayClick: this.introJsOptions['exitOnOverlayClick'],
    exitOnEsc: this.introJsOptions['exitOnEsc'],
    doneLabel: "OK",
    showStepNumbers: this.introJsOptions['showStepNumbers'],
    keyboardNavigation: this.introJsOptions['keyboardNavigation'],
    disableInteraction: this.introJsOptions['disableInteraction'], // doesn't work
    scrollToElement: this.introJsOptions['scrollToElement'],
    steps: [
      {
        intro: "In this study you will use an interface to complete a series of tasks. We will now walk you through an example task with the interface.<br><br><span style='font-weight:bold'>It will help you complete the real tasks of this study later,</span> so please pay close attention!"
        // <br><br>The orange box on the left will remind you what to do in the tutorial.
      },
      {
        element: '.tutorial-reminder',
        intro: 'At any point during this tutorial, refer to this box if you forget what to do next.'
      },
      {
        element: '#taskinstructions',
        intro: 'First, <span style="font-weight:bold">after you click on "OK":<br><br>Use the highlighted button to see what the example task asks you to do.</span>'
      },
    ]
  };

  public introJsOption1 = {
    exitOnOverlayClick: this.introJsOptions['exitOnOverlayClick'],
    exitOnEsc: this.introJsOptions['exitOnEsc'],
    doneLabel: "OK",
    showStepNumbers: this.introJsOptions['showStepNumbers'],
    keyboardNavigation: this.introJsOptions['keyboardNavigation'],
    disableInteraction: this.introJsOptions['disableInteraction'], // doesn't work
    scrollToElement: this.introJsOptions['scrollToElement'],
    steps: [
      {
        element: '#jsPanel-1',
        intro: "Good! For each task in the study, this panel will tell you how to complete it. <span style='font-weight:bold'>Normally you can keep this open</span> while working with the rest of the interface, but for now please <span style='font-weight:bold'>read it and then close it</span> before we continue."
      }
    ]
  };

  constructor(private router: Router, private route: ActivatedRoute,
    private http: HttpClient) {
    this.getUserTasks().then((tasks: Task[]) => {
      this.taskList = tasks;
    });
    this.editing == false;
    this.randObjectId = Math.round(Math.random() * 10000);
  }

  public getIntroJsOptionsFinal(answerExplanation: string) {
    var introJsOptionFinal = {
      exitOnOverlayClick: this.introJsOptions['exitOnOverlayClick'],
      exitOnEsc: this.introJsOptions['exitOnEsc'],
      doneLabel: "OK",
      showStepNumbers: this.introJsOptions['showStepNumbers'],
      keyboardNavigation: this.introJsOptions['keyboardNavigation'],
      disableInteraction: this.introJsOptions['disableInteraction'], // doesn't work
      scrollToElement: this.introJsOptions['scrollToElement'],
      steps: [
        {
          intro: answerExplanation,
        },
        {
          element: '#prgmsbutton',
          intro: "In future tasks, you can also click here to open a small window (like for the task instructions) that shows each program by itself.<br><br>However, note that <span style='font-weight:bold'>in most cases it will be easier to use the interface rather than this feature.</span>"
          // It is up to you whether you want to use this feature, because <span style='font-weight:bold; color:rgb(0, 153, 255)'>the information on the interface is always accurate.</span>"
        },
        // {
        //   element: '#savepanel',
        //   intro: 'Lastly, note that in the real tasks, <span style="font-weight:bold; color:rgb(0, 153, 255)">you will NOT be able to go back and change your answer once you click on "Submit".</span>'
        // },
        {
          intro: "That concludes the tutorial! You may now close this tab and <span style='font-weight:bold'>return to the survey.</span>"
        }
      ]
    }
    this.saveSelVers([-9]).subscribe(
      succeed => {
        // alert('save');
        console.log("# save done.");
      }
    );
    return introJsOptionFinal;
  }

  public countOpenTaskInstr() {
    this.TASK_INSTR_PANELS++;
  }

  public countCloseTaskInstr() {
    this.TASK_INSTR_PANELS--;
  }

  public waitForTaskInstr() {
    return this.TASK_INSTR_PANELS > 0;
  }

  public recordFirstTaskInstrClick() {
    if (this.TASK_INSTR_FIRST_CLICKED == 'no') this.TASK_INSTR_FIRST_CLICKED = 'yes';
  }

  public TaskInstrHasBeenFirstClicked() {
    return this.TASK_INSTR_FIRST_CLICKED == 'yes';
  }

  public convertNumStrToLetter(n: string) {
    return 'abcdefghijklmnopqrstuvwxyz'.charAt(parseInt(n) % 26);
  }

  // unused
  public shouldShowPriority(): boolean {
    const shouldShow = this.temporality === "state-state";
    if (shouldShow && !this.currentlyStagedRule.priority) {
      this.currentlyStagedRule['priority'] = 1;
    }
    return shouldShow;
  }

  // unused
  public getDescriptionFromClause(clause: Clause) {
    return this.currentClause.text;
  }

  // unused
  private getUserTasks(): Promise<Task[]> {
    return new Promise((resolve, reject) => {
      resolve([
        {
          description: `Your dog, Fido, likes to play outside in the rain, but he then tracks mud into
            the house. Therefore, if Fido happens to be outside in the rain, call him inside.`,
          rules: []
        }
      ]);
    });
  }

  // unused
  public getCurrentTask(): Task {
    return this.taskList[this.currentTaskIndex];
  }

  // unused
  public getTotalNumberTasks(): number {
    return this.taskList.length;
  }

  // unused
  public getCurrentTaskNumber(): string {
    // return this.currentTaskIndex + 1;
    return "hello"; // thanks abhi
  }

  // unused
  public isRuleCurrentlyStaged(): boolean {
    return !!this.currentlyStagedRule;
  }

  // stages empty rule if no rule
  public stageRule(): void {
    if (!this.currentlyStagedRule) {
      this.currentlyStagedRule = {
        ifClause: [],
        thenClause: [],
        temporality: this.temporality,
      };
    }
  }

  // adds current clause to either "if" or "then" clauses or current rule
  public addClauseToRule() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    delete this.parameters;
    if (this.currentObjectType == "trigger") {
      if (this.currentObjectIndex == -1) {
        clause.id = this.currentlyStagedRule.ifClause.length;
        this.currentlyStagedRule.ifClause.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedRule.ifClause[this.currentObjectIndex] = clause;
      }
    }
    else {
      clause.id = 0;
      this.currentlyStagedRule.thenClause[0] = clause;
    }
  }

  // benches current clause to "this.historyClause" so the clause to fulfill
  // the meta parameter can be chosen for rules
  public selectHistoryClause(historyClauseParameterIndex: number, currentParameterVals: any[], temporality: string) {
    this.historyClauseParameterIndex = historyClauseParameterIndex;
    this.historyClause = this.currentClause;
    this.historyClause.parameterVals = currentParameterVals;
    this.currentHistoryObjectIndex = this.currentObjectIndex;
    delete this.currentClause;
    var is_event = (temporality == 'event' ? -1 : 1);
    this.gotoChannelSelector('trigger', is_event);
  }

  // benches current clause to "this.historyClause" so the clause to fulfill
  // the meta parameter can be chosen for sps
  public selectSpHistoryClause(sptype: number, historyClauseParameterIndex: number, currentParameterVals: any[], temporality: string) {
    this.historyClauseParameterIndex = historyClauseParameterIndex;
    this.historyClause = this.currentClause;
    this.historyClause.parameterVals = currentParameterVals;
    delete this.currentClause;
    this.currentHistoryObjectIndex = this.currentObjectIndex;
    var trigger = (temporality == 'event' ? 'trigger' : 'not-trigger');
    this.gotoSpChannelSelector(trigger, this.currentSpClauseType, 0);
  }

  // takes historyClause off the bench and adds the current clause as
  // its meta parameter
  public addClauseToHistoryChannelClause() {
    this.historyClause.parameterVals[this.historyClauseParameterIndex] = { "value": this.getTextForClause(this.currentClause), "comparator": "=" }
    this.currentClause = this.historyClause;
    delete this.historyClause;
    this.isCurrentObjectEvent = this.isCurrentHistoryEvent == 'event' ? true : false;
    this.isCurrentHistoryEvent = '';
    this.currentObjectIndex = this.currentHistoryObjectIndex;
    delete this.currentHistoryObjectIndex;
    this.selectedDevice = this.currentClause.device;
    this.selectedCapability = this.currentClause.capability;
  }

  // reloads parameter configuration page now that we've selected the
  // meta parameter for rules
  public reloadForHistoryClause() {
    this.router.navigate(['../create'], { skipLocationChange: true }).then(() =>
      this.router.navigate(['../create/configureParameters',
        this.currentClause.channel.id,
        this.currentClause.device.id,
        this.currentClause.capability.id]));
  }

  // reloads parameter configuration page now that we've selected the
  // meta parameter for sps
  public reloadForSpHistoryClause() {
    this.router.navigate(['../createSp'], { skipLocationChange: true }).then(() =>
      this.router.navigate(['../createSp/configureParameters',
        this.currentClause.channel.id,
        this.currentClause.device.id,
        this.currentClause.capability.id]));
  }

  public reloadForRuleClear() {
    delete this.currentlyStagedRule;
    this.stopLoadingEdit = true;
    this.router.navigate([this.hashed_id + "/" + this.task_id + "/rules"], { skipLocationChange: true }).then(() =>
      this.router.navigate(['../create']));
  }

  public reloadForSp1Clear() {
    delete this.currentlyStagedSp1;
    this.stopLoadingEdit = true;
    this.router.navigate(['../createSp'], { skipLocationChange: true }).then(() =>
      this.router.navigate(['../createSp/sp1']));
  }

  public reloadForSp2Clear() {
    delete this.currentlyStagedSp2
    this.stopLoadingEdit = true;
    this.router.navigate(['../createSp'], { skipLocationChange: true }).then(() =>
      this.router.navigate(['../createSp/sp2']));
  }

  public reloadForSp3Clear() {
    this.whileOrAfter = true;
    delete this.currentlyStagedSp3;
    this.stopLoadingEdit = true;
    this.router.navigate(['../createSp'], { skipLocationChange: true }).then(() =>
      this.router.navigate(['../createSp/sp3']));
  }

  // uses a ruleid to get a full rule from the backend for editing
  public getFullRule(ruleid: number) {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { "userid": this.user_id, "ruleid": ruleid };
    this.http.post(this.apiUrl + "user/rules/get/", body, option)
      .subscribe(
        data => {
          this.currentlyStagedRule = data["rule"];
        }
      );
  }

  // sends current rule to backend for saving
  public finishRule() {
    var mode = (this.editing ? "edit" : "create");
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    var ruleid = (this.editing ? this.editingRuleID : 0)
    let body = { "rule": this.currentlyStagedRule, "userid": this.user_id, "taskid": this.task_id, "version": this.version, "mode": mode, "ruleid": ruleid };

    this.editing = false;
    this.compatibilityPhrase = '';
    this.http.post(this.apiUrl + "user/rules/new/", body, option)
      .subscribe(
        data => {
          this.currentlyStagedRule = null;
          if (this.use_version) {
            this.router.navigate(["diff/" + this.hashed_id + "/" + this.task_id + "/" + this.version + "/rules"]);
          } else {
            this.router.navigate([this.hashed_id + "/" + this.task_id + "/rules"]);
          }
        }
      );
  }

  // save AutoTap patch
  public savePatch(rule: Rule, version: number) {
    for (let i = 0; i < rule.ifClause.length; i++) {
      rule.ifClause[i].id = i;
    }
    rule.thenClause[0].id = 0;

    var mode = "create";
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    var ruleid = 0;
    let body = { "rule": rule, "userid": this.user_id, "taskid": this.task_id, "version": version, "mode": mode, "ruleid": ruleid };

    this.http.post(this.apiUrl + "user/rules/new/", body, option)
      .subscribe(
        data => {
          this.router.navigate(["diff/" + this.hashed_id + "/" + this.task_id + "/" + version + "/rules"]);
        }
      );
  }

  // deletes rule at ruleid
  public deleteRule(ruleid: number) {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { "userid": this.user_id, "taskid": this.task_id, "ruleid": ruleid, "version": this.version } //version have to included.
    return this.http.post(this.apiUrl + "user/rules/delete/", body, option)
  }

  // checks if staged rule is valid to be saved
  public stagedRuleIsValid(): boolean {
    return (this.currentlyStagedRule && this.currentlyStagedRule.ifClause.length > 0
      && this.currentlyStagedRule.thenClause.length > 0);
  }

  // navigates to rule creation
  public gotoCreate() {
    this.router.navigate(["../create/"]);
  }

  //navigates to sp creation
  public gotoCreateSp(sptype: number) {
    if (sptype == 1) {
      this.router.navigate(["../createSp/sp1"]);
    }
    else if (sptype == 2) {
      this.router.navigate(["../createSp/sp2"]);
    }
    else if (sptype == 3) {
      this.router.navigate(["../createSp/sp3"]);
    }
    else { this.router.navigate(["../createSp/"]); }
  }

  // navigates to channel selector for rules
  public gotoChannelSelector(objectType: string, index: number): void {
    if (objectType == 'trigger' || objectType == 'action') this.currentObjectType = objectType;
    if (objectType == 'triggerAdd') { this.currentObjectType = 'trigger'; }
    this.currentObjectIndex = index;
    if (objectType == "trigger" && index <= 0) {
      this.isCurrentObjectEvent = true;
    } else {
      this.isCurrentObjectEvent = false;
    }
    this.router.navigate(["../create/selectChannel"], { relativeTo: this.route });
  }

  // navigates to channel selector for sps
  public gotoSpChannelSelector(objectType: string, spClauseType: string, index: number): void {
    this.currentObjectType = objectType;
    this.currentSpClauseType = spClauseType;
    this.currentObjectIndex = index;
    if (spClauseType == 'trigger' || spClauseType == 'otherEvent') { this.isCurrentObjectEvent = true }
    else { this.isCurrentObjectEvent = false }
    this.router.navigate(["../createSp/selectChannel"], { relativeTo: this.route });
  }

  // navigates to device selector for rules
  public gotoDeviceSelector(channel: Channel): void {
    this.selectedChannel = channel;
    this.router.navigate(['../create/selectDevice', String(channel.id)])
  }

  // navigates to device selector for sps
  public gotoSpDeviceSelector(channel: Channel): void {
    this.selectedChannel = channel;
    this.router.navigate(['../createSp/selectDevice', String(channel.id)])
  }

  //navigates to capability selector for rules
  public gotoCapabilitySelector(selectedDevice: Device, channelID: number, deviceID: number): void {
    this.selectedDevice = selectedDevice;
    this.router.navigate(['../create/selectCapability', String(channelID), String(deviceID)]);
  }

  // navigates to capability selector for sps
  public gotoSpCapabilitySelector(selectedDevice: Device, channelID: number, deviceID: number): void {
    this.selectedDevice = selectedDevice;
    this.router.navigate(['../createSp/selectCapability', String(channelID), String(deviceID)]);
  }

  // navigates to parameter configuration for rules
  public gotoParameterConfiguration(selectedCapability: Capability, channelID: number, deviceID: number, capabilityID: number) {
    this.selectedCapability = selectedCapability;
    this.currentClause = { "channel": this.selectedChannel, "device": this.selectedDevice, "capability": this.selectedCapability, "text": this.selectedCapability.label }
    var parameters;
    this.getParametersForCapability(true, true, deviceID, capabilityID).subscribe(
      data => {
        parameters = data["params"];
        if (parameters.length > 0) {
          this.router.navigate(['../create/configureParameters', String(channelID), String(deviceID), String(capabilityID)]);
        }
        else {
          this.addClauseToRule()
          this.gotoCreate();
        }
      });
  }

  // navigates to parameter configuration for sps
  public gotoSpParameterConfiguration(selectedCapability: Capability, channelID: number, deviceID: number, capabilityID: number) {
    this.selectedCapability = selectedCapability;
    this.currentClause = { "channel": this.selectedChannel, "device": this.selectedDevice, "capability": this.selectedCapability, "text": this.selectedCapability.label }
    var parameters;
    this.getParametersForCapability(true, true, deviceID, capabilityID).subscribe(
      data => {
        parameters = data["params"];
        if (parameters.length > 0) {
          this.router.navigate(['../createSp/configureParameters', String(channelID), String(deviceID), String(capabilityID)]);
        }
        else {
          if (this.currentlyStagedSp1) {
            this.addClauseToSp1()
            this.gotoCreateSp(1);
          }
          else if (this.currentlyStagedSp2) {
            this.addClauseToSp2()
            this.gotoCreateSp(2);
          }
          else {
            this.addClauseToSp3()
            this.gotoCreateSp(3);
          }
        }
      }
    );
  }

  // get csrf cookie from the backend
  public getCsrfCookie(): any {
    this.appendLog("getCsrfCookie start.");
    let option = { withCredentials: true };
    let httpObject = this.http.get(this.apiUrl + "user/get_cookie/", option).pipe(publish(), refCount());
    httpObject.subscribe(val => { this.appendLog("user/get_cookie/ http done.") });
    return httpObject;
  }

  // get patches for a certain (user_id, task_id) based on its sps and rules
  public verifyTask(hashed_id: string): any {
    let body = { "userid": this.user_id, "taskid": this.task_id, "code": hashed_id, "compact": 0, "named": 0 };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.post(this.apiUrl + "autotap/fix/", body, option);
  }

  // gets a user's rules from the backend using their user_id, as well as
  // will get their numerical user id based on their string
  // hashed_id URL parameter if a user_id field isn't provided in this call.
  public getRules(hashed_id: string): any {
    let body = { "userid": this.user_id, "taskid": this.task_id, "code": hashed_id };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.post(this.apiUrl + "user/rules/", body, option);
  }

  // gets a user's rules from the backend using their user_id, as well as
  // will get their numerical user id based on their string
  // hashed_id URL parameter if a user_id field isn't provided in this call.
  public getRulesWithVersion(hashed_id: string): any {
    let body = { "userid": this.user_id, "taskid": this.task_id, "version": this.version, "code": hashed_id };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    this.appendLog("getRulesWithVersion");
    let httpObject = this.http.post(this.apiUrl + "user/rules/", body, option).pipe(publish(), refCount());
    httpObject.subscribe(val => { this.appendLog("user/rules/ (getRulesWithVersion) http done.") });
    return httpObject;
  }

  // gets all channels from the backend
  public getChannels(is_Trigger: boolean, is_Event: boolean): any {
    let body = { "userid": this.user_id, "is_trigger": is_Trigger };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.post(this.apiUrl + "user/chans/", body, option);
  }

  // gets all devices related to selected channel
  public getDevicesForChannel(is_Trigger: boolean, is_Event: boolean, channel_id: number): any {
    let body = { "userid": this.user_id, "is_trigger": is_Trigger, "channelid": channel_id };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.post(this.apiUrl + "user/chans/devs/", body, option);
  }

  // gets all capabilities related to selected device
  public getCapabilitiesForDevice(is_Trigger: boolean, is_Event: boolean, device_id: number, channel_id: number): any {
    let body = {
      "channelid": channel_id,
      "deviceid": device_id,
      "is_trigger": is_Trigger,
      "is_event": is_Event
    };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.post(this.apiUrl + "user/chans/devs/caps/", body, option);
  }

  // gets all parameters for selected capability
  public getParametersForCapability(is_Trigger: boolean, is_Event: boolean, device_id: number, capability_id: number): any {
    let body = { "capid": capability_id };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.post(this.apiUrl + "user/chans/devs/caps/params/", body, option);
  }

  // wherever a full clause shows up (in /rules, /sp, /create, or /createSp)
  // this function uses regular expressions on its label to put the
  // add its selected values
  public getTextForClause(clause: Clause): Clause {
    var label = clause.capability.label;
    label = label.replace("{DEVICE}", clause.device.name);
    var parameter: any;
    for (parameter in clause.parameters) {
      if (clause.parameters[parameter].type == "range" || clause.parameters[parameter].type == "input") {
        label = label.replace("{" + clause.parameters[parameter].name + "}", clause.parameterVals[parameter].value);
        const rangeComparators = ["=", "!=", ">", "<"];
        var i: number;
        for (i = 0; i < rangeComparators.length; i++) {
          if (clause.parameterVals[parameter].comparator == rangeComparators[i]) {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + rangeComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1");
          }
          else {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + rangeComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else if (clause.parameters[parameter].type == "set") {
        label = label.replace("{" + clause.parameters[parameter].name + "}", clause.parameterVals[parameter].value);
        const setComparators = ["=", "!="];
        var i: number;
        for (i = 0; i < setComparators.length; i++) {
          if (clause.parameterVals[parameter].comparator == setComparators[i]) {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + setComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1")
          }
          else {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + setComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else if (clause.parameters[parameter].type == "duration") {
        var description = '';
        const sptime = clause.parameterVals[parameter].value;
        if (sptime.hours > 0) { description += (sptime.hours + "h "); }
        if (sptime.minutes > 0) { description += (sptime.minutes + "m "); }
        if (sptime.seconds > 0) { description += (sptime.seconds + "s "); }
        label = label.replace("{" + clause.parameters[parameter].name + "}", description);
        const durationComparators = [">", "<", "="];
        var i: number;
        for (i = 0; i < durationComparators.length; i++) {
          if (clause.parameterVals[parameter].comparator == durationComparators[i]) {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + durationComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1")
          }
          else {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + durationComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else if (clause.parameters[parameter].type == "meta") {
        label = label.replace("{$trigger$}", clause.parameterVals[parameter].value.text)
      }
      else if (clause.parameters[parameter].type != "bin") {
        label = label.replace("{" + clause.parameters[parameter].name + "}", clause.parameterVals[parameter].value);
        // this is overkill but apparently it's needed in some cases
        const setComparators = ["=", "!=", ">", "<"];
        var i: number;
        for (i = 0; i < setComparators.length; i++) {
          if (clause.parameterVals[parameter].comparator == setComparators[i]) {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + setComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1")
          }
          else {
            var re = new RegExp("{" + clause.parameters[parameter].name + "\/" + setComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else {
        label = label.replace("{" + clause.parameters[parameter].name + "}", clause.parameterVals[parameter].value);
        // if binary value is true
        if (clause.parameterVals[parameter].value == clause.parameters[parameter].values[0]) {
          // get rid of false text
          var re = new RegExp("{" + clause.parameters[parameter].name + "\/F\\|.*?}", "g");
          label = label.replace(re, "");
          // leave true text but get rid of its capsule
          var re = new RegExp("{" + clause.parameters[parameter].name + "\/T\\|(.*?)}", "g");
          label = label.replace(re, "$1")
        }
        else if (clause.parameterVals[parameter].value == clause.parameters[parameter].values[1]) {
          // get rid of true text
          var re = new RegExp("{" + clause.parameters[parameter].name + "\/T\\|.*?}", "g");
          label = label.replace(re, "");
          // leave false text but get rid of its capsule
          var re = new RegExp("{" + clause.parameters[parameter].name + "\/F\\|(.*?)}", "g");
          label = label.replace(re, "$1")
        } else {
          // get rid of true text
          var re = new RegExp("{" + clause.parameters[parameter].name + "\/T\\|.*?}", "g");
          label = label.replace(re, "");
          // get rid of false text
          var re = new RegExp("{" + clause.parameters[parameter].name + "\/F\\|.*?}", "g");
          label = label.replace(re, "");
        }
      }
    }
    clause.text = label;
    return clause;
  }

  // SAFETY PROPERTY STUFF BELOW

  // gets a user's sps from the backend using their user_id, as well as
  // will get their numerical user id based on their string
  // hashed_id URL parameter if a user_id field isn't provided in this call.
  public getSps(hashed_id: string): any {
    let body = { "userid": this.user_id, "taskid": this.task_id, "code": hashed_id };
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.post(this.apiUrl + "user/sps/", body, option);
  }

  // checks if currently staged sp is valid to be saved
  public stagedSpIsValid(sptype: number): boolean {
    if (sptype == 1) {
      return (this.currentlyStagedSp1 && this.currentlyStagedSp1.thisState.length > 0
        && this.currentlyStagedSp1.thatState.length > 0 && this.compatibilityPhrase != '');
    }
    if (sptype == 2) {
      var bool = (this.currentlyStagedSp2 && this.currentlyStagedSp2.stateClause.length > 0 &&
        this.compatibilityPhrase != '');
      return bool;
    }
    if (sptype == 3) {
      var bool = (this.currentlyStagedSp3 && this.currentlyStagedSp3.triggerClause.length > 0
        && this.currentlyStagedSp3.compatibility == false);
      if (this.currentlyStagedSp3 && this.compatibilityPhrase != '' && this.currentlyStagedSp3.triggerClause.length > 0 &&
        (this.currentlyStagedSp3.otherClauses.length > 0 ||
          this.currentlyStagedSp3.afterTime)) {
        bool = true;
      }
      if (this.currentlyStagedSp3.afterTime && this.currentlyStagedSp3.otherClauses.length == 0) {
        bool = false
      }
      return bool;
    }
  }

  // stages an empty sp1 if there isn't one
  public stageSp1(): void {
    if (!this.currentlyStagedSp1) {
      this.currentlyStagedSp1 = {
        thisState: [],
        thatState: [],
        compatibility: true,
      };
    }
  }

  // stages an empty sp2 if there isn't one
  public stageSp2(): void {
    if (!this.currentlyStagedSp2) {
      this.currentlyStagedSp2 = {
        stateClause: [],
        alsoClauses: [],
        compatibility: true,
        comparator: '>',
        time: null,
      };
    }
  }

  // stages an empty sp3 if there isn't one
  public stageSp3(): void {
    if (!this.currentlyStagedSp3) {
      this.currentlyStagedSp3 = {
        triggerClause: [],
        otherClauses: [],
        compatibility: true,
        timeComparator: '<',
      };
    }
  }

  // adds current clause to currently staged sp1
  public addClauseToSp1() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    if (this.currentSpClauseType == "this") {
      clause.id = 0;
      this.currentlyStagedSp1.thisState[0] = clause;
    }
    else {
      if (this.currentObjectIndex == -1) {
        clause.id = 0;
        this.currentlyStagedSp1.thatState.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedSp1.thatState[this.currentObjectIndex] = clause;
      }
    }
  }

  // adds current clause to currently staged sp2
  public addClauseToSp2() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    if (this.currentSpClauseType == "state") {
      clause.id = 0;
      this.currentlyStagedSp2.stateClause[0] = clause;
    }
    else {
      if (this.currentObjectIndex == -1) {
        clause.id = 0;
        this.currentlyStagedSp2.alsoClauses.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedSp2.alsoClauses[this.currentObjectIndex] = clause;
      }
    }
  }

  // adds current clause to currently staged sp3
  public addClauseToSp3() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    if (this.currentSpClauseType == "trigger") {
      clause.id = 0;
      this.currentlyStagedSp3.triggerClause[0] = clause;
    }
    else {
      if (this.currentObjectIndex == -1) {
        clause.id = 0;
        this.currentlyStagedSp3.otherClauses.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedSp3.otherClauses[this.currentObjectIndex] = clause;
      }
    }
  }

  // saves currently staged sp to the backend
  public finishSp(sptype: number) {
    var mode = (this.editing ? "edit" : "create");
    var spid = (this.editing ? this.editingSpID : 0)
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    this.editing == false;
    if (sptype == 1) {
      let body = { "sp": this.currentlyStagedSp1, "userid": this.user_id, "taskid": this.task_id, "mode": mode, "spid": spid };
      this.http.post(this.apiUrl + "user/sp1/new/", body, option)
        .subscribe(
          data => {
            this.currentlyStagedSp1 = null;
            this.router.navigate([this.hashed_id + "/" + this.task_id + "/sp"]);
          }
        );
    }
    else if (sptype == 2) {
      let body = { "sp": this.currentlyStagedSp2, "userid": this.user_id, "taskid": this.task_id, "mode": mode, "spid": spid };
      this.http.post(this.apiUrl + "user/sp2/new/", body, option)
        .subscribe(
          data => {
            this.currentlyStagedSp2 = null;
            this.router.navigate([this.hashed_id + "/" + this.task_id + "/sp"]);
          }
        );
    }
    else {
      let body = { "sp": this.currentlyStagedSp3, "userid": this.user_id, "taskid": this.task_id, "mode": mode, "spid": spid };
      this.http.post(this.apiUrl + "user/sp3/new/", body, option)
        .subscribe(
          data => {
            this.currentlyStagedSp3 = null;
            this.router.navigate([this.hashed_id + "/" + this.task_id + "/sp"]);
          }
        );
    }
  }

  // gets a full sp from the backend from its id for editing
  public getFullSp(spid: number, sptype: number) {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { "userid": this.user_id, "spid": spid };
    if (sptype == 1) {
      this.http.post(this.apiUrl + "user/sp1/get/", body, option)
        .subscribe(
          data => {
            this.currentlyStagedSp1 = data["sp"];
            this.compatibilityPhrase = (data["sp"].compatibility ? 'always' : 'never');
          }
        );
    } else if (sptype == 2) {
      this.http.post(this.apiUrl + "user/sp2/get/", body, option)
        .subscribe(
          data => {
            this.currentlyStagedSp2 = data["sp"];
            this.compatibilityPhrase = (data["sp"].compatibility ? 'always' : 'never');
            if (!this.currentlyStagedSp2.comparator) {
              this.currentlyStagedSp2.comparator = '';
            }
            if (!this.currentlyStagedSp2.time) {
              this.hideSp2Time = true;
            } else { this.hideSp2Time = false; }
            if (this.currentlyStagedSp2.alsoClauses.length == 0) {
              this.hideSp2Also = true;
            } else { this.hideSp2Also = false; }
          });
    } else {
      this.http.post(this.apiUrl + "user/sp3/get/", body, option)
        .subscribe(
          data => {
            this.currentlyStagedSp3 = data["sp"];
            this.compatibilityPhrase = (data["sp"].compatibility ? 'always' : 'never');
            this.hasAfterTime = (data["sp"].timeAfter ? true : false);
            this.currentlyStagedSp3.timeComparator = '>';
          }
        );
    }
  }

  // deletes sp by its id
  public deleteSp(spid: number) {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { "userid": this.user_id, "taskid": this.task_id, "spid": spid }
    return this.http.post(this.apiUrl + "user/sps/delete/", body, option)
  }

  public compareRules(hashed_id: string, diff_key: string, version1: number, version2: number): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = {
      "userid": this.user_id, "taskid": this.task_id, "code": hashed_id,
      "version1": version1, "version2": version2 != null && version2 >= 0 ? version2 : version1
    }
    this.appendLog("compareRules | " + diff_key + " | " + body['version1'] + " | " + body['version2']);
    if (diff_key == 'text') {
      let httpObject = this.http.post(this.apiUrl + 'user/compare/', body, option).pipe(publish(), refCount());
      httpObject.subscribe(val => { this.appendLog("user/compare/ http done.") });
      return httpObject;
    } else if (diff_key == 'timeline') {
      let httpObject = this.http.post(this.apiUrl + "autotap/diff/", body, option).pipe(publish(), refCount());
      httpObject.subscribe(val => { this.appendLog("autotap/diff/ http done.") });
      return httpObject;
    } else if (diff_key == 'sp') {
      let httpObject = this.http.post(this.apiUrl + "autotap/spdiff/", body, option).pipe(publish(), refCount());
      httpObject.subscribe(val => { this.appendLog("autotap/spdiff/ http done.") });
      return httpObject;
    }
  }

  // public compareAllVersions(hashed_id: string, all_versions: number[], task_type:number): any {
  public compareAllVersions(hashed_id: string, all_versions: number[]): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = {
      "userid": this.user_id, "taskid": this.task_id, "code": hashed_id,
      "verids": all_versions
      // , "tasktype": task_type
    }
    this.appendLog("compareAllVersions | qdiff");
    let httpObject = this.http.post(this.apiUrl + "autotap/qdiff/", body, option).pipe(publish(), refCount());
    httpObject.subscribe(val => { this.appendLog("autotap/qdiff/ http done.") });
    return httpObject;
  }

  public getVersionIds(hashed_id: string): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { "userid": this.user_id, "taskid": this.task_id, "code": hashed_id }
    this.appendLog("getVersionIds");
    let httpObject = this.http.post(this.apiUrl + 'user/get_version_ids/', body, option).pipe(publish(), refCount());
    httpObject.subscribe(val => { this.appendLog("user/get_version_ids/ http done.") });
    return httpObject;
  }

  public getVersionPrograms(hashed_id: string): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { "userid": this.user_id, "taskid": this.task_id, "code": hashed_id }
    this.appendLog("getVersionPrograms");
    let httpObject = this.http.post(this.apiUrl + 'user/get_version_programs/', body, option).pipe(publish(), refCount());
    httpObject.subscribe(val => { this.appendLog("user/get_version_programs/ http done.") });
    return httpObject;
  }


  // ***********[BELOW]****** for diff userstudy dashboard **********************
  public getAllUsers(): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    return this.http.get(this.apiUrl + "users/get/", option)
  }

  public getTasks(usercode: string): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { code: usercode };
    return this.http.post(this.apiUrl + "user/tasks/get/", body, option)
  }

  public deleteTasks(usercode: string): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { code: usercode };
    return this.http.post(this.apiUrl + "user/tasks/delete/", body, option)
  }

  public copyTasks(srcUsercode: string, dstUsercode: string, tasks: string[]): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let body = { "src_user_code": srcUsercode, "dest_user_code": dstUsercode, "tasks": tasks }
    return this.http.post(this.apiUrl + "user/tasks/copy/", body, option)
  }

  public deleteVers(usercode: string, strTaskVers: string[]): any {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let taskVers = strTaskVers.map(x => x.split('.').map(y => y.trim()));
    let body = { "code": usercode, "task_vers": taskVers }
    return this.http.post(this.apiUrl + "user/tasks/versions/delete/", body, option)
  }

  public copyVers(usercode: string, strSrcVer: string, strDstVers: string[]) {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let srcVer = strSrcVer.split('.').map(y => y.trim());
    let dstVers = strDstVers.map(x => x.split('.').map(y => y.trim()));
    let body = { "code": usercode, "src_ver": srcVer, "dest_vers": dstVers }
    return this.http.post(this.apiUrl + "user/tasks/versions/copy/", body, option)
  }

  // ***********[BEFORE]****** for diff userstudy dashboard **********************

  // start timer
  public startTimer() {
    this.pageStartTime = new Date();
  }

  //log a string to diffLog
  public appendLog(logstr: string) {
    // for now, only for tracking tasks and prgm panel
    if (logstr.startsWith('>>>')) {
      logstr = logstr.replace('>>>', ''); // only for tracking tasks and prgm panel
      let completeLogstr = new Date().getTime().toString() + ": " + logstr;
      this.diffLog.push(completeLogstr);
    }
  }

  public submitAttemptCorrect() {
    this.SUBMIT_ATTEMPT_CORRECT = true;
  }

  // save selection
  public saveSelVers(selVers: number[]) {
    let option = { headers: new HttpHeaders().set('Content-Type', 'application/json') };
    let timeElapsed = 0;
    if (this.pageStartTime) {
      timeElapsed = new Date().getTime() - this.pageStartTime.getTime();
    }
    let body = {
      "code": this.hashed_id,
      "task_id": this.task_id,
      "selected_versions": selVers,
      "time_elapsed": timeElapsed,
      "time_stamp": new Date().getTime(),
      "operation_log": this.diffLog
    };
    return this.http.post(this.apiUrl + "user/tasks/versions/select/", body, option)
  }

  public showClause(c: string) {
    var new_c: string = c;
    if (new_c.includes('(FitBit)')) {
      new_c = new_c.replace('(FitBit)', '');
    }
    if (new_c.includes('in Home')) {
      new_c = new_c.replace('in Home', 'at Home');
    }
    if (new_c.includes('(Thermostat) The temperature')) {
      new_c = new_c.replace('(Thermostat) The temperature', 'Indoor temperature');
    }
    if (new_c.includes('temperature') && new_c.includes('degrees')) {
      new_c = new_c.replace(' degrees', '°F');
    }
    return new_c;
  }

  public static staticShowClause(c: string) {
    // static because needed for spdiff (for updating clauses)
    var new_c: string = c;
    if (new_c.includes('(FitBit)')) {
      new_c = new_c.replace('(FitBit)', '');
    }
    if (new_c.includes('in Home')) {
      new_c = new_c.replace('in Home', 'at Home');
    }
    if (new_c.includes('(Thermostat) The temperature')) {
      new_c = new_c.replace('(Thermostat) The temperature', 'Indoor temperature');
    }
    if (new_c.includes('temperature') && new_c.includes('degrees')) {
      new_c = new_c.replace(' degrees', '°F');
    }
    return new_c;
  }

  public trimDevName(dev: string, tdiff: boolean): string {
    let device_name = dev.split(': ')[0];
    let cap_name = dev.split(': ')[1];

    if (device_name == 'Thermostat') {
      if (cap_name.includes('AC')) {
        device_name = 'AC';
      } else if (cap_name.includes('Heater')) {
        device_name = 'Heater';
      }
    }
    if (dev == 'FitBit: Sleep Sensor') {
      if (tdiff) {
        // return "Alice's State (Awake/Asleep)";
        return 'My State (Awake/Asleep)';
      } else {
        // return 'Alice';
        return 'I'; // i.e. "I am awake" or etc.
      }
    }
    if (device_name.startsWith('Location Sensor')) {
      return device_name.replace('Location Sensor', '') + "'s Location"; // no cap_name needed I guess
    }

    if (cap_name == 'Current Temperature') {
      return 'Indoor Temperature';
    }

    if (cap_name == 'Open Close Curtains') {
      return device_name + ' ' + 'Curtains';
    }

    if (device_name == 'Clock') {
      return 'Time of Day';
    }
    return device_name;
  }
}
