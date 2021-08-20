import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpInfoDialogCommonComponent } from './help-info-dialog-common.component';

describe('HelpInfoDialogCommonComponent', () => {
  let component: HelpInfoDialogCommonComponent;
  let fixture: ComponentFixture<HelpInfoDialogCommonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpInfoDialogCommonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpInfoDialogCommonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
