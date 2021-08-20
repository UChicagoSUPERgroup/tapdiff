import { Component, OnInit, EventEmitter } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { UserDataService, Rule } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { MatSelectChange } from '@angular/material/select';
import { DiffcomService, RuleDiff, ChangedRuleUIRepresentation, ChangedRuleUIRepresentationPair } from '../../diffcom.service';

import { HelpInfoDialogCommonComponent } from '../../help-info-dialog/help-info-dialog-common/help-info-dialog-common.component';
import * as introJs from 'intro.js/intro.js';

@Component({
  selector: 'app-sdiffbase',
  templateUrl: './sdiffbase.component.html',
  styleUrls: ['./sdiffbase.component.css']
})
export class SdiffbaseComponent implements OnInit {
  private unparsedDiff: RuleDiff[][];
  public isLoading: boolean = false;
  public isError: boolean = false;
  public READY: boolean = true;
  public PRGMNUMSDEFINED: boolean = false;
  public urlParams = {
    "dropdown-style": "none",
    "dropdown-label": "false",
    "tutorial": "false"
  };

  public tutorialParams = {
    'showPrgmButton': 'false',
    'showSavePanel': 'false'
  }

  private INTRO_DONE: number = 0;
  private DROPDOWN_CLICKED: boolean = false;
  private INTERVAL: number = 5;

  public VERSION_1: number;
  public VERSION_2: number;
  public PROGRAMNUMS: number[];
  public PROGRAMS: { [id: number]: Rule[]; };
  public ALLRULES: ChangedRuleUIRepresentation[];
  public PROGRAM_1: ChangedRuleUIRepresentation[];
  public PROGRAM_2: ChangedRuleUIRepresentation[];
  public PROGRAM_TABLE: ChangedRuleUIRepresentationPair[];

  constructor(
    public dialog: MatDialog,
    public userDataService: UserDataService,
    private router: Router,
    private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
    //init style params
    const queryParams = this.activatedRoute.snapshot.queryParamMap["params"];
    for (let key in queryParams) this.urlParams[key] = queryParams[key];

    this.userDataService.getCsrfCookie().subscribe(dataCookie => {
      this.activatedRoute.params.subscribe(params => {
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

              //program for tally hover.
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

  public updateDiff($event: EventEmitter<MatSelectChange>) {
    this.setLoading();
    this.isError = false;
    this.userDataService.compareRules(this.userDataService.hashed_id, 'text', this.VERSION_1, this.VERSION_2)
      .subscribe(data => {
        this.unparsedDiff = [data['diff'][0], data['diff'][1]];
        if (this.unparsedDiff) {
          this.parseRuleDiffs();
        }
        else {
          this.isError = true;
        }
        this.setLoadingDone();
      }
      );
    this.bothPrgmsAreSame();
    this.checkDROPDOWN_CLICKED();
  }

  public setLoading() {
    this.PROGRAM_1 = [];
    this.PROGRAM_2 = [];
    this.ALLRULES = [];
    this.PROGRAM_TABLE = [];
    this.isLoading = true;
  }

  public setLoadingDone() {
    this.isLoading = false;
  }

  public showClause(c: string) {
    return this.userDataService.showClause(c);
  }

  private parseRuleDiffs() {
    // Plan for a rule in unparsedDiff to be:
    // {trigger:'If A', condition: ['while B', 'and C'], action: 'then D', 'changeStatus': -1/0/1/2,
    // 'channel':{'icon':XX}}
    // OR: set a new field of the clause dict to be the changeStatus: the first symbol of the ndiff()
    const diffRules = this.unparsedDiff;

    this.PROGRAM_1 = diffRules[0].map(DiffcomService.diffParserRuleUI);
    this.PROGRAM_2 = diffRules[1].map(DiffcomService.diffParserRuleUI);
    this.PROGRAM_TABLE = DiffcomService.mergeRuleUIList2Table(this.PROGRAM_1, this.PROGRAM_2, 'sdiff');
  }

  public openHelp() {
    let dialogRef = this.dialog.open(HelpInfoDialogCommonComponent, {
      data: { preset: "sdiff" }
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
              intro: "<span style='font-weight:bold'>This interface shows two programs side-by-side and highlights their differences.</span>"
            },
            {
              element: '#rightdropdown',
              intro: "To complete this task, you need to compare the Original Program with Programs #1 and #2.<br><br><span style='font-weight:bold'>The dropdown menu here lets you choose the program to compare.</span>"
            },
            {
              element: '#entireprgm',
              intro: 'The selected pair of programs appears here. By default it shows the Original Program on the left.'
            },
            {
              element: '#prgmkey',
              intro: 'This top row shows that the rules in each program are laid out across 3 columns: "If", "while", and "then".'
            },
            {
              element: document.querySelectorAll(".rule-blocks")[1],
              intro: 'Below that, <span style="font-weight:bold">each row is a rule in the program</span>.<br><br>For example, this is one of two rules in the Original Program. It says "<span style="font-style:italic">If</span> Alice Enters Home <span style="font-style:italic">while</span> It is Nighttime <span style="font-style:italic">and</span> HUE Lights is Off <span style="font-style:italic">then</span> Turn HUE Lights On."'
            },
            {
              element: '#rightdropdown',
              intro: "Now let's compare the Original Program with Program #1. <span style='font-weight:bold'>Use this dropdown menu to select Program #1.</span>"
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
              element: document.querySelectorAll(".add-rule-display")[0],
              intro: 'As another example, this is one of three rules in Program #1. It says "<span style="font-style:italic">If</span> Alice Enters Home <span style="font-style:italic">while</span> HUE Lights is Off <span style="font-style:italic">then</span> Turn HUE Lights On."'
            },
            {
              element: document.querySelectorAll(".sdiff-item")[1],
              intro: '<span style="font-weight:bold">If a rule is in one but not both of the selected programs, it is bolded with a red/green background and a "-"/"+" to its left.</span><br><br>Here, the rule on the right does not exist in the program on the left, so it has a green background and a "+" to its left.'
            },
            {
              element: document.querySelectorAll(".sdiff-item")[0],
              intro: 'On this row, neither rule is in both programs, but they are very similar to each other.<br><br>So, the rule on the left has a red background with "-", and the rule on the right has a green background with "+". The differences have a slightly darker background.'
              //  (in that only one column of text is different)
            },
            {
              element: document.querySelectorAll(".sdiff-item")[2],
              intro: 'The rule on both sides of this row are the same (i.e. it is in both programs), so it has a plain white background.'
            },
            {
              element: document.querySelectorAll(".row")[0],
              intro: '<span style="font-weight:bold">If you forget what the red/green colors or symbols mean, you can refer to the key below the program names (or dropdown menus).</span>'
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
      }, 1000);
    } else if (this.INTRO_DONE == 4 && this.userDataService.SUBMIT_ATTEMPT_CORRECT) {
      this.INTRO_DONE++;
      setTimeout(function () {
        var introJS_final = introJs();
        var answerExplanation:string = "Nice! Program 2 is correct because it does exactly what the Original Program does except it also turns off the speakers when the TV turns on.<br><br>Program #1 does the latter but not the former, which makes it incorrect.";
        introJS_final.setOptions(thisObj.userDataService.getIntroJsOptionsFinal(answerExplanation));
        introJS_final.start();
      }
      );
    }
  }
}
