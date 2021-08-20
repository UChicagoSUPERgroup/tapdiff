import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CommonModule } from '@angular/common';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSliderModule } from '@angular/material/slider';

import { RmibaseComponent } from './rmibase/rmibase.component';
import { RmidbaseComponent } from './rmidbase/rmidbase.component';

const routes: Routes = [
  {
    path: ':hashed_id/:task_id/rules',
    component: RmibaseComponent
  },
  {
    path: 'diff/:hashed_id/:task_id/:version/rules',
    component: RmidbaseComponent
  }
]

@NgModule({
  imports: [
    RouterModule.forChild(routes),
    CommonModule,
    MatSliderModule, MatListModule, MatButtonModule, MatIconModule
  ],
  declarations: [
    RmibaseComponent,
    RmidbaseComponent
  ],
  exports: [
    RouterModule
  ]
})
export class RmiModule { }
