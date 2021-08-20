import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Spdiff2Component } from './spdiff2.component';

describe('Spdiff2Component', () => {
  let component: Spdiff2Component;
  let fixture: ComponentFixture<Spdiff2Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Spdiff2Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Spdiff2Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
