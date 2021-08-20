import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Tdiff6Component } from './tdiff6.component';

describe('Tdiff6Component', () => {
  let component: Tdiff6Component;
  let fixture: ComponentFixture<Tdiff6Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Tdiff6Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Tdiff6Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
