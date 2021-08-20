import { Component, OnInit, Input } from '@angular/core';

import { UserDataService } from '../../user-data.service';
import { DiffcomService, ClauseDiff, RuleDiff, ChangedRuleUIRepresentation, ChangedRuleUIRepresentationPair } from '../../diffcom.service';


@Component({
  selector: 'app-splitdiff-view',
  templateUrl: './splitdiff-view.component.html',
  styleUrls: ['./splitdiff-view.component.css']
})
export class SplitdiffViewComponent implements OnInit {
  private unparsedDiff: RuleDiff[][];
  public isLoading: boolean = false;
  public isError: boolean = false;
  public PROGRAM_2_ORIG_ORDER: number[]; // index = current rule order, elt = old rule order

  @Input()
  set VERSION_LEFT(val:number){
    this.VERSION_FIRST = val;
    this.updateView();
  }
  
  @Input()
  set VERSION_RIGHT(val:number){
    this.VERSION_SECOND = val;
    this.updateView();
  }

  @Input()
  public IDENTIFIERS_BY_RULES_LEFT: {[id:number]: string[]} = {};

  @Input()
  public IDENTIFIERS_BY_RULES_RIGHT: {[id:number]: string[]} = {};
    

  public VERSION_FIRST: number = -1;
  public VERSION_SECOND: number = -1;
  public LAST_VERSION_FIRST: number = -1;
  public LAST_VERSION_SECOND: number = -1;

  public ALLRULES: ChangedRuleUIRepresentation[];
  public PROGRAM_1: ChangedRuleUIRepresentation[];
  public PROGRAM_2: ChangedRuleUIRepresentation[];
  public PROGRAM_TABLE: ChangedRuleUIRepresentationPair[];

  public updateView(){
    console.log("# splitdiff-view.updateView called:", this.VERSION_FIRST, this.VERSION_SECOND);
    if(this.VERSION_FIRST >= 0 && this.VERSION_SECOND >= 0){
      if(this.VERSION_FIRST != this.LAST_VERSION_FIRST || this.VERSION_SECOND != this.LAST_VERSION_SECOND)
      {
         this.getUpdateDiff();
      }
      this.LAST_VERSION_FIRST = this.VERSION_FIRST;
      this.LAST_VERSION_SECOND = this.VERSION_SECOND;
    }
  }

  /* ----below: copied from sdiffbase.component.ts ----*/
  /* ----below: copied from sdiffbase.component.ts ----*/
  /* ----below: copied from sdiffbase.component.ts ----*/
  private getUpdateDiff() {
    this.setLoading();
    this.isError = false;
    this.userDataService.compareRules(this.userDataService.hashed_id, 'text', this.VERSION_FIRST, this.VERSION_SECOND)
      .subscribe(data => {
        this.unparsedDiff = [data['diff'][0], data['diff'][1]];
        this.PROGRAM_2_ORIG_ORDER = data['diff'][2];
        if (this.unparsedDiff) {
          this.parseRuleDiffs();
        }
        else{
          this.isError = true;
        }
        this.setLoadingDone();
      }
      );
  }

  public setLoading(){
    this.PROGRAM_1 = [];
    this.PROGRAM_2 = [];
    this.ALLRULES = [];
    this.PROGRAM_TABLE = [];
    this.isLoading = true;
  }

  public setLoadingDone(){
    this.isLoading = false;
  }

  private parseRuleDiffs() {
    console.log("# splitdiff-view.parseRuleDiffs called.");
    const diffRules = this.unparsedDiff;
    // this.ALLRULES = diffRules.map(DiffcomService.diffParserRuleUI);
    this.PROGRAM_1 = diffRules[0].map(DiffcomService.diffParserRuleUI);
    this.PROGRAM_2 = diffRules[1].map(DiffcomService.diffParserRuleUI);
    this.updateRulesSpIdentifiers();
    this.PROGRAM_TABLE = DiffcomService.mergeRuleUIList2Table(this.PROGRAM_1, this.PROGRAM_2, 'sdiff');
  }

  private updateRulesSpIdentifiers(){
    function spidsUpd(program: ChangedRuleUIRepresentation[], spIds:{[id:number]: string[]}){
      for(let rule of program){
        delete rule['spIdentifiers'];
      }
      for(let ruleIdx in spIds){
        if(!program[ruleIdx]){
          console.warn("# updateRulesSpIdentifiers: program have no rule at ruleIdx=", ruleIdx);
          continue;
        }
        program[ruleIdx]['spIdentifiers'] = spIds[ruleIdx]; //notice: a shallow copy.
      }
    }
    console.log("# splitdiff-view updateRulesSpIdentifiers.");
    spidsUpd(this.PROGRAM_1, this.IDENTIFIERS_BY_RULES_LEFT); //TODO: concurrency bug.

    // this.IDENTIFIERS_BY_RULES_RIGHT is organized based on the old rules order (elts of PROGRAM_2_ORIG_ORDER)
    // orig prgm: [w, x, y, z] | new prgm: [w, z, y, x] | orig order: [0, 3, 2, 1] | 
    // id_by_rules_right: [0:w, 1:z, 2:y, 3:x] | correct ids: [0:w, 3:z, 2:y, 1:x]
    let new_identifiers_by_rules_right: {[id:number]: string[]} = {};
    for (let old_rule_order of this.PROGRAM_2_ORIG_ORDER) {
      // ex. new[3] = what is at index 3 of PROGRAM_2_ORIG_ORDER (which is 1, the orig place of the rule currently at index 3)
      new_identifiers_by_rules_right[old_rule_order] = this.IDENTIFIERS_BY_RULES_RIGHT[this.PROGRAM_2_ORIG_ORDER[old_rule_order]];
    }
    spidsUpd(this.PROGRAM_2, new_identifiers_by_rules_right); // this.IDENTIFIERS_BY_RULES_RIGHT);
  }


  

  /* ----before: copied from sdiffbase.component.ts ----*/
  /* ----before: copied from sdiffbase.component.ts ----*/
  /* ----before: copied from sdiffbase.component.ts ----*/

  constructor(public userDataService: UserDataService) { }

  ngOnInit() {
  }

}
