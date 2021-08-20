import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSliderModule } from '@angular/material/slider';
import { MatCardModule} from '@angular/material/card';
import { MatGridListModule} from '@angular/material/grid-list';
import {MatSelectModule} from '@angular/material/select';
import {MatRadioModule} from '@angular/material/radio';
import { FormsModule } from '@angular/forms';

import { HelpInfoDialogCommonComponent } from './help-info-dialog-common/help-info-dialog-common.component';

@NgModule({
  imports: [
    CommonModule,
    MatSliderModule, MatListModule, MatButtonModule, MatIconModule, MatCardModule,
    MatGridListModule, MatSelectModule, FormsModule, MatRadioModule
  ],
  declarations: [HelpInfoDialogCommonComponent]
})
export class HelpInfoDialogModule { }
