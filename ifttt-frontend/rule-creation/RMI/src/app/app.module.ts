import { BrowserModule } from '@angular/platform-browser';
import { NgModule, Injector } from '@angular/core';
import { RouterModule, Routes} from '@angular/router';
import { MatInputModule } from '@angular/material';
import { MatSliderModule } from '@angular/material/slider';
import { MatDialogModule } from '@angular/material/dialog';

import { TapElementsModule } from './tap-elements/tap-elements.module';

import { HelpInfoDialogModule } from './help-info-dialog/help-info-dialog.module';
import { HelpInfoDialogCommonComponent } from './help-info-dialog/help-info-dialog-common/help-info-dialog-common.component';

import { CtrlModule } from './ctrl/ctrl.module';

import { FinModule } from './fin/fin.module';

import { RmiModule } from './rmi/rmi.module';
import { RciModule } from './rci/rci.module';

import { SdiffModule } from './sdiff/sdiff.module';

import { TdiffModule } from './tdiff/tdiff.module';
import { SpdiffModule } from './spdiff/spdiff.module';
import { CcsingModule } from './ccsing/ccsing.module';

import { SharedModule } from './shared.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppComponent } from './app.component';

import { HttpClientModule, HttpClientXsrfModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { XsrfInterceptor } from './xsrf.interceptor';

const routes: Routes = [
  {
    path: '',
    component: AppComponent,
  },
]

@NgModule({
  declarations: [
    AppComponent,
  ],
  imports: [
    BrowserModule, RmiModule, RciModule, TdiffModule, SdiffModule, SpdiffModule, 
    CcsingModule, SharedModule, BrowserAnimationsModule, FinModule,
    RouterModule.forRoot(routes, {enableTracing: false}),
    MatInputModule, MatSliderModule, MatDialogModule,
    HelpInfoDialogModule, TapElementsModule,
    HttpClientModule,
    HttpClientXsrfModule.withOptions({
      cookieName: 'csrftoken',
      headerName: 'X-CSRFToken'
    }), //CtrlModule,
  ],
  entryComponents: [HelpInfoDialogCommonComponent],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: XsrfInterceptor, multi: true }
  ],
  bootstrap: [AppComponent]
})
export class AppModule {
  constructor(private injector: Injector){
  }
 }
