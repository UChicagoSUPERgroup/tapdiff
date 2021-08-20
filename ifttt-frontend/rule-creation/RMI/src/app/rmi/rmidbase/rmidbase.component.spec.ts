import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RmidbaseComponent } from './rmidbase.component';

describe('RmidbaseComponent', () => {
  let component: RmidbaseComponent;
  let fixture: ComponentFixture<RmidbaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RmidbaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RmidbaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
