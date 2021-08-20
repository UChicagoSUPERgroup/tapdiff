import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CcsingbaseComponent } from './ccsingbase.component';

describe('CcsingComponent', () => {
  let component: CcsingbaseComponent;
  let fixture: ComponentFixture<CcsingbaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CcsingbaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CcsingbaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
