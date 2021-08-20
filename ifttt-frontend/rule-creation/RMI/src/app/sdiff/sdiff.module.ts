import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
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

import { SdiffbaseComponent } from './sdiffbase/sdiffbase.component';
import { FormsModule } from '@angular/forms';
import { TapElementsModule } from '../tap-elements/tap-elements.module';

const routes: Routes = [
  {
    path: ':hashed_id/:task_id/splitdiff',
    component: SdiffbaseComponent
  }
]

@NgModule({
  imports: [
    RouterModule.forChild(routes),
    CommonModule,
    MatSliderModule, MatListModule, MatButtonModule, MatIconModule, MatCardModule,
    MatGridListModule, MatSelectModule, FormsModule, MatRadioModule, MatProgressSpinnerModule,
    TapElementsModule
  ],
  declarations: [
    SdiffbaseComponent
  ],
  exports: [
    RouterModule
  ]
})
export class SdiffModule { }
