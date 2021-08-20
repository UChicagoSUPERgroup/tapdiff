import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SdiffbaseComponent } from './sdiffbase.component';

describe('SdiffbaseComponent', () => {
  let component: SdiffbaseComponent;
  let fixture: ComponentFixture<SdiffbaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SdiffbaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SdiffbaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
