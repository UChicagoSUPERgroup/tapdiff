import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TdiffbaseComponent } from './tdiffbase.component';

describe('TdiffbaseComponent', () => {
  let component: TdiffbaseComponent;
  let fixture: ComponentFixture<TdiffbaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TdiffbaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TdiffbaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
