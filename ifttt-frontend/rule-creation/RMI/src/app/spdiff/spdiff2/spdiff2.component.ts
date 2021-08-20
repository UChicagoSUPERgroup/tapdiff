import { Component, OnInit, EventEmitter } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UserDataService, Clause, Channel, Device, Capability, Parameter } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { MatSelectChange } from '@angular/material/select';
import { Rule } from '../../user-data.service';
import { DiffcomService, RuleUIRepresentation } from '../../diffcom.service';

import { HelpInfoDialogCommonComponent } from '../../help-info-dialog/help-info-dialog-common/help-info-dialog-common.component';
import * as introJs from 'intro.js/intro.js';

export interface SpUIRepresentationX {
  identifier: string;
  words: string[]; // e.g. IF, AND, THEN
  icons: string[]; // the string name of the icons
  descriptions: string[]; // the descriptions for each of the icons
  ruleIndexs: number[]; // indexes of related rules.
  ruleIndexs2?: number[]; // indexes of related rules(shared Sp have second one).
  status: number;
}

export interface SpUIRepresentationXPair {
  left: SpUIRepresentationX;
  right: SpUIRepresentationX;
}

@Component({
  selector: 'app-spdiff2',
  templateUrl: './spdiff2.component.html',
  styleUrls: ['./spdiff2.component.css']
})
export class Spdiff2Component implements OnInit {
  private unparsedSps: any[];
  public isLoading = false;
  public isError: boolean = false;
  public PRGMNUMSDEFINED: boolean = false;
  public isSpsShareVisible: boolean = true;
  public urlParams = {
    "dropdown-style": "none",
    "dropdown-label": "false",
    "share-sp-enable": "false",
    "sdiff-enable": "true",
    "sp-id-enable": "false",
    "tutorial": "false"
  };

  public tutorialParams = {
    'showPrgmButton': 'false',
    'showSavePanel': 'false'
  }

  private INTRO_DONE: number = 0;
  private DROPDOWN_CLICKED: boolean = false;
  private INTERVAL: number = 5;

  public SPS_1: SpUIRepresentationX[] = [];
  public SPS_2: SpUIRepresentationX[] = [];
  public SPS_SHARE: SpUIRepresentationX[] = [];
  public FILTERED_SPS_1: SpUIRepresentationX[] = [];
  public FILTERED_SPS_2: SpUIRepresentationX[] = [];
  public SPS_TABLE: SpUIRepresentationXPair[] = []; //each row have 2 elements
  public ATTRIBS: String[] = ["always", "only", "never"];

  //identifiers by rule
  public SP_IDENTIFIER_BY_RULES1: { [id: number]: string[] } = {};
  public SP_IDENTIFIER_BY_RULES2: { [id: number]: string[] } = {};
  public SPS_DEVICES: string[] = [];

  public DEVICE_ANY_CONST = "(any device)";
  public DEVICE_FILTER: string = "(any device)";

  public STATES_NEVER: SpUIRepresentationX[]; // TODO: /events/ that should never happen
  public STATES_ALWAYS: SpUIRepresentationX[];
  public STATES_TOGETHER_NEVER: SpUIRepresentationX[][];

  public VERSION_1: number;
  public VERSION_2: number;
  public PROGRAMNUMS: number[];
  public DESIREDPROGRAM: number; // the program that the user chooses at the end to save
  public PROGRAMS: { [id: number]: Rule[]; };
  public READY: boolean = true;

  private cache: { [id: string]: SpUIRepresentationX[][]; } = {};

  constructor(
    public dialog: MatDialog,
    public userDataService: UserDataService,
    private route: Router,
    private router: ActivatedRoute) {
  }

  private getSpUIPlaceholder(status: number): SpUIRepresentationX {
    return { identifier: "", words: [], icons: [], descriptions: [], ruleIndexs: [], status: status }
  }

  public mergeSpUIList2Table(sp1: SpUIRepresentationX[], sp2: SpUIRepresentationX[]) {
    var mergeSpUIs: SpUIRepresentationXPair[] = [];
    for (let sh of this.SPS_SHARE) {
      mergeSpUIs.push({ left: sh, right: sh });
    }
    for (let i = 0, j = 0; ;) {
      var spLeft: SpUIRepresentationX = null;
      var spRight: SpUIRepresentationX = null;
      if (i < sp1.length) spLeft = sp1[i];
      if (j < sp2.length) spRight = sp2[j];
      var spPair: SpUIRepresentationXPair = { left: null, right: null };
      if (spLeft != null && spRight != null) {
        // below is for when we do fine-grained spdiff
        // // final check for identical triggers
        // if (spLeft.descriptions[0] === spRight.descriptions[0]) {
        //   if (spLeft.statuses[0] != 0) {
        //     spLeft.statuses[0] = 0;
        //   } else if (spRight.statuses[0] != 0) {
        //     spRight.statuses[0] = 0;
        //   }
        // }
        // // final check for identical actions
        // if (spLeft.descriptions[2] === spRight.descriptions[2]) {
        //   if (spLeft.statuses[2] != 0) {
        //     spLeft.statuses[2] = 0;
        //   } else if (spRight.statuses[2] != 0) {
        //     spRight.statuses[2] = 0;
        //   }
        // }

        //process left only
        if (spLeft.status == -1) {
          spPair.left = spLeft;
          spPair.right = this.getSpUIPlaceholder(102);
          i++;
        }
        //process right only
        else if (spRight.status == 1) {
          spPair.left = this.getSpUIPlaceholder(101);
          spPair.right = spRight;
          j++;
        }
        //process left right same.
        else if (spLeft.status == 0 && spRight.status == 0) {
          spPair.left = spLeft;
          spPair.right = spRight;
          i++; j++;
        }
        //process left right modify
        else if (spLeft.status == 21 && spRight.status == 22) {
          spPair.left = spLeft;
          spPair.right = spRight;
          i++; j++;
        }
        else {
          console.error("# Left and right status is unexpected.", JSON.stringify(spLeft), JSON.stringify(spRight));
          console.error("# current mergeRuleUIs:", mergeSpUIs);
          alert("# Bug");
          return null;
        }
        mergeSpUIs.push(spPair);
      }
      else if (spLeft != null && spRight == null) {
        if (spLeft.status == -1) {
          spPair.left = spLeft;
          spPair.right = this.getSpUIPlaceholder(102);
          i++;
        }
        else {
          console.error("# Left can only have status -1! ", spLeft);
          console.error("# current mergeRuleUIs:", mergeSpUIs);
          alert("# Bug");
          return null;
        }
        mergeSpUIs.push(spPair);
      }
      else if (spLeft == null && spRight != null) {
        if (spRight.status == 1) {
          spPair.left = this.getSpUIPlaceholder(101);
          spPair.right = spRight;
          j++;
        }
        else {
          console.error("# Right can only have status 1! ", spRight);
          console.error("# current mergeRuleUIs:", mergeSpUIs);
          alert("# Bug");
          return null;
        }
        mergeSpUIs.push(spPair);
      }
      else {
        break;
      }
    }

    return mergeSpUIs;
  }

  ngOnInit() {
    //init style params
    const queryParams = this.router.snapshot.queryParamMap["params"];
    for (let key in queryParams) this.urlParams[key] = queryParams[key];

    this.userDataService.getCsrfCookie().subscribe(dataCookie => {
      this.router.params.subscribe(params => {
        // then get hashed_id and task_id from router params
        if (!this.userDataService.user_id) {
          this.userDataService.mode = "sp";
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
              this.updateDiff(null);
            }
          })
      })
    });
  }

  public dropdownValue(i: number): String {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams);
  }

  public getShortProgramName(i: number): string {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams).split("(")[0].trim();
  }

  public updateFilteredSpsTable() {
    this.FILTERED_SPS_1 = this.SPS_1;
    this.FILTERED_SPS_2 = this.SPS_2;
    if (this.DEVICE_FILTER != this.DEVICE_ANY_CONST) {
      this.FILTERED_SPS_1 = [];
      this.FILTERED_SPS_2 = [];
      for (let sp of this.SPS_1) {
        for (let desp of sp.descriptions) {
          if (DiffcomService.getDeviceFromDescription(desp) == this.DEVICE_FILTER) {
            this.FILTERED_SPS_1.push(sp);
            break;
          }
        }
      }
      for (let sp of this.SPS_2) {
        for (let desp of sp.descriptions) {
          if (DiffcomService.getDeviceFromDescription(desp) == this.DEVICE_FILTER) {
            this.FILTERED_SPS_2.push(sp);
            break;
          }
        }
      }
    }
    this.SPS_TABLE = this.mergeSpUIList2Table(this.FILTERED_SPS_1, this.FILTERED_SPS_2);
  }

  public updateDiff($event: EventEmitter<MatSelectChange>) {
    function getSpsDevices(sps: SpUIRepresentationX[]): string[] {
      var devs = [];
      for (let sp of sps) {
        for (let desp of sp.descriptions) {
          let dev = DiffcomService.getDeviceFromDescription(desp);
          if (dev != '(not)') devs.push(dev);
        }
      }
      return [...new Set(devs)];
    }
    let thisObj = this;
    function updateCurrentSpsDevices() {
      let devl1 = getSpsDevices(thisObj.SPS_1);
      let devl2 = getSpsDevices(thisObj.SPS_2); //Notice: device filter only support diff sp now.
      thisObj.SPS_DEVICES = [...new Set(devl1.concat(devl2))];
      thisObj.DEVICE_FILTER = thisObj.DEVICE_ANY_CONST;
    }

    function updateIdentifiersByRules() {
      if (thisObj.urlParams['sp-id-enable'] != 'true') {
        return;
      }
      function setOnesideIdentifiers( // assign sp labels to the corresponding rules
        sps: SpUIRepresentationX[], idDict: { [id: number]: string[] }, idxName: string = "ruleIndexs") {
        for (let sp of sps) {
          if (!sp.identifier) {
            console.warn("# sp doesn't have identifier!", JSON.stringify(sp));
            continue;
          }
          for (let ruleIndex of sp[idxName]) { // ruleIndex refers to the original rule order
            if (!idDict[ruleIndex])
              idDict[ruleIndex] = [sp.identifier];
            else
              idDict[ruleIndex].push(sp.identifier);
          }
        }
      }
      for (let ruleIndex in thisObj.SP_IDENTIFIER_BY_RULES1) delete thisObj.SP_IDENTIFIER_BY_RULES1[ruleIndex];
      for (let ruleIndex in thisObj.SP_IDENTIFIER_BY_RULES2) delete thisObj.SP_IDENTIFIER_BY_RULES2[ruleIndex];
      setOnesideIdentifiers(thisObj.SPS_1, thisObj.SP_IDENTIFIER_BY_RULES1);
      setOnesideIdentifiers(thisObj.SPS_2, thisObj.SP_IDENTIFIER_BY_RULES2);
      setOnesideIdentifiers(thisObj.SPS_SHARE, thisObj.SP_IDENTIFIER_BY_RULES1, "ruleIndexs");
      setOnesideIdentifiers(thisObj.SPS_SHARE, thisObj.SP_IDENTIFIER_BY_RULES2, "ruleIndexs2");
    }

    this.isError = false;
    this.isSpsShareVisible = true;
    //invalid rightside return.
    if (this.VERSION_2 == null || this.VERSION_2 < 0) return;

    const key: string = this.VERSION_1 + "+" + this.VERSION_2;
    if (this.cache[key]) {
      this.setLoading();
      setTimeout(() => {
        this.SPS_1 = this.cache[key][0];
        this.SPS_2 = this.cache[key][1];
        this.SPS_SHARE = this.cache[key][2];
        updateCurrentSpsDevices();
        updateIdentifiersByRules();
        this.updateFilteredSpsTable();
        this.setLoadingDone();
      }, 500);

    } else {
      this.setLoading();
      this.userDataService.compareRules(this.userDataService.hashed_id, 'sp', this.VERSION_1, this.VERSION_2)
        .subscribe(data => {
          this.unparsedSps = data['diff'];
          if (this.unparsedSps) {
            this.parseSps(); // this assigns this.SPS_1 & 2
            updateCurrentSpsDevices();
            updateIdentifiersByRules();
            this.updateFilteredSpsTable();
            const val: SpUIRepresentationX[][] = [];
            val.push(this.SPS_1);
            val.push(this.SPS_2);
            val.push(this.SPS_SHARE);
            this.cache[key] = val;
          }
          else {
            this.isError = true;
          }
          this.setLoadingDone();
        });
    }

    this.bothPrgmsAreSame();
    this.checkDROPDOWN_CLICKED();
  }

  public setLoading() {
    this.SPS_1 = [];
    this.SPS_2 = [];
    this.SPS_SHARE = [];
    this.SPS_TABLE = [];
    this.isLoading = true;
  }

  public setLoadingDone() {
    this.isLoading = false;
  }

  public tooltipEnabled() {
    if (this.urlParams['sdiff-enable'] == 'true') return false;
    return true;
  }

  public anyProperties(sps: SpUIRepresentationX[]) {
    for (let sp of sps) {
      if (sp.words.length > 0) return true;
    }
    for (let shsp of this.SPS_SHARE) {
      if (shsp.words.length > 0) return true;
    }
    return false;
  }


  private parseProgramSps(sps: any[], partName: string) {
    let prgm1_sps = null;
    let prgm2_sps = null;
    if (partName == 'SPS_1') {
      prgm1_sps = sps[0];
      prgm2_sps = sps[1];
    }
    else if (partName == 'SPS_2') {
      prgm1_sps = sps[1];
      prgm2_sps = sps[0];
    }
    else if (partName == 'SPS_SHARE') {
      prgm1_sps = sps[2];
      prgm2_sps = [];
      if (!prgm1_sps) prgm1_sps = [];
    }
    else {
      console.error(
        "# parseProgramSps meet unexpected partName:",
        partName, " Should be SPS_1, SPS_2 or SPS_SHARE");
      alert("Error in parseProgramSps.");
      return [];
    }

    function getSpIdentifier(idx: number) {
      let prefix = "";
      if (partName == "SPS_1") prefix = "L";
      else if (partName == "SPS_2") prefix = "R";
      else if (partName == "SPS_SHARE") prefix = "S";
      else prefix = "[ERROR]";
      let identifier = prefix + (idx + 1).toString();
      return identifier;
    }

    function showClause(c: string): string {
      return UserDataService.staticShowClause(c).replace('above', 'ABOVE').replace('below', 'BELOW');
    }

    function manualSingularToInfinitive(text: string): string[] {
      // From 3rd person singular to inifinitive,
      // this fn doesn't take into account -es endings (ex. "watches") in case of verbs like "closes"
      // but the current user study doesn't need it
      // It covers cases used in the user study in an adhoc way.
      var triggerClauseArr: string[] = text.split(' ');
      var sing_verb: string = '';
      var inf_verb: string = '';

      // "curtains close" vs. "stops recording"
      if (triggerClauseArr.includes('curtains')) {
        sing_verb = triggerClauseArr[triggerClauseArr.length - 1]; // curtains open/close
        inf_verb = sing_verb; // open/close
        return [sing_verb, inf_verb];
      }

      if (triggerClauseArr[triggerClauseArr.length - 2].endsWith('ies')) { // 2nd-to-last word
        sing_verb = triggerClauseArr[triggerClauseArr.length - 2];
        inf_verb = sing_verb.slice(0, -3) + 'y';
      } else if (triggerClauseArr[triggerClauseArr.length - 2].endsWith('s')) { // 2nd-to-last word
        sing_verb = triggerClauseArr[triggerClauseArr.length - 2];
        inf_verb = sing_verb.slice(0, -1);
      } else if (triggerClauseArr[triggerClauseArr.length - 1].endsWith('ies')) { // 2nd-to-last word
        sing_verb = triggerClauseArr[triggerClauseArr.length - 1];
        inf_verb = sing_verb.slice(0, -3) + 'y';
      } else if (triggerClauseArr[triggerClauseArr.length - 1].endsWith('s')) { // 2nd-to-last word
        sing_verb = triggerClauseArr[triggerClauseArr.length - 1];
        inf_verb = sing_verb.slice(0, -1);
      } else {
        alert('what verb is this');
        alert(triggerClauseArr);
      }
      return [sing_verb, inf_verb];
    }

    const states_never = [];
    const states_always = [];

    function parseSp(spTuple: any[]): SpUIRepresentationX {
      const sp = spTuple[0];
      const ruleIndexs = spTuple[1];
      const ruleIndexs2 = spTuple[2]; // might not exist.

      const words = [];
      const descriptions = [];
      const icons = [];

      // if Sp1
      if (sp.thisState) {
        descriptions.push('');
        icons.push('');
        words.push('The smart home will ');

        descriptions.push(sp.compatibility ? "always" : "never");
        icons.push(sp.compatibility ? "done" : "block");
        words.push(' have');

        var first = showClause(sp.thisState[0].text).replace(" is ", " being ").replace(" are ", " being ").replace(" is at ", " at ");
        descriptions.push(first);
        icons.push(sp.thisState[0].channel.icon);
        for (let i = 0; i < sp.thatState.length; i++) {
          words.push("and");
          var next = showClause(sp.thatState[i].text).replace(" is ", " being ").replace(" are ", " being ").replace(" is at ", " at ");
          descriptions.push(next);
          icons.push(sp.thatState[i].channel.icon);
        }
        var moreword: string = sp.thatState.length == 0 ? '' : 'together at the same time';
        words.push(moreword);
      }
      // if Sp2
      else if (sp.stateClause) {
        var tobe = '';
        if (sp.stateClause[0].text.includes(' is ')) {
          tobe = ' is ';
        } else if (sp.stateClause[0].text.includes(' am ')) {
          tobe = ' am ';
        } else if (sp.stateClause[0].text.includes(' are ')) {
          tobe = ' are ';
        }
        var first_state_dev: string = sp.stateClause[0].text.split(tobe)[0];
        var first_state_val: string = sp.stateClause[0].text.split(tobe)[1];
        descriptions.push(first_state_dev);
        icons.push(sp.stateClause[0].channel.icon);
        words.push(' will ');
        descriptions.push(sp.compatibility ? "always" : "never");
        icons.push(sp.compatibility ? "done" : "block");
        words.push(' be ');
        descriptions.push(showClause(first_state_val));
        icons.push(sp.stateClause[0].channel.icon);
        if (sp.time) {
          words.push("happen for");
          icons.push("access_time");
          var description = "more than ";
          if (sp.time.hours > 0) { description += (sp.time.hours + "h "); }
          if (sp.time.minutes > 0) { description += (sp.time.minutes + "m "); }
          if (sp.time.seconds > 0) { description += (sp.time.seconds + "s "); }
          descriptions.push(description);
        } else {
          const state_never_or_always: SpUIRepresentationX = {
            identifier: "",
            words: words,
            icons: icons,
            descriptions: descriptions,
            ruleIndexs: ruleIndexs,
            status: sp.status
          };
          sp.compatibility ? states_always.push(state_never_or_always) : states_never.push(state_never_or_always);
        }
        for (let i = 0; i < sp.alsoClauses.length; i++) {
          if (i == 0) {
            if (words[words.length - 1] == "happen") { words[words.length - 1] += " while"; }
            else { words.push("while") }
          }
          else { words.push("and"); }
          icons.push(sp.alsoClauses[i].channel.icon);
          descriptions.push(showClause(sp.alsoClauses[i].text));
        }

      }
      // if Sp3
      else if (sp.triggerClause) {
        // Verbs... this is kinda risky tbh... 
        // It assumes that 1. all subjs are singular; 2. verb ends with "s" or "ies"; 3. verb is last or 2nd-to-last word of clause
        var triggerText: string = showClause(sp.triggerClause[0].text);
        var verbs: string[] = manualSingularToInfinitive(triggerText);
        descriptions.push(triggerText.split(verbs[0])[0]);
        icons.push(sp.triggerClause[0].channel.icon);
        words.push("will");

        // "only" instead of "always" because of logic for events in English
        descriptions.push(sp.compatibility ? "only" : "never");
        icons.push(sp.compatibility ? "done" : "block");
        words.push('');

        descriptions.push(verbs[1] + (triggerText.split(verbs[0]).length > 1 ? triggerText.split(verbs[0])[1] : ''));
        icons.push(sp.triggerClause[0].channel.icon);
        // words.push("happen");
        words.push('');
        if (!sp.afterTime) {
          for (let i = 0; i < sp.otherClauses.length; i++) {
            if (i == 0) { words[words.length - 1] += " while"; }
            else { words.push("and"); }
            icons.push(sp.otherClauses[i].channel.icon);
            descriptions.push(showClause(sp.otherClauses[i].text));
          }
        } else {
          var description = "within ";
          icons.push("access_time");
          if (sp.afterTime.hours > 0) { description += (sp.afterTime.hours + "h "); }
          if (sp.afterTime.minutes > 0) { description += (sp.afterTime.minutes + "m "); }
          if (sp.afterTime.seconds > 0) { description += (sp.afterTime.seconds + "s "); }
          descriptions.push(description);
          words.push("after");
          icons.push(sp.otherClauses[0].channel.icon);
          descriptions.push(showClause(sp.otherClauses[0].text));

        }
        words.push("");
      }

      let spRep: SpUIRepresentationX = {
        identifier: "",
        words: words,
        icons: icons,
        descriptions: descriptions,
        ruleIndexs: ruleIndexs,
        status: sp.status
      };
      if (ruleIndexs2) {
        spRep.ruleIndexs2 = ruleIndexs2;
      }
      return spRep;
    }

    //delete the old placeholder way.
    var parsedSps: SpUIRepresentationX[] = prgm1_sps.map(parseSp);
    if (parsedSps == null) parsedSps = [];
    if (this.urlParams['sp-id-enable'] == 'true') {
      for (let i = 0; i < parsedSps.length; i++) {
        parsedSps[i].identifier = getSpIdentifier(i);
      }
    }
    return parsedSps;
  }


  private parseSps() {
    const sps = this.unparsedSps;
    this.SPS_1 = this.parseProgramSps(sps, 'SPS_1');
    this.SPS_2 = this.parseProgramSps(sps, 'SPS_2');
    this.SPS_SHARE = this.parseProgramSps(sps, 'SPS_SHARE');
  }

  public spsShareExpand() {
    if (!this.isSpsShareVisible)
      this.isSpsShareVisible = true;
    else
      this.isSpsShareVisible = false;
  }

  public saveProgram() {
    alert('saving ' + this.DESIREDPROGRAM);
  }

  public openHelp() {
    let dialogRef = this.dialog.open(HelpInfoDialogCommonComponent, {
      data: { preset: "spdiff" }
    });
  }

  public bothPrgmsAreSame() {
    if (this.VERSION_1 == this.VERSION_2) {
      let dialogRef = this.dialog.open(HelpInfoDialogCommonComponent, {
        data: { preset: "bothPrgmsAreSame" }
      });
    }
  }

  public setReady() {
    this.READY = true;
  }

  public prgmNumsDefined() {
    this.PRGMNUMSDEFINED = true;
  }

  private checkDROPDOWN_CLICKED() {
    if (this.urlParams['tutorial'] == 'true') {
      if (this.VERSION_2 == this.PROGRAMNUMS[1]) {
        this.DROPDOWN_CLICKED = true;
      } else {
        this.DROPDOWN_CLICKED = false;
      }
    }
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
              intro: "To complete this task, you need to compare the Original Program with Programs #1 and #2.<br><br>First, <span style='font-weight:bold'>use this dropdown menu to select Program #1.</span>"
            }
          ]
        });
        introJS2.start();
      }, 500);
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
              intro: "<span style='font-weight:bold'>This interface does not show the programs, but instead gives you information about them.<br><br>Specifically, it shows <span style='color:rgb(0, 153, 255)'>how the two programs cause the smart home to have different patterns of behavior.</span></span><br><br>Let’s take a closer look at what that means."
            },
            {
              element: "spkey",
              intro: "We will consider a \"pattern\" to be <span style='color:rgb(0, 153, 255); font-weight:bold'>a statement about what will <span style='color:orange'>always/never</span> happen in the smart home.</span><br><br>For example, these are patterns:<br>* The lights will <span style='color:orange; font-weight:bold'>always</span> be on while it is nighttime and Alice is at home.<br>* The speakers will <span style='color:orange; font-weight:bold'>never</span> turn on while the TV is on."
            },
            {
              intro: "These patterns come from the rules themselves in the program. <span style='font-weight:bold'>A pattern can come from a single rule, or it can come from many rules!</span><br><br>For example, to make sure the HUE lights are <span style='color:orange; font-weight:bold'>always</span> on when Alice is home at night, the program needs at least 3 rules: <br>* If lights turn off while Alice is home at night then turn on the lights; <br>* If Alice comes home while it is nighttime then turn on the lights; <br>* If it becomes nighttime while Alice is home then turn on the lights."
            },
            {
              intro: "<span style='font-weight:bold'>Having lots of rules can make it hard to spot the general patterns they create, so <span style='color:rgb(0, 153, 255); font-weight:bold;'>this interface finds these patterns from the rules for you, and then compares them.</span>"
            },
            {
              element: '#entiresps',
              intro: 'This part shows the <span style="font-weight:bold">patterns</span> we found for each program. <span style="font-weight:bold">Note that these are <span style="font-style:italic">NOT</span> the rules in the program.</span><br><br>(If a program doesn’t cause any patterns in the smart home behavior, the interface will say so.)'
              //  By default it only shows the Original Program (which is on the left).
            },
            {
              element: document.querySelectorAll(".sp-blocks")[0],
              intro: '<span style="font-weight:bold">Each row is a pattern.</span><br><br>For example, with the Original Program, the smart home would have the pattern that the "HUE lights will always be on while it is nighttime and Alice is at home."'
            },
            {
              element: document.querySelectorAll(".sdiff-item")[0],
              intro: 'Program #1 also has this pattern.'
            },
            {
              element: document.querySelectorAll(".sdiff-item")[1],
              intro: 'However, Program #1 has another pattern that the Original Program does not: "The speakers will never turn on while the smart TV is on."'
            },
            {
              element: document.querySelectorAll(".add-rule-display")[0],
              intro: '<span style="font-weight:bold">If only one of the selected programs has this pattern, then it is bolded with a color background and a "-"/"+".</span><br><br>(Red and “-” on the left, green and “+” on the right. The red/green keys below the dropdown menus also explain this.)<br><br>Here, only the program on the right has this pattern.',
              position: 'left'
            },
            {
              intro: "By the way, here are some other examples of patterns you might encounter:<br>* The smart home will <span style='color:orange; font-weight:bold'>never</span> have the lights be on and the living room window curtains be open together at the same time.<br>* The lights will <span style='color:orange; font-weight:bold'>always</span> be on."
            },
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
      }, 1000);
    } else if (this.INTRO_DONE == 4 && this.userDataService.SUBMIT_ATTEMPT_CORRECT) {
      this.INTRO_DONE++;
      setTimeout(function () {
        var introJS_final = introJs();
        var answerExplanation: string = "Nice! Program 1 is correct because it meets the same goal as the Original Program does (keep lights on when Alice is at home at night) but also makes sure that the speakers never turn on when the TV is on.<br><br>Program #2 meets the former goal but not the latter, which makes it incorrect.";
        introJS_final.setOptions(thisObj.userDataService.getIntroJsOptionsFinal(answerExplanation));
        introJS_final.start();
      }
      );
    }
  }
}
