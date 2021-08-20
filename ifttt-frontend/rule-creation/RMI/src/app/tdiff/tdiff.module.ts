import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CommonModule } from '@angular/common';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSliderModule } from '@angular/material/slider';
import { MatCardModule } from '@angular/material/card';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatSelectModule } from '@angular/material/select';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatRadioModule } from '@angular/material/radio';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';

import { TdiffbaseComponent } from './tdiffbase/tdiffbase.component';
import { FormsModule } from '@angular/forms';
import { Tdiff4Component } from './tdiff4/tdiff4.component';
import { Tdiff6Component } from './tdiff6/tdiff6.component';

import { TapElementsModule } from '../tap-elements/tap-elements.module';

const routes: Routes = [
  {
    path: ':hashed_id/:task_id/timelinediff',
    component: Tdiff4Component
  },
  {
    path: ':hashed_id/:task_id/mcdiff',
    component: Tdiff6Component
  },
]

@NgModule({
  imports: [
    RouterModule.forChild(routes),
    CommonModule,
    MatSliderModule, MatListModule, MatButtonModule, MatIconModule, MatCardModule, MatSlideToggleModule,
    MatGridListModule, MatSelectModule, MatRadioModule, MatCheckboxModule, FormsModule, MatProgressSpinnerModule,
    TapElementsModule
  ],
  declarations: [
    TdiffbaseComponent,
    Tdiff4Component,
    Tdiff6Component
  ],
  exports: [
    RouterModule
  ]
})
export class TdiffModule { }
