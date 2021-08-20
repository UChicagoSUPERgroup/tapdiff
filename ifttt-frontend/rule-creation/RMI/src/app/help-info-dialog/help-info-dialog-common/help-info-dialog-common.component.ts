import {Component, Inject} from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';

export interface HelpInfoDialogData {
  preset: string;
  content?: string;
}

@Component({
  selector: 'app-help-info-dialog-common',
  templateUrl: './help-info-dialog-common.component.html',
  styleUrls: ['./help-info-dialog-common.component.css']
})
export class HelpInfoDialogCommonComponent {

  constructor(
    public dialogRef: MatDialogRef<HelpInfoDialogCommonComponent>,
    @Inject(MAT_DIALOG_DATA) public data: HelpInfoDialogData) {}

  closeClick(): void {
    this.dialogRef.close();
  }

}
