import { Component, Input, OnInit } from '@angular/core';
import { RuleUIRepresentation, DiffcomService } from '../../diffcom.service';
import { Rule, UserDataService } from '../../user-data.service';


@Component({
  selector: 'app-tap-tip',
  templateUrl: './tap-tip.component.html',
  styleUrls: ['./tap-tip.component.css']
})
export class TapTipComponent implements OnInit {
  //you can set parsed rules to RULES directly,
  //or set unparsed rules to UNPARSED_RULES and this component will do the parse.

  @Input()
  public NEVER_COLLAPSE: boolean = false;

  @Input() //non critical (just for logging)
  public VERSION: number = -1;

  // @Input() // cancel this input. Can only set through UNPARSED_RULES setter.
  public RULES: RuleUIRepresentation[];

  @Input()
  set UNPARSED_RULES(unparsedRules: Rule[]){
    console.log("# tap-tip UNPARSED_RULES update.");
    this.isRulesboxShowed = false;
    if(unparsedRules == null) this.RULES = null;
    else this.RULES = DiffcomService.parseRules3Columns(unparsedRules);
  }

  public isRulesboxShowed: boolean = false;

  public toggleRuleboxShowed(){
    this.isRulesboxShowed = !this.isRulesboxShowed;
    this.userDataService.appendLog("toggleRuleboxShowed | " + this.isRulesboxShowed + " | " + this.VERSION);
  }
  constructor(
    public userDataService: UserDataService
  ) { }
  ngOnInit() {
  }

}
