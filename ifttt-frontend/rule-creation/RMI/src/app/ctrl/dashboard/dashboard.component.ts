import { Component, OnInit, EventEmitter } from '@angular/core';
import { UserDataService} from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  public USERS: [{[id:string]: any}];
  public running: boolean = false;

  constructor(
    public userDataService: UserDataService,
    private route: Router,
    private router: ActivatedRoute) { }

  ngOnInit() {
    this.updateInfos();
  }

  public updateInfos(){
    this.userDataService.getAllUsers().subscribe(data => {
      this.USERS = data['users'];
      console.log("# getAllUsers:", this.USERS);
      this.mylog("# getAllUsers:" + JSON.stringify(this.USERS));
    });
  }

  public mylog(logstr: string){
    let elem = document.createElement("div");
    elem.innerText = logstr;
    elem.classList.add("log-item");
    document.getElementById("log-display").appendChild(elem);
    document.getElementById("log-display").scrollTop = document.getElementById("log-display").scrollHeight;
  }

  public runCmds(value:string){
    this.running = true;
    let cmds = value.split("\n").map(x => x.trim()).filter(x => x != "");
    this.mylog(" ================ run "+ cmds.length + " commands ================");
    this.runCmdsCore(cmds);
  }

  public runCmdsCore(cmds: string[]){
    if(cmds.length == 0){
      this.mylog("# runCmdsCore all done. updating all users info...");
      this.updateInfos();
      this.running = false;
      return;
    }
    this.mylog("# initDiffUser run:" + cmds[0]);
    var l1 = cmds[0].trim().split(/(\s+)/).filter(x => x.trim().length > 0);
    var op = l1[0];
    if(op == 'DELETE-ALL'){
      var code = l1[1];
      this.userDataService.deleteTasks(code).subscribe(resp => {
        this.mylog("# deleteTasks done. " + JSON.stringify(resp));
        this.runCmdsCore(cmds.slice(1));
      });
    }
    if(op == 'COPY'){
      var codeSrc = l1[1];
      var codeDst = l1[2];
      var tasks = l1.slice(3);
      this.userDataService.copyTasks(codeSrc, codeDst, tasks).subscribe(resp => {
        this.mylog("# copyTasks done." + JSON.stringify(resp));
        this.runCmdsCore(cmds.slice(1));
      });
    }
    if(op == 'DELETE-VER'){
      var code = l1[1];
      var taskVers = l1.slice(2);
      this.userDataService.deleteVers(code, taskVers).subscribe(resp => {
        this.mylog("# deleteVers done." + JSON.stringify(resp));
        this.runCmdsCore(cmds.slice(1));
      });
    }
    if(op == 'COPY-VER'){
      var code = l1[1];
      var srcVer = l1[2];
      if(l1[3] != '=>'){
        console.log("# COPY-VER syntax error! terminate:", cmds[0]);
        this.running = false;
        return;
      }
      var dstVers = l1.slice(4);
      this.userDataService.copyVers(code, srcVer, dstVers).subscribe(resp => {
        this.mylog("# copyVers done." + JSON.stringify(resp));
        this.runCmdsCore(cmds.slice(1));
      });
    }
  }

}
