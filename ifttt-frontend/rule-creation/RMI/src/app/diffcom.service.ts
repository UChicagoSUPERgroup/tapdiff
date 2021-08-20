import { Injectable } from '@angular/core';

import { Clause, Channel, Device, Capability, Parameter } from './user-data.service';
import { Rule } from './user-data.service';

export interface ClauseDiff {
  channel: Channel;
  device: Device;
  capability: Capability;
  parameters?: Parameter[];
  parameterVals?: any[];
  text: string;
  id?: number;
  status?: number;
}

export interface RuleDiff {
  ifClause: ClauseDiff[];
  thenClause: ClauseDiff[];
  priority?: number;
  temporality: string;
  id?: number;
  status: number;
}

export interface RuleUIRepresentation {
  words: string[]; // e.g. IF, AND, THEN
  icons: string[]; // the string name of the icons
  descriptions: string[]; // the descriptions for each of the icons
}

export interface ChangedRuleUIRepresentation {
  words: string[];
  icons: string[];
  descriptions: string[];
  status: number;
  statuses?: number[];
}

export interface ChangedRuleUIRepresentationPair {
  left: ChangedRuleUIRepresentation;
  right: ChangedRuleUIRepresentation
}


@Injectable()
export class DiffcomService {

  public static deepCopy(obj) {
    var copy;
    // Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;
    // Handle Date
    if (obj instanceof Date) {
      copy = new Date();
      copy.setTime(obj.getTime());
      return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
      copy = [];
      for (var i = 0, len = obj.length; i < len; i++) {
        copy[i] = this.deepCopy(obj[i]);
      }
      return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
      copy = {};
      for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = this.deepCopy(obj[attr]);
      }
      return copy;
    }
    throw new Error("Unable to copy obj! Its type isn't supported.");
  }

  public static getDeviceFromDescription(desp: string) {
    function sfind(s: string) {
      return desp.indexOf(s) >= 0;
    }

    function sfinds(ss: string[]) {
      for (let s of ss) {
        if (sfind(s)) return true;
      }
      return false;
    }

    function sdeletes(ss: string[]) {
      let result = desp;
      for (let s of ss) {
        result = result.replace(s, "");
      }
      return result.trim();
    }

    let dev = "(Unexpected!)";
    const tokensIsOnOpen = ["is Open", "is Closed", "is On", "is Off", "turns Off", "turns On", "Closes", "Opens", "is Unlocked", "is Locked"];
    const tokensExists = ["exists", "is at", "is not at"];
    const tokensFitbit = ["FitBit"];
    const tokensTime = ["Nighttime"];
    const tokensNotDevice = ["never"];
    if (sfinds(tokensIsOnOpen)) {
      dev = sdeletes(tokensIsOnOpen);
    }
    else if (sfinds(tokensExists)) {
      dev = "Location: " + desp.trim().split(" ").pop();
    }
    else if (sfinds(tokensFitbit)) {
      dev = "Fitbit";
    }
    else if (sfinds(tokensNotDevice)) {
      return "(not)";
    }
    else if (sfinds(tokensTime)) {
      return "Clock";
    }
    return dev;
  }

  public static getProgramNameFromVersionId(version_id: number, urlparam: {}) {
    // NOTE: need to match VERSION_WORD in save-bar.component.ts ('Program' vs. 'Version' vs. 'Option')
    if (version_id == -2) return "(Not Selected)";
    if (urlparam['save-style'] == 'yesorno') { // save options are "None of the above" and "At least one program" (checkboxes)
      return version_id == 0 ? "Original Program" : "Modified Program";
    }
    if (urlparam['version-style'] == 'origin') {
      return version_id == 0 ? "My original program" : "Fix #" + String(version_id);
    }
    else {
      return version_id == 0 ? "Original Program" : "Program #" + String(version_id);
    }
    // other options: "Option #1" / "Version #1" (no mention of 'Program'), 
    // "New Program #1" (#1 is too much towards the right), 
    // "Program #1 (New)" ('what does (New) mean?')
  }

  public static parseRules3Columns(rules: Rule[]) {
    let parsedRules = this.parseRules(rules);
    let resultRules = parsedRules.map((rule => {
      const words = [];
      const descriptions = [];
      const icons = [];
      function pushFrom(idx: number) {
        if (idx > rule.words.length) console.error("# parseRules3Columns.pushFrom error.");
        words.push(rule.words[idx]);
        descriptions.push(rule.descriptions[idx]);
        icons.push(rule.icons[idx]);
      }
      function pushEmpty() {
        words.push('');
        descriptions.push('');
        icons.push('');
      }
      pushFrom(0);
      pushFrom(1);
      pushFrom(rule.words.length - 1);
      for (let i = 2; i < rule.words.length - 1; i++) {
        pushEmpty();
        pushFrom(i);
        pushEmpty();
      }
      const ruleRep: RuleUIRepresentation = {
        words: words,
        icons: icons,
        descriptions: descriptions
      };
      if (words.length % 3 != 0) console.error("# parseRules3Columns 3 column parse error.");
      return ruleRep;
    }));
    return resultRules;
  }

  public static parseRules(rules: Rule[]) {
    let resultRules = rules.map((rule => {
      const words = [];
      const descriptions = [];
      const icons = [];

      // add the if clause stuff
      for (let i = 0; i < rule.ifClause.length; i++) {
        let clause = rule.ifClause[i];
        words.push(i == 0 ? "If" : (i > 1 ? "and" : "while"));
        icons.push(clause.channel.icon);
        const description = clause.text;
        descriptions.push(description);
      }
      if (rule.ifClause.length <= 1) { // i.e. no conditions
        words.push('');
        icons.push('');
        descriptions.push('');
      }

      // add the then clause
      words.push("then");
      const description = rule.thenClause[0].text;
      descriptions.push(description);
      icons.push(rule.thenClause[0].channel.icon);

      const ruleRep: RuleUIRepresentation = {
        words: words,
        icons: icons,
        descriptions: descriptions
      };
      return ruleRep;
    }));
    return resultRules;
  }

  public static getSortedDiffs(rawdiff: RuleDiff[]) {
    //Bo Wang. Add the sort step START.
    //var rawdiff = data['diff'];
    console.log("# rawdiff:", rawdiff);
    var sortedDiff = [];
    var diff0s = [], diff21s = [], diff22s = [], diffm1s = [], diffp1s = [];
    var compf = (a: RuleDiff, b: RuleDiff) => {
      const stra = a.ifClause[0].text + a.thenClause[0].text;
      const strb = b.ifClause[0].text + b.thenClause[0].text;
      if (stra < strb) {
        return -1;
      }
      if (stra == strb) {
        console.log("# warning: rule compare cannot tell:", a, b);
        return 0;
      }
      return 1;
    };
    for (var i in rawdiff) { if (rawdiff[i]['status'] == 0) diff0s.push(rawdiff[i]); }
    diff0s = diff0s.sort(compf);
    for (var i in rawdiff) { if (rawdiff[i]['status'] == 21) diff21s.push(rawdiff[i]); }
    for (var i in rawdiff) { if (rawdiff[i]['status'] == 22) diff22s.push(rawdiff[i]); }
    for (var i in rawdiff) { if (rawdiff[i]['status'] == -1) diffm1s.push(rawdiff[i]); }
    diffm1s = diffm1s.sort(compf);
    for (var i in rawdiff) { if (rawdiff[i]['status'] == 1) diffp1s.push(rawdiff[i]); }
    diffp1s = diffp1s.sort(compf);
    var diff2122s = [];
    if (diff21s.length != diff22s.length) console.error("#21 #22 don't match.", diff21s, diff22s);
    for (let i = 0; i < diff21s.length; i++) {
      diff2122s.push(diff21s[i]);
      diff2122s.push(diff22s[i]);
    }
    sortedDiff = sortedDiff.concat(diff0s, diff2122s, diffm1s, diffp1s);
    console.log("# sort length: ", rawdiff.length, sortedDiff.length)
    return sortedDiff;
    //Bo Wang. Add the sort step END.
  }


  public static diffParserRuleUI(rule: RuleDiff) {
    const words = [];
    const descriptions = [];
    const icons = [];
    const statuses = []; // this is just a bunch of copies of rule status if it's a shared/added/deleted rule

    // add the if clause stuff
    for (let i = 0; i < rule.ifClause.length; i++) {
      let clause = rule.ifClause[i];
      if (i == 0) {
        words.push(i == 0 ? "If" : (i > 1 ? "and" : "while"));
        icons.push(clause.channel.icon);
        const description = clause.text;
        descriptions.push(description);
        if (rule.status == 21 || rule.status == 22) {
          statuses.push(clause.status);
        } else {
          statuses.push(rule.status);
        }

        if (rule.ifClause.length <= 1) { // i.e. no conditions
          words.push('');
          icons.push('');
          descriptions.push('');
          statuses.push(rule.status);
        } else {
          i = i + 1;
          let clause = rule.ifClause[i];
          words.push('while');
          icons.push(clause.channel.icon);
          const description = clause.text;
          descriptions.push(description);
          if (rule.status == 21 || rule.status == 22) {
            statuses.push(clause.status);
          } else {
            statuses.push(rule.status);
          }
        }

        // add the then clause
        words.push("then");
        const description2 = rule.thenClause[0].text;
        descriptions.push(description2);
        icons.push(rule.thenClause[0].channel.icon);
        if (rule.status == 21 || rule.status == 22) {
          statuses.push(rule.thenClause[0].status);
        } else {
          statuses.push(rule.status);
        }
      }
      else {
        words.push('');
        icons.push('');
        descriptions.push('');
        statuses.push(rule.status);

        //i should greater than 2
        words.push("and");
        icons.push(clause.channel.icon);
        const description = clause.text;
        descriptions.push(description);
        if (rule.status == 21 || rule.status == 22) {
          statuses.push(clause.status);
        } else {
          statuses.push(rule.status);
        }

        words.push('');
        icons.push('');
        descriptions.push('');
        statuses.push(rule.status);
      }
    }

    const ruleRep: ChangedRuleUIRepresentation = {
      words: words,
      icons: icons,
      descriptions: descriptions,
      statuses: statuses,
      status: rule.status
    };
    return ruleRep;
  }

  public static combineRuleUIPair(
    rule1: ChangedRuleUIRepresentation,
    rule2: ChangedRuleUIRepresentation,
    combineType: string) {
    console.log("# combineRuleUIPair called:", JSON.stringify({ rule1, rule2, combineType }));
    const result: ChangedRuleUIRepresentation = {
      words: [],
      icons: [],
      descriptions: [],
      status: 22, //TODO:
      statuses: []
    };
    if (rule1.status != 21 || rule2.status != 22) {
      console.error("# combineRule error: unexpected pair", JSON.stringify({ rule1, rule2, combineType }));
      return null;
    }
    function _resultSet(
      rule: ChangedRuleUIRepresentation,
      index: number,
      resultIndex: number) {
      //put a token into result
      // console.log("_ruleSet called before:", JSON.stringify(result));
      result.descriptions[resultIndex] = rule.descriptions[index];
      result.icons[resultIndex] = rule.icons[index];
      result.statuses[resultIndex] = rule.statuses[index];
      result.words[resultIndex] = rule.words[index];
      // console.log("_ruleSet called:", JSON.stringify(result));
    }
    function _resultSetIfEmpty(resultIndex: number) {
      //put a placeholder into result
      if (result.words[resultIndex]) return;
      result.descriptions[resultIndex] = '';
      result.icons[resultIndex] = '';
      result.statuses[resultIndex] = 22;
      result.words[resultIndex] = '';
    }
    var whileIndex: number = 0;
    function _resultWhilePush(
      rule: ChangedRuleUIRepresentation,
      index: number) {
      if (combineType == 'udiff2') {
        const place = whileIndex * 3 + 1;
        if (result[place] != undefined) {
          console.error("# _resultWhilePush: whileClause place already occupied", result);
          return;
        }
        if (index % 3 != 1) {
          console.error("# _resultWhilePush: index not a whileClause");
          return;
        }
        _resultSet(rule, index, place);
        whileIndex++;
      }
      else if (combineType == 'udiff3') {
        if (rule.words[index]) {
          _resultSet(rule, index, result.statuses.length);
        }
      }
      else {
        console.error("# unknown combineType:", combineType);
        return;
      }
    }


    if (combineType == 'udiff2') { //=================== udiff2 ============== if-then clause
      for (let i of [0, 2]) {
        if (rule1.statuses[i] == 0 || rule1.statuses[i] == -1) { _resultSet(rule1, i, i); }
        else console.error("# combineRule error: rule1 if-then clause status", rule1);

        if (rule2.statuses[i] == 1) { _resultSet(rule2, i, i + 3); }
        else if (rule2.statuses[i] != 0) console.error("# combineRule error: rule2 if-then clause status", rule2);
      }
    }
    else if (combineType == 'udiff3') { //=================== udiff3 ============== only if clause
      if (rule1.statuses[0] == 0 || rule1.statuses[0] == -1) { _resultSet(rule1, 0, 0); }
      else console.error("# combineRule error: rule1 if-then clause status", rule1);

      if (rule2.statuses[0] == 1) { _resultSet(rule2, 0, 1); }
      else if (rule2.statuses[0] != 0) console.error("# combineRule error: rule2 if-then clause status", rule2);
    }

    //both udiff2 and udiff3 process while clause =================== udiff 2 & 3 ==============
    if (rule1.statuses.length % 3 != 0 || rule2.statuses.length % 3 != 0) console.error("# combineRule error: unexpected rule statuses length.", { rule1, rule2 });
    const whileIndexUpper1 = rule1.words[1] == "" ? 0 : rule1.statuses.length;
    const whileIndexUpper2 = rule2.words[1] == "" ? 0 : rule2.statuses.length;
    for (let i = 1, j = 1; ;) {
      // console.log("# debug whileClause Combine:", i, j);
      if (i < whileIndexUpper1 && rule1.statuses[i] == -1) {
        _resultWhilePush(rule1, i);
        i += 3;
      }
      else if (j < whileIndexUpper2 && rule2.statuses[j] == 1) {
        _resultWhilePush(rule2, j);
        j += 3;
      }
      else if ((i < whileIndexUpper1 && rule1.statuses[i] == 0)
        && (j < whileIndexUpper2 && rule2.statuses[j] == 0)) {
        _resultWhilePush(rule1, i);
        i += 3;
        j += 3;
      }
      else if ((i < whileIndexUpper1 && rule1.statuses[i] == 21)
        && (j < whileIndexUpper2 && rule2.statuses[j] == 22)) {
        //21 22 ignored
        if (rule1.words[i] || rule2.words[j]) {
          console.error("# combineRule error: 21-22 word should be empty.");
        }
        i += 3;
        j += 3;
      }
      else if (i < whileIndexUpper1 || j < whileIndexUpper2) {
        console.error("# combineRule error: unexpected rule status:", { rule1, rule2, i, j });
        return null;
      }
      else {
        //i > uppper1 and j > upper2
        break;
      }
    }

    if (combineType == 'udiff3') { //=================== udiff3 ============== if-clause
      if (rule1.statuses[2] == 0 || rule1.statuses[2] == -1) { _resultSet(rule1, 2, result.statuses.length); }
      else console.error("# combineRule error: rule1 then clause status", rule1);

      if (rule2.statuses[2] == 1) { _resultSet(rule2, 2, result.statuses.length); }
      else if (rule2.statuses[2] != 0) console.error("# combineRule error: rule2 then clause status", rule2);
    }

    const resultLength = Math.max(3, whileIndex * 3);
    for (let i = 0; i < resultLength; i++) { _resultSetIfEmpty(i); }
    return result;
  }

  public static mergeRuleUIList2One(
    program1: ChangedRuleUIRepresentation[],
    program2: ChangedRuleUIRepresentation[],
    mergeType: string) {
    //for udiff3, to remove empty clause.
    function removeEmpty(rule: ChangedRuleUIRepresentation) {
      const clearedRule: ChangedRuleUIRepresentation = {
        words: [],
        icons: [],
        descriptions: [],
        status: rule.status,
        statuses: []
      };
      if (mergeType == 'udiff2') return rule;
      if (mergeType == 'udiff3') {
        for (let i = 0; i < rule.statuses.length; i++) {
          if (rule.words[i] && i != 2) {
            clearedRule.descriptions.push(rule.descriptions[i]);
            clearedRule.icons.push(rule.icons[i]);
            clearedRule.statuses.push(rule.statuses[i]);
            clearedRule.words.push(rule.words[i]);
          }
        }
        clearedRule.descriptions.push(rule.descriptions[2]);
        clearedRule.icons.push(rule.icons[2]);
        clearedRule.statuses.push(rule.statuses[2]);
        clearedRule.words.push(rule.words[2]);
        return clearedRule;
      }
      console.error("# removeEmpty: unknown mergeType:", mergeType);
      return null;
    }

    var mergeRuleUIs: ChangedRuleUIRepresentationPair[];
    mergeRuleUIs = this.mergeRuleUIList2Table(program1, program2, 'sdiff');
    var unifiedMergeRuleUIs: ChangedRuleUIRepresentation[] = [];
    if (mergeType == 'udiff') {
      for (let rulePair of mergeRuleUIs) {
        const statusL = rulePair.left.status;
        const statusR = rulePair.right.status;

        if (statusL == -1 || statusL == 0 || statusL == 21) {
          unifiedMergeRuleUIs.push(rulePair.left);
        }
        else if (statusL != 101) {
          console.error("# mergeRuleUIList2One unexpected status:", rulePair.left);
        }

        if (statusR == 1 || statusR == 22) {
          unifiedMergeRuleUIs.push(rulePair.right);
        }
        else if (statusR != 102 && statusR != 0) {
          console.error("# mergeRuleUIList2One unexpected status:", rulePair.right);
        }
      }
    }
    else if (mergeType == 'udiff2' || mergeType == 'udiff3') {


      for (let rulePair of mergeRuleUIs) {
        const statusL = rulePair.left.status;
        const statusR = rulePair.right.status;

        if (statusL == -1 || statusL == 0) {
          unifiedMergeRuleUIs.push(removeEmpty(rulePair.left));
        }
        else if (statusL == 21) {
          //merge 2 rules into one  --table style
          unifiedMergeRuleUIs.push(this.combineRuleUIPair(rulePair.left, rulePair.right, mergeType));
        }
        else if (statusL != 101) {
          console.error("# mergeRuleUIList2One unexpected status:", rulePair.left);
        }

        if (statusR == 1) {
          unifiedMergeRuleUIs.push(removeEmpty(rulePair.right));
        }
        else if (statusR != 22 && statusR != 102 && statusR != 0) {
          console.error("# mergeRuleUIList2One unexpected status:", rulePair.right);
        }
      }
    }
    else {
      console.error("# mergeRuleUIList2One: unknown merge type:", mergeType);
      return null;
    }
    console.log("# mergeRuleUIList2One:", unifiedMergeRuleUIs);
    return unifiedMergeRuleUIs;
  }

  public static getRuleUIPlaceHolder(status: number) {
    return {
      words: [],
      icons: [],
      descriptions: [],
      statuses: [],
      status: status
    }
  }

  public static mergeRuleUIList2Table(
    program1: ChangedRuleUIRepresentation[],
    program2: ChangedRuleUIRepresentation[],
    mergeType: string) {
    
    var mergeRuleUIs: ChangedRuleUIRepresentationPair[] = [];
    for (let i = 0, j = 0; ;) {
      var ruleLeft: ChangedRuleUIRepresentation = null;
      var ruleRight: ChangedRuleUIRepresentation = null;
      if (i < program1.length) ruleLeft = program1[i];
      if (j < program2.length) ruleRight = program2[j];
      var rulePair: ChangedRuleUIRepresentationPair = { left: null, right: null };
      if (ruleLeft != null && ruleRight != null) {
        // final check for identical triggers
        if (ruleLeft.descriptions[0] === ruleRight.descriptions[0]) {
          if (ruleLeft.statuses[0] != 0) {
            ruleLeft.statuses[0] = 0;
          } else if (ruleRight.statuses[0] != 0) {
            ruleRight.statuses[0] = 0;
          }
        }
        // final check for identical actions
        if (ruleLeft.descriptions[2] === ruleRight.descriptions[2]) {
          if (ruleLeft.statuses[2] != 0) {
            ruleLeft.statuses[2] = 0;
          } else if (ruleRight.statuses[2] != 0) {
            ruleRight.statuses[2] = 0;
          }
        }

        //process left only
        if (ruleLeft.status == -1) {
          if (mergeType == 'sdiff') {
            rulePair.left = ruleLeft;
            rulePair.right = this.getRuleUIPlaceHolder(102);
          }
          else if (mergeType == 'sdiff2') {
            rulePair.left = ruleLeft;
            rulePair.right = ruleLeft;
          }
          i++;
        }
        //process right only
        else if (ruleRight.status == 1) {
          rulePair.left = this.getRuleUIPlaceHolder(101);
          rulePair.right = ruleRight;
          j++;
        }
        //process left right same.
        else if (ruleLeft.status == 0 && ruleRight.status == 0) {
          rulePair.left = ruleLeft;
          rulePair.right = ruleRight;
          i++; j++;
        }
        //process left right modify
        else if (ruleLeft.status == 21 && ruleRight.status == 22) {
          rulePair.left = ruleLeft;
          rulePair.right = ruleRight;
          i++; j++;
        }
        else {
          console.error("# Left and right status is unexpected.", JSON.stringify(ruleLeft), JSON.stringify(ruleRight));
          console.error("# current mergeRuleUIs:", mergeRuleUIs);
          alert("# Bug");
          return null;
        }
        mergeRuleUIs.push(rulePair);
      }
      else if (ruleLeft != null && ruleRight == null) {
        if (ruleLeft.status == -1) {
          if (mergeType == 'sdiff') {
            rulePair.left = ruleLeft;
            rulePair.right = this.getRuleUIPlaceHolder(102);
          }
          else if (mergeType == 'sdiff2') {
            rulePair.left = ruleLeft;
            rulePair.right = ruleLeft;
          }
          i++;
        }
        else {
          console.error("# Left can only have status -1! ", ruleLeft);
          console.error("# current mergeRuleUIs:", mergeRuleUIs);
          alert("# Bug");
          return null;
        }
        mergeRuleUIs.push(rulePair);
      }
      else if (ruleLeft == null && ruleRight != null) {
        if (ruleRight.status == 1) {
          rulePair.left = this.getRuleUIPlaceHolder(101);
          rulePair.right = ruleRight;
          j++;
        }
        else {
          console.error("# Right can only have status 1! ", ruleRight);
          console.error("# current mergeRuleUIs:", mergeRuleUIs);
          alert("# Bug");
          return null;
        }
        mergeRuleUIs.push(rulePair);
      }
      else {
        break;
      }
    }
    
    return mergeRuleUIs;
  }

  constructor() { }
}
