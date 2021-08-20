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
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import {MatCheckboxModule} from '@angular/material/checkbox';

import { ReactiveFormsModule } from '@angular/forms';
import { FormsModule } from '@angular/forms';

import { TapTipComponent } from './tap-tip/tap-tip.component';
import { SaveBarComponent } from './save-bar/save-bar.component';
import { TaskBriefComponent } from './task-brief/task-brief.component';
import { SplitdiffViewComponent } from './splitdiff-view/splitdiff-view.component';

@NgModule({
  imports: [
    CommonModule,
    MatSliderModule, MatListModule, MatButtonModule, MatIconModule, MatCardModule,
    MatGridListModule, MatSelectModule, MatRadioModule, MatProgressSpinnerModule,
    FormsModule, MatCheckboxModule, ReactiveFormsModule
  ],
  declarations: [TapTipComponent, SaveBarComponent, TaskBriefComponent, SplitdiffViewComponent],
  exports: [TapTipComponent, SaveBarComponent, SplitdiffViewComponent]
})
export class TapElementsModule { }
