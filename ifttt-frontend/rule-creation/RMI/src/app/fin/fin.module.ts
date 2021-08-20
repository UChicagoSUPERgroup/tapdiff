import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FinComponent } from './fin.component';

import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSliderModule } from '@angular/material/slider';
import { MatCardModule} from '@angular/material/card';
import { MatGridListModule} from '@angular/material/grid-list';
import {MatSelectModule} from '@angular/material/select';
import {MatRadioModule} from '@angular/material/radio';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';


const routes: Routes = [
  {
    path: 'finishpage',
    component: FinComponent
  }
]


@NgModule({
  imports: [
    RouterModule.forChild(routes),
    CommonModule,
    MatSliderModule, MatListModule, MatButtonModule, MatIconModule, MatCardModule,
    MatGridListModule, MatSelectModule, MatRadioModule, MatProgressSpinnerModule
  ],
  declarations: [
    FinComponent
  ],
  exports: [
    RouterModule
  ]
})

export class FinModule { }




