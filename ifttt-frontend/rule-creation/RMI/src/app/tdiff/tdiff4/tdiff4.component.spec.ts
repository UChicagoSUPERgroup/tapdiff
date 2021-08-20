import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Tdiff4Component } from './tdiff4.component';

describe('Tdiff4Component', () => {
  let component: Tdiff4Component;
  let fixture: ComponentFixture<Tdiff4Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Tdiff4Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Tdiff4Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
