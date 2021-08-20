import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-task-brief',
  templateUrl: './task-brief.component.html',
  styleUrls: ['./task-brief.component.css']
})
export class TaskBriefComponent implements OnInit {

  @Input()
  public TASK_ID: number = -1;

  constructor() { }

  ngOnInit() {
  }

}
