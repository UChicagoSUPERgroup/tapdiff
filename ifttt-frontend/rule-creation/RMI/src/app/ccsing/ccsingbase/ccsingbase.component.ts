import { Component, OnInit, EventEmitter } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { UserDataService, Rule } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { MatSelectChange } from '@angular/material/select';
import { RuleUIRepresentation, DiffcomService } from '../../diffcom.service';
import { HelpInfoDialogCommonComponent } from '../../help-info-dialog/help-info-dialog-common/help-info-dialog-common.component';

import * as introJs from 'intro.js/intro.js';

@Component({
  selector: 'app-ccsingbase',
  templateUrl: './ccsingbase.component.html',
  styleUrls: ['./ccsingbase.component.css']
})
export class CcsingbaseComponent implements OnInit {
  private unparsedRules: Rule[];
  public urlParams = {
    "dropdown-style": "none",
    "tutorial": "false"
  };

  public tutorialParams = {
    'showPrgmButton': 'false',
    'showSavePanel': 'false'
  }

  public isLoading: boolean = false;

  public PROGRAMS: { [id: number]: Rule[]; };
  public PROGRAM_VERSION: number;
  public PROGRAMNUMS: number[];
  public RULES: RuleUIRepresentation[];
  public RULEBLOCKS: RuleUIRepresentation[];
  public DESIREDPROGRAM: number; // the program that the user chooses at the end to save
  public READY: boolean = true;
  public PRGMNUMSDEFINED: boolean = false;

  private INTRO_DONE: number = 0;
  private DROPDOWN_CLICKED: boolean = false;
  private INTERVAL: number = 5;

  constructor(public dialog: MatDialog, public userDataService: UserDataService, private route: Router, private router: ActivatedRoute) {
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
            for (let progNum of this.PROGRAMNUMS) this.PROGRAMS[progNum] = data["programs"][progNum]["rules"];
            this.PROGRAM_VERSION = this.PROGRAMNUMS[0];
            this.userDataService.version = this.PROGRAM_VERSION;
            this.isLoading = true;
            this.userDataService.getRulesWithVersion(this.userDataService.hashed_id)
              .subscribe(data => {
                this.unparsedRules = data['rules'];
                if (this.unparsedRules) {
                  this.RULES = DiffcomService.parseRules3Columns(this.unparsedRules);
                }
                this.isLoading = false;
              });
            this.prgmNumsDefined();
            if (this.urlParams['tutorial'] == 'true') {
              setInterval(() => this.startIntroJS(), this.INTERVAL);
            }
          });
      });
    });
  }

  public dropdownValue(i: number): String {
    return DiffcomService.getProgramNameFromVersionId(i, this.urlParams);
  }

  public updateRules($event: EventEmitter<MatSelectChange>) {
    this.userDataService.version = this.PROGRAM_VERSION;
    this.isLoading = true;
    this.userDataService.getRulesWithVersion(this.userDataService.hashed_id)
      .subscribe(data => {
        this.unparsedRules = data['rules'];
        if (this.unparsedRules) {
          this.RULES = DiffcomService.parseRules3Columns(this.unparsedRules);
        }
        this.isLoading = false;
      }
      );
    this.checkDROPDOWN_CLICKED();
  }

  public showClause(c: string) {
    var new_c: string = c;
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

  public saveProgram() {
    alert('saving ' + this.DESIREDPROGRAM);
  }

  public openHelp() {
    let dialogRef = this.dialog.open(HelpInfoDialogCommonComponent, {
      data: { preset: "ccsing" }
    });
  }

  public setReady() {
    this.READY = true;
  }

  private prgmNumsDefined() {
    this.PRGMNUMSDEFINED = true;
  }

  private checkDROPDOWN_CLICKED() {
    if (this.urlParams['tutorial'] == 'true') {
      if (this.PROGRAM_VERSION == this.PROGRAMNUMS[1]) {
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
              intro: "<span style='font-weight:bold'>This interface shows the programs.</span>"
            },
            {
              element: '#rightdropdown',
              intro: "To complete this task, you need to compare the Original Program with Programs #1 and #2.<br><br><span style='font-weight:bold'>The dropdown menu here lets you choose which program to see.</span> By default it shows the Original Program."
            },
            {
              element: '#entireprgm',
              intro: 'The selected program appears here.'
            },
            {
              element: document.querySelectorAll(".rule-blocks")[0],
              intro: 'This top row shows that the rules in the program are laid out across 3 columns: "If", "while", and "then".'
            },
            {
              element: document.querySelectorAll(".rule-blocks")[1],
              intro: 'Below that, <span style="font-weight:bold">each row is a rule in the program</span>.<br><br>This is the only rule in the Original Program. It says "<span style="font-style:italic">If</span> Alice Enters Home <span style="font-style:italic">while</span> It is Nighttime <span style="font-style:italic">and</span> HUE Lights is Off <span style="font-style:italic">then</span> Turn HUE Lights On."'
            },
            {
              element: '#rightdropdown',
              intro: "Now let's look at Program #1. <span style='font-weight:bold'>Use this dropdown menu to select Program #1.</span>"
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
              element: '#prgmpart',
              intro: "Program #1 has two rules."
            },
            {
              element: document.querySelectorAll(".rule-blocks")[1],
              intro: 'The first rule is "<span style="font-style:italic">If</span> Alice Enters Home <span style="font-style:italic">while</span> HUE Lights is Off <span style="font-style:italic">then</span> Turn HUE Lights On."'
            },
            {
              element: document.querySelectorAll(".rule-blocks")[2],
              intro: 'The second rule is "<span style="font-style:italic">If</span> Smart TV turns On <span style="font-style:italic">while</span> Speakers is On <span style="font-style:italic">then</span> Turn Speakers Off."'
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
