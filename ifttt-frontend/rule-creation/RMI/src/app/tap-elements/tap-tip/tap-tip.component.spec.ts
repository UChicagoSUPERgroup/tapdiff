import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TapTipComponent } from './tap-tip.component';

describe('TapTipComponent', () => {
  let component: TapTipComponent;
  let fixture: ComponentFixture<TapTipComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TapTipComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TapTipComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
