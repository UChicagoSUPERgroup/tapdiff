import { Component, OnInit, Input, Output, ElementRef } from '@angular/core';
import { UserDataService } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { MatSelectChange } from '@angular/material/select';
import { Rule } from '../../user-data.service';
import { DiffcomService, RuleUIRepresentation } from '../../diffcom.service';
import { jsPanel } from 'jspanel4';
import { TASK_DETAIL_DICT } from './task-detail';
import { FormControl } from '@angular/forms';

@Component({
  selector: 'app-save-bar',
  templateUrl: './save-bar.component.html',
  styleUrls: ['./save-bar.component.css']
})
export class SaveBarComponent implements OnInit {
  public SCROLL_HINT_VISIBLE: boolean = false;
  //----------------------------------
  public SELECT_CATEGORY: number = -1;

  public CURRENT_TASK_ID: number = -1;

  public IS_SUBMITTING: boolean = false;

  public PROGRAM_SHOWN_ID: number;
  public PROGRAMS: { [id: number]: Rule[]; } = {};
  public PROGRAM_SHOWN: Rule[] = [];
  public VARIANT_WORD: string = 'Program';

  public ruleform = new FormControl('');
  // set program numbers
  @Input()
  set PROGRAMNUMS_SETTER(nums: number[]) {
    if (!nums) return;
    this.PROGRAMNUMS = DiffcomService.deepCopy(nums);
    for (let num of nums) {
      this.CHECK_PROGRAMS[num] = false;
    }
    //current_task_id is set here, it can make sure task_id is updated.
    this.CURRENT_TASK_ID = this.userDataService.task_id;
    // this.URL_PARAMS['save-style'] = this.TASK_SAVESTYLE[this.CURRENT_TASK_ID]; // TODO: not working
    this.userDataService.appendLog('>>>TASK ' + this.CURRENT_TASK_ID.toString());
  }

  @Input()
  set PROGRAMS_SETTER(prgms: { [id: number]: Rule[]; }) {
    if (!prgms) return;
    this.PROGRAMS = DiffcomService.deepCopy(prgms);
    this.userDataService.startTimer();
  }

  //special params (might control functionality)
  @Input()
  public SPECIAL_PARAMS: { [id: string]: any } = {};

  //url params (usually control style)
  @Input()
  public URL_PARAMS: { [id: string]: any } = {};

  public PROGRAMNUMS: number[];

  @Input()
  public SHOW_PRGMS_SUBMIT: boolean = false;

  @Output()
  public DESIREDPROGRAM: number = -1;

  @Output()
  public CHECK_PROGRAMS: { [id: number]: boolean } = {};

  public saveChecks() {
    let choices: string[] = [];
    if (this.URL_PARAMS["save-style"] == "selectfromtwo") {
      switch (this.SELECT_CATEGORY) {
        case 0: {
          choices.push('Both');
          // alert('both');
          break;
        }
        case 1: {
          choices.push('Only ' + this.VARIANT_WORD + ' 1');
          // alert('1');
          break;
        }
        case 2: {
          choices.push('Only ' + this.VARIANT_WORD + ' 2');
          // alert('2');
          break;
        };
        case 3: {
          // alert("neither");
          choices.push('Neither');
          break;
        }
      }
    } else if (this.URL_PARAMS["save-style"] == "yesorno") {
      if (this.SELECT_CATEGORY == 0) {
        choices.push('Yes');
        // alert('yes');
      } else if (this.SELECT_CATEGORY == 1) {
        choices.push('No');
        // alert("no");
      }
    } else {
      if (this.SELECT_CATEGORY == 0) {
        for (var key in this.CHECK_PROGRAMS) {
          if (this.CHECK_PROGRAMS[key] == true) {
            if (key == '0') {
              choices.push('Original Program');
            } else {
              choices.push(this.VARIANT_WORD + ' ' + key);
              // alert('option '+key);
            }
          }
        }
      } else if (this.SELECT_CATEGORY == 1) {
        choices.push('None of them');
      }
    }

    let confirmChoices: string = choices.join(', '); // '<span style="font-weight: bold; color:rgb(0, 153, 255)">'+choices.join(', ')+'</span>';
    // if(confirm("This is the answer you chose:\n\n\""+confirmChoices+"\"\n\nClick \"OK\" to submit your answer, else click \"Cancel\".")){
    let selVers = [];
    if (this.SELECT_CATEGORY == -1) {
      alert('You did not choose an answer. Please try again.');
      this.IS_SUBMITTING = false;
      return
    }
    if (this.URL_PARAMS["save-style"] == "selectfromtwo") {
      if (this.URL_PARAMS['tutorial'] == 'true') {
        if (this.CURRENT_TASK_ID == 887 || this.CURRENT_TASK_ID == 889) {
          if (this.SELECT_CATEGORY == 2) { // "Only Program 2" is correct
            this.userDataService.submitAttemptCorrect();
            return
          } else {
            if (this.SELECT_CATEGORY == 0) { // answered "both correct"--alert that 1 is incorrect
              alert("Your answer is incorrect. Recall that the correct program must do what the Original Program does except it also turns off the speakers if the TV turns on. Please try again.");
            } else if (this.SELECT_CATEGORY == 1) { // alert that 1 is incorrect
              alert("Your answer is incorrect. Recall that the correct program must do what the Original Program does except it also turns off the speakers if the TV turns on. Please try again.");
            } else if (this.SELECT_CATEGORY == 3) { // answered "both incorrect"--alert that 2 is correct
              alert("Your answer is incorrect. Recall that the correct program must do what the Original Program does except it also turns off the speakers if the TV turns on. Please try again.");
            }
            return
          }
        } else if (this.CURRENT_TASK_ID == 885) { // spdiff, 1 is correct
          if (this.SELECT_CATEGORY == 1) { // "Only Program 1" is correct
            this.userDataService.submitAttemptCorrect();
            return
          } else {
            if (this.SELECT_CATEGORY == 0) { // answered "both correct"--alert that 2 is incorrect
              alert("Your answer is incorrect. Recall that the correct program must make sure the speakers never turn on when the TV is on. Please try again.");
            } else if (this.SELECT_CATEGORY == 2) { // alert that 2 is incorrect
              alert("Your answer is incorrect. Recall that the correct program must make sure the speakers never turn on when the TV is on. Please try again.");
            } else if (this.SELECT_CATEGORY == 3) { // answered "both incorrect"--alert that 1 is correct
              alert("Your answer is incorrect. Recall that the correct program must meet the same goal as the Original Program (even if the smart home behavior ends up being different), and it also needs to make sure the speakers never turn on when the TV is on. Please try again.");
            }
            return
          }
          // } else if (this.CURRENT_TASK_ID == 886) { // old qdiff, both are correct
          //   if (this.SELECT_CATEGORY == 0) { // "both"
          //     this.userDataService.submitAttemptCorrect();
          //     return
          //   } else {
          //     if (this.SELECT_CATEGORY == 1) { // answered "both correct"--alert that 2 is also correct
          //       alert("Your answer is incorrect. Recall that Alice doesn't care what the correct program does except that the lights turn on when she comes home at night, and that the speakers turn off when the TV turns on. Please try again.");
          //     } else if (this.SELECT_CATEGORY == 2) { // alert that 1 is also correct
          //       alert("Your answer is incorrect. Recall that Alice doesn't care what the correct program does except that the lights turn on when she comes home at night, and that the speakers turn off when the TV turns on. Please try again.");
          //       // alert("Your answer is incorrect. Recall that the correct program must make sure to keep the speakers off when the TV is on. Please try again.");
          //     } else if (this.SELECT_CATEGORY == 3) { // answered "both incorrect"--alert that both are correct
          //       alert("Your answer is incorrect. Recall that Alice doesn't care what the correct program does except that the lights turn on when she comes home at night, and that the speakers turn off when the TV turns on. Please try again.");
          //     }
          //     return
          //   }
        }
      }
      switch (this.SELECT_CATEGORY) {
        case 0: {
          selVers.push("1");
          selVers.push("2");
          // alert('both');
          break;
        }
        case 1: {
          selVers.push("1");
          // alert('1');
          break;
        }
        case 2: {
          selVers.push("2");
          // alert('2');
          break;
        };
        case 3: {
          // alert("neither");
          break;
        }
      }
    } else if (this.URL_PARAMS["save-style"] == "yesorno") {
      if (this.SELECT_CATEGORY == 0) {
        selVers.push("1");
        // alert('yes');
      } else if (this.SELECT_CATEGORY == 1) {
        selVers.push("-1");
        // alert("no");
      }
    } else {
      if (this.URL_PARAMS['tutorial'] == 'true' && this.CURRENT_TASK_ID == 881) { // current qdiff/mcdiff, 3 & 4 are correct
        if (this.SELECT_CATEGORY != 0) { // "none"
          alert("Your answer is incorrect. There are programs that achieve an acceptable outcome for all situations.");
        } else {
          if (this.CHECK_PROGRAMS[1] && !this.CHECK_PROGRAMS[2] && this.CHECK_PROGRAMS[3] && !this.CHECK_PROGRAMS[4]) {
            this.userDataService.submitAttemptCorrect();
            return
          } else {
            alert("Your answer is incorrect. Double-check the \"Based on your response...\" part to make sure that you've selected the correct programs.");
          }
        }
        return
      }
      if (this.SELECT_CATEGORY == 0) {
        for (var key in this.CHECK_PROGRAMS) {
          if (this.CHECK_PROGRAMS[key] == true) {
            selVers.push(key);
            // alert('option '+key);
          }
        }
        if (selVers.length == 0) {
          let alertstr: string = 'You chose "At least one ' + this.VARIANT_WORD.toLowerCase() + '" but did not choose any programs. Please try again.';
          alert(alertstr);
          this.IS_SUBMITTING = false;
          return
        }
      }
    }
    this.IS_SUBMITTING = true;
    this.userDataService.saveSelVers(selVers).subscribe(
      succeed => {
        this.IS_SUBMITTING = false;
        this.route.navigate(['/finishpage/']);
      },
      failed => {
        alert("Your submission was not successful. Please try again. If it continues to fail, please let the researchers know.");
        this.IS_SUBMITTING = false;
      }
    );

  }

  public getOptionName(i: number): string {
    return DiffcomService.getProgramNameFromVersionId(i, this.URL_PARAMS);
  }

  public goToPageBottom() {
    var pageHeight = Math.max(document.body.clientHeight, document.body.scrollHeight);
    var pageYOffset = window.pageYOffset;
    var viewportHeight = window.innerHeight;
    let deltaY = pageHeight - (pageYOffset + viewportHeight);
    window.scrollBy(0, deltaY);
  }

  public openTaskPanel() {
    this.userDataService.recordFirstTaskInstrClick();
    this.userDataService.countOpenTaskInstr();
    let taskContent: string = "";
    let stid = this.CURRENT_TASK_ID.toString();
    
    if (stid in TASK_DETAIL_DICT) {
      taskContent = TASK_DETAIL_DICT[stid];
    }
    else {
      taskContent = TASK_DETAIL_DICT['-1'];
    }

    let thisObj = this;
    jsPanel.create({
      theme: 'primary',
      headerTitle: 'Task Instructions',
      position: 'center-top 0 58',
      contentSize: '500 550',
      content: "<div style='font-size:1.1vw; text-align: justify; line-height: 1.5'>" + taskContent + "</div>",
      footerToolbar: '<span style="flex:1 1 auto; height: 20px; text-align:center; color:gray">You can move this window by dragging here or the top</span>',
      callback: function () {
        this.content.style.padding = '20px';
      },
      onclosed: function () {
        thisObj.userDataService.countCloseTaskInstr();
      }
    });
  }

  public updateProgramShown($event) {
    this.PROGRAM_SHOWN = this.PROGRAMS[this.PROGRAM_SHOWN_ID];
    this.openPrgmPanel();
    this.PROGRAM_SHOWN_ID = undefined;
    this.ruleform.setValue(undefined);
  }

  private showClause(c: string) {
    return this.userDataService.showClause(c);
  }

  private constructPrgmContent() { // TODO: make dict for caching
    var prgmContent: string[] = ['<span style="font-weight: bold; font-size:24px">' + this.getOptionName(this.PROGRAM_SHOWN_ID) + '</span>'];
    let ruleReps = DiffcomService.parseRules(this.PROGRAM_SHOWN);
    for (let ruleI in ruleReps) {
      let ruleContent: string[] = [];
      let ruleRep = ruleReps[ruleI];
      // ruleContent.push(' - '); // (+ruleI+1).toString()+'.');Option #

      for (let i in ruleRep.words) {
        ruleContent.push((['If', ''].includes(ruleRep.words[i]) ? '' : '<br>') + '<span style="font-weight: bold; color:rgb(0, 153, 255)">' + ruleRep.words[i] + '</span>');
        ruleContent.push(this.showClause(ruleRep.descriptions[i]));
      }
      let rule = ruleContent.join(' ');
      prgmContent.push(rule + '.');
    }
    return prgmContent.join('<br><br>');
  }

  public openPrgmPanel() {
    if (this.PROGRAM_SHOWN_ID != -2) {
      let prgmContent: string = this.constructPrgmContent();
      let prgmid = this.PROGRAM_SHOWN_ID.toString();

      jsPanel.create({
        theme: 'primary',
        headerTitle: this.getOptionName(this.PROGRAM_SHOWN_ID),
        position: 'center-top 0 58',
        contentSize: '500 550',
        content: "<div style='font-size:1.1vw; text-align: justify; line-height: 1.5'>" + prgmContent + "</div>",
        footerToolbar: '<span style="flex:1 1 auto; height: 20px; text-align:center; color:gray">You can drag the window here or at the top</span>',
        callback: function () {
          this.content.style.padding = '20px';
        },
      });
      this.userDataService.appendLog('>>>TASK ' + this.CURRENT_TASK_ID.toString() + ' - ' + this.getOptionName(this.PROGRAM_SHOWN_ID));
    }
  }

  constructor(public userDataService: UserDataService, private route: Router, private element: ElementRef) { }

  ngOnInit() {
    let anchor = document.getElementById("scroll-anchor");
    function checkScrollBottomConstructor(currentThis: any) {
      //for force evaluation of "this" and build clousure.
      let thisObj = currentThis;
      function checkScrollBottom() {
        var pageYOffset = window.pageYOffset;
        var viewportHeight = window.innerHeight;
        let viewBottomOffset = pageYOffset + viewportHeight;
        let attentionHeight = 0;
        if (anchor.className.indexOf("use-scroll-height") < 0) {
          attentionHeight = anchor.offsetTop;
        }
        else {
          attentionHeight = document.body.scrollHeight;
        }

        if (viewBottomOffset > attentionHeight - 20) {
          //should hide scroll hint
          thisObj.SCROLL_HINT_VISIBLE = false;
        }
        else {
          //should show scroll hint
          thisObj.SCROLL_HINT_VISIBLE = true;
        };
      }
      return checkScrollBottom;
    }

    if (anchor) {
      let f = checkScrollBottomConstructor(this);
      window.addEventListener("resize", f, false);
      window.addEventListener("scroll", f, false);
      setInterval(f, 500);
    }
    else {
      // console.log("# no scroll-anchor found on page. will not add scroll hint.");
    }

  }

}
